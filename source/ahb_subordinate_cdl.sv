`timescale 1ns / 10ps

module ahb_subordinate_cdl #(
) (
    input logic clk, n_rst, hsel, 
    input logic inference_complete,
    input logic [9:0] haddr,
    input logic [1:0] htrans, 
    input logic [2:0] hsize,
    input logic hwrite,
    input logic [63:0] hwdata,

    output logic [63:0] hrdata,
    output logic hresp, hready,
    output logic [2:0] active_mode,
    output logic [63:0] bias,
    output logic [1:0] ctrl_reg,

    //from data buffer
    input logic hready_stall, occ_err,
    input logic [2:0] act_ctrl_out,
    input logic overrun_err,
    //from controller
    input logic [1:0] ctrl_reg_clear,
    input logic [1:0] status_reg_ctrl,
    //to controller
    output logic ahb_wr_weight,
    output logic ahb_wr_input,
    //from systolic
    input logic nan_err, inf_err,
    output logic clear_errors

);

    // address map
    localparam logic [9:0] ADDR_WEIGHT = 10'h000;
    localparam logic [9:0] ADDR_INPUT = 10'h008;
    localparam logic [9:0] ADDR_BIAS = 10'h010;
    localparam logic [9:0] ADDR_OUTPUT = 10'h018;
    localparam logic [9:0] ADDR_ERROR = 10'h020;
    localparam logic [9:0] ADDR_CONTROL = 10'h022;
    localparam logic [9:0] ADDR_STATUS = 10'h023;
    localparam logic [9:0] ADDR_ACTIV=10'h024;


    logic dph_valid;
    logic dph_write;
    logic [2:0] dph_hsize;
    logic [9:0] dph_haddr;
    logic dph_error;
    logic dph_stall; // capture hready_stall at addr phase

    logic addr_active;
    assign addr_active = hsel && (htrans ==2'b10 || htrans==2'b11);
    
    logic [9:0] addr_base;
    assign addr_base = {haddr[9:3],3'b000};
    //valid address check
    logic addr_valid;
    always_comb begin
        case(haddr)
            10'h000, 10'h001, 10'h002, 10'h003,
            10'h004, 10'h005, 10'h006, 10'h007,
            10'h008, 10'h009, 10'h00A, 10'h00B,
            10'h00C, 10'h00D, 10'h00E, 10'h00F,
            10'h010, 10'h011, 10'h012, 10'h013,
            10'h014, 10'h015, 10'h016, 10'h017,
            10'h018, 10'h019, 10'h01A, 10'h01B,
            10'h01C, 10'h01D, 10'h01E, 10'h01F,
            10'h020, 10'h021, 10'h022, 10'h023, 10'h024: addr_valid =1'b1;
            default: addr_valid = 1'b0;
        endcase
    end
    // write to read only check
    logic write_ro;
    always_comb begin
        write_ro = 1'b0;
        if(hwrite)begin
            case(haddr)
                10'h018,10'h019,10'h01A,10'h01B,
                10'h01C,10'h01D,10'h01E,10'h01F,
                10'h020,10'h021: write_ro =1'b1;
                default: write_ro =1'b0;
            endcase
        end
    end
    logic sram_access;
    assign sram_access = (haddr[9:5]==5'h00);

    // busy stall
    logic addr_error;
    assign addr_error = addr_active && (!addr_valid || write_ro||(occ_err&&sram_access));
    
    //error response state machine
    typedef enum logic [1:0] {ERR_IDLE,ERR_CYC1, ERR_CYC2} err_state_t;
    err_state_t err_state, err_next;

    always_ff @(posedge clk,negedge n_rst) begin
        if(!n_rst)begin
            err_state <= ERR_IDLE;
        end else begin
            err_state <= err_next;
        end
    end
    always_comb begin 
        err_next = err_state;
        case(err_state)
            ERR_IDLE: begin
                if(addr_error) err_next =ERR_CYC1;
            end
            ERR_CYC1: err_next = ERR_CYC2;
            ERR_CYC2: err_next = ERR_IDLE;
            default: err_next = ERR_IDLE;
        endcase
    end
    // assign hresp = (err_state ==ERR_CYC1||err_state==ERR_CYC2);
    // assign hready = (err_state!=ERR_CYC1) && !hready_stall;
    always_ff @(posedge clk, negedge n_rst)begin
        if(!n_rst) begin
            hresp <= 1'b0;
            hready <=1'b1;
        end else begin
            hresp <= (err_next == ERR_CYC1);
            if(err_next==ERR_CYC1)begin
                hready <= '0;
            end else if(dph_valid && hready_stall) begin
                hready <= '0;
            end else begin
                hready <=1'b1;
            end
        end
    end

    logic bus_ready;
    assign bus_ready = (err_state==ERR_IDLE) && !hready_stall;
    /// capture address phase into data phase pipeline regs
    always_ff @(posedge clk,negedge n_rst)begin
        if(!n_rst) begin
            dph_valid <= '0;
            dph_write <= '0;
            dph_hsize <= '0;
            dph_haddr <= '0;
            dph_error <= '0;
        end else if(bus_ready)begin
            dph_valid <= addr_active&&!addr_error;
            dph_write <= hwrite;
            dph_hsize <= hsize;
            dph_haddr <= haddr;
            dph_error <= addr_error;
        end
    end
    
    //internal regs
    logic [63:0] reg_bias;
    logic [1:0] reg_ctrl;
    logic [2:0] reg_act;
    logic[15:0] reg_err;
    logic [1:0] reg_status;

    assign reg_err = {6'h0,inf_err,nan_err,4'h0,occ_err,overrun_err,occ_err,1'b0};
    
    assign reg_status =status_reg_ctrl;
    //control reg
    always_ff @(posedge clk,negedge n_rst)begin
        if(!n_rst)begin
            reg_ctrl <= 2'b00;
            reg_bias <= '0;
            reg_act <= '0;
        end else begin
            if(ctrl_reg_clear[0]) begin
                reg_ctrl[0] <= '0;
            end
            if(ctrl_reg_clear[1]) begin
                reg_ctrl[1] <= '0;
            end
            // ahb writes in data phase
            if(dph_valid && dph_write && !dph_error)begin
                if(dph_haddr==10'h022) begin
                    reg_ctrl <= hwdata[17:16];
                end
                if(dph_haddr[9:3]==7'h002) begin //0x10 = bias register
                    reg_bias <= hwdata;
                end
                if(dph_haddr==10'h024) begin
                    reg_act <= hwdata[34:32];
                end
            end
        end
    end

    // output signals to controller
    assign ctrl_reg = reg_ctrl;
    assign bias = reg_bias;
    assign active_mode = reg_act;

    // pulse signals, assert for one cycle when valid write to respective register
    always_ff @(posedge clk, negedge n_rst)begin
        if(!n_rst) begin
            ahb_wr_weight <= 1'b0;
            ahb_wr_input <= 1'b0;
            clear_errors <=1'b0;
        end else begin
            ahb_wr_weight <= dph_valid && dph_write && !dph_error && (dph_haddr[9:3]==7'h000); //0x00
            ahb_wr_input <= dph_valid && dph_write && !dph_error && (dph_haddr[9:3]==7'h001); //0x08
            // clear_erros pulses when error reg is read
            clear_errors <= dph_valid && !dph_write && !dph_error && (dph_haddr[9:1]==9'h010);
        end
    end

    logic [63:0] read_data;
    always_comb begin
        read_data = 64'h0;
        if(addr_active && !hwrite && !addr_error) begin
            case(haddr[9:3])
                7'h002: read_data = reg_bias;
                7'h003: read_data=64'h0;
                default: begin
                    if(haddr ==10'h020) read_data={56'h0,reg_err[7:0]};
                    else if(haddr==10'h021) read_data = {48'h0,reg_err[15:8],8'h0};
                    else if(haddr==10'h022) read_data = {40'h0, 6'h0,reg_ctrl,16'h0};
                    else if(haddr==10'h023) begin
                        read_data ={32'h0,6'h0,reg_status,24'h0};
                    end
                    else if(haddr==10'h024) begin
                        read_data = {24'h0,5'h0,reg_act,32'h0};
                    end
                end
            endcase
        end
    end

    // raw hazard
    // logic [9:3] cur_base, dph_base;
    // assign cur_base = haddr[9:3];
    // assign dph_base=dph_haddr[9:3];
    logic raw_hazard;
    always_comb begin
        raw_hazard = 1'b0;
        if(dph_valid && dph_write && !dph_error && addr_active && !hwrite && !addr_error) begin
            if(haddr[9:3]<7'h004) raw_hazard = (haddr[9:3]==dph_haddr[9:3]);
            else raw_hazard =(haddr==dph_haddr);
        end
    end
    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst)begin
            hrdata <= '0;
        end else if(addr_active&&!hwrite&&!addr_error &&bus_ready) begin
            hrdata<= raw_hazard? hwdata: read_data;
        end
    end

endmodule

