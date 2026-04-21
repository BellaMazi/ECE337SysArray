module sram1024x32_wrapper (
    input logic clk, n_rst,
    input logic [9:0] address,
    input logic read_enable, write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data,
    output logic [1:0] sram_state
);
    parameter BAD = 32'hBAD1BAD1;

    parameter FREE = 2'h0;
    parameter BUSY = 2'h1;
    parameter ACCESS = 2'h2;
    parameter ERROR = 2'h3;

    logic [31:0] old_write_data;
    logic [9:0]  old_address;
    logic [31:0] q;
    logic [9:0]  addr = '0;
    logic        wren;
    logic        ac, dc, ec;
    logic        prev_wen, prev_ren;

    typedef enum logic [3:0] {IDLE, R0, R1, R2, RC, W0, W1, W2, WC, ERR} state_t;
    state_t state, next_state;

    always_comb begin
        sram_state = ERROR;
        if(state == IDLE) sram_state = FREE;
        else if(
            state == R0 || state == R1 || state == R2 ||
            state == W0 || state == W1 || state == W2
        ) sram_state = BUSY;
        else if(state == RC || state == WC) sram_state = ACCESS;
        else if(state == ERR) sram_state = ERROR;
    end

    assign read_data = state == RC ? q : BAD;

    assign ac = old_address != address;
    assign dc = old_write_data != write_data;
    assign ec = (prev_wen != write_enable) || (prev_ren != read_enable);

    assign wren = (state == W2) && write_enable && ~(ac || dc);

    always_comb begin : next_state_logic
        next_state = state;
        case (state)
            IDLE: begin
            end
            R0: begin
                if(read_enable && ~ac) next_state = R1;
            end
            R1: begin
                if(read_enable && ~ac) next_state = R2;
            end
            R2: begin
                if(read_enable && ~ac) next_state = RC;
            end
            RC: begin
                next_state = RC;
            end
            W0: begin
                if(write_enable && ~(ac || dc)) next_state = W1;
            end
            W1: begin
                if(write_enable && ~(ac || dc)) next_state = W2;
            end
            W2: begin
                if(write_enable && ~(ac || dc)) next_state = WC;
            end
            WC: begin
                next_state = WC;
            end
            default: begin
                next_state = ERR;
            end
        endcase
        
        if(read_enable & ~write_enable && (ac || ec)) next_state = R0;
        if(write_enable & ~read_enable && (ac || dc || ec)) next_state = W0;
        if(read_enable & write_enable) next_state = ERR;
        if(~read_enable & ~write_enable) next_state = IDLE;
    end

    logic [1023:0][31:0] memory, next_memory;

    always_comb begin
        next_memory = memory;
        if (wren) next_memory[address] = write_data;
    end

    assign q = memory[old_address];

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            old_write_data <= '0;
            old_address <= '0;
            state <= IDLE;
            prev_wen <= '0;
            prev_ren <= '0;
            memory <= 'x;
        end else begin
            old_write_data <= write_data;
            old_address <= address;
            state <= next_state;
            prev_wen <= write_enable;
            prev_ren <= read_enable;
            memory <= next_memory;
        end
    end
endmodule

