`timescale 1ns / 10ps

module sysArr_top #(
    // parameters
) (
    input logic clk, n_rst,
    input logic hsel,
    input logic [9:0]  haddr,
    input logic [1:0] htrans,
    input logic [1:0] hsize,
    input logic hwrite,
    input logic [63:0] hwdata,
    output logic [63:0] hrdata,
    output logic hready,
    output logic hresp
);

    //temps
    logic [1:0] temp1;
    //logic hsel;

    //from ahb -> controller
    logic [1:0] ctrl_reg;
    logic [2:0] active_mode;
    logic [63:0] bias;
    logic [1:0] ctrl_reg_clear;
    logic [1:0] status_reg_ctrl;
    logic ahb_wr_weight;
    logic ahb_wr_input;
    logic clear_errors;

    //abh-> dataBuffer
    logic hready_stall;
    logic occ_err;
    logic overrun_err;

    //controller -> dataBuffer
    logic sram_rd_en;
    logic sram_wr_en;
    logic [9:0] sram_addr;
    logic [63:0] sram_wr_data;
    logic [63:0] sram_rd_data;
    logic [1:0] sram_state;

    
    //controller -> sysarr
    logic load_weights;
    logic run_array;
    logic [63:0] input_vec;
    logic data_out_valid;
    logic [63:0] array_outputs;

    //bias adder outputs
    logic [63:0] bias_out;
    logic bias_valid_out;

    //activations
    logic inference_complete;
    logic [63:0] activations;

    //systolic-array err flags

    logic nan_err;
    logic inf_err;
    assign nan_err = 1'b0;
    assign inf_err = 1'b0;

    ahb_subordinate_cdl ahb_sub( .clk(clk), .n_rst(n_rst), .hsel(hsel),
    .haddr(haddr), .htrans(htrans), .hwrite(hwrite), .hsize({1'b0, hsize}), .hwdata(hwdata), 
    .hrdata(hrdata), .hresp(hresp), .hready(hready), .active_mode(active_mode), 
    .bias(bias), .ctrl_reg(ctrl_reg), .hready_stall(hready_stall), .occ_err(occ_err), .overrun_err(overrun_err), .ctrl_reg_clear(ctrl_reg_clear), 
    .status_reg_ctrl(status_reg_ctrl), .ahb_wr_weight(ahb_wr_weight), .ahb_wr_input(ahb_wr_input), 
    .nan_err(nan_err), .inf_err(inf_err), .clear_errors(clear_errors));

    sysController controller(.clk(clk), .n_rst(n_rst), .ctrl_reg(ctrl_reg), 
    .act_ctrl(active_mode[1:0]), .hwdata(hwdata), .ahb_wr_weight(ahb_wr_weight), 
    .ahb_wr_input(ahb_wr_input), .sram_rd_data(sram_rd_data), .sram_state(sram_state), .activations(activations), 
    .sram_rd_en(sram_rd_en), .sram_wr_en(sram_wr_en), .sram_addr(sram_addr), .sram_wr_data(sram_wr_data), 
    .load_weights(load_weights), .run_array(run_array), .input_vec(input_vec), .ctrl_reg_clear(ctrl_reg_clear), 
    .status_reg(status_reg_ctrl), .act_ctrl_out(temp1));

    dataBuffer buff(.clk(clk), .n_rst(n_rst), .sram_rd_en(sram_rd_en), .sram_wr_en(sram_wr_en),  
    .sram_addr(sram_addr), .sram_wr_data(sram_wr_data), .ctrl_reg_clear(ctrl_reg_clear), 
    .ctrl_reg_0(ctrl_reg[0]), .haddr(haddr), .hwdata(hwdata), .hwrite(hwrite), 
    .ahb_req(hsel && (htrans == 2'b10 || htrans == 2'b11)),.sram_rd_data(sram_rd_data), 
    .sram_state_out(sram_state), .hready_stall(hready_stall), .occ_err(occ_err), 
    .overrun_err(overrun_err));

    systolic_array sysArr(.clk(clk), .n_rst(n_rst), 
    .load_weights(load_weights), .run_array(run_array), .input_vec(input_vec), 
    .data_out_valid(data_out_valid), .outputs(array_outputs));

    bias_adder biasMod(.clk(clk), .n_rst(n_rst), .data_out_valid(data_out_valid), 
    .outputs(array_outputs), .bias(bias), .bias_out(bias_out), .bias_valid_out(bias_valid_out));

    activation act(.clk(clk), .n_rst(n_rst), .bias_valid_out(bias_valid_out), 
    .active_mode(active_mode), .bias_out(bias_out), .inference_complete(inference_complete), 
    .activations(activations)); 


endmodule

