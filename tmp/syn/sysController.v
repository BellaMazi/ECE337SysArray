/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Fri Apr 17 13:46:19 2026
/////////////////////////////////////////////////////////////


module sysController ( clk, n_rst, ctrl_reg, act_ctrl, hwdata, ahb_wr_weight, 
        ahb_wr_input, sram_rd_data, sram_state, activations, sram_rd_en, 
        sram_wr_en, sram_addr, sram_wr_data, load_weights, run_array, 
        input_vec, ctrl_reg_clear, status_reg, act_ctrl_out );
  input [1:0] ctrl_reg;
  input [1:0] act_ctrl;
  input [63:0] hwdata;
  input [63:0] sram_rd_data;
  input [1:0] sram_state;
  input [63:0] activations;
  output [9:0] sram_addr;
  output [63:0] sram_wr_data;
  output [63:0] input_vec;
  output [1:0] ctrl_reg_clear;
  output [1:0] status_reg;
  output [1:0] act_ctrl_out;
  input clk, n_rst, ahb_wr_weight, ahb_wr_input;
  output sram_rd_en, sram_wr_en, load_weights, run_array;
  wire   \act_ctrl_out[1] , \act_ctrl_out[0] , N50, N51, N52, ahb_store_en,
         N533, N534, N535, N677, N678, N679, n434, n435, n436, n437, n438,
         n439, n440, n441, n442, n443, n444, n445, n446, n447, n448, n449,
         n450, n451, n452, n453, n454, n455, n456, n457, n458, n459, n460,
         n461, n462, n463, n464, n465, n466, n467, n468, n469, n470, n471,
         n472, n473, n474, n475, n476, n477, n478, n479, n480, n481, n482,
         n483, n484, n485, n486, n487, n488, n489, n490, n491, n492, n493,
         n494, n495, n496, n497, n498, n499, n500, n501, n502, n503, n504,
         n505, n506, n507, n508, n509, n510, n511, n512, n513, n514, n515,
         n516, n517, n518, n519, n520, n521, n522, n523, n524, n525, n526,
         n527, n528, n529, n530, n531, n532, n533, n534, n535, n536, n537,
         n538, n539, n540, n541, n542, n543, n544, n545, n546, n547, n548,
         n549, n550, n551, n552, n553, n554, n555, n556, n557, n558, n559,
         n560, n561, n562, n563, n564, n565, n566, n567, n568, n569, n570,
         n571, n572, n573, n574, n575, n576, n577, n578, n579, n580, n581,
         n582, n583, n584, n585, n586, n587, n588, n589, n590, n591, n592,
         n593, n594, n595, n596, n597, n598, n599, n600, n601, n602, n603,
         n604, n605, n606, n607, n608, n609, n610, n611, n612, n613, n614,
         n615, n616, n617, n618, n619, n620, n621, n622, n623, n624, n625,
         n626, n627, n628, n629, n630, n631, n632, n633, n634, n635, n636,
         n637, n638, n639, n640, n641, n642, n643, n644, n645, n646, n647,
         n648, n649, n650, n651, n652, n653, n654, n655, n656, n657, n658,
         n659, n660, n661, n662, n663, n664, n665, n666, n667, n668, n669,
         n670, n671, n672, n673, n674, n675, n676, n677, n678, n679, n680,
         n681, n682, n683, n684, n685, n686, n687, n688, n689, n690, n691,
         n692, n693, n694, n695, n696, n697, n698, n699, n700, n701, n702,
         n703, n704, n705, n706, n707, n708;
  wire   [3:0] state;
  wire   [5:0] wt_counter;
  wire   [5:0] lat_counter;
  wire   [5:0] wt_wr_ptr;
  wire   [7:0] next_ahb_store_addr;
  wire   [63:0] next_ahb_store_data;
  wire   [9:0] ahb_store_addr;
  wire   [63:0] ahb_store_data;
  assign sram_addr[9] = 1'b0;
  assign sram_addr[8] = 1'b0;
  assign act_ctrl_out[1] = \act_ctrl_out[1] ;
  assign \act_ctrl_out[1]  = act_ctrl[1];
  assign act_ctrl_out[0] = \act_ctrl_out[0] ;
  assign \act_ctrl_out[0]  = act_ctrl[0];
  assign sram_addr[7] = 1'b0;

  DFFSR \out_counter_reg[0]  ( .D(n459), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N677) );
  DFFSR \out_counter_reg[1]  ( .D(n453), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N678) );
  DFFSR \out_counter_reg[2]  ( .D(n458), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N679) );
  DFFSR \state_reg[3]  ( .D(n457), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[3]) );
  DFFSR \state_reg[2]  ( .D(n456), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[2]) );
  DFFSR \wt_counter_reg[0]  ( .D(n452), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_counter[0]) );
  DFFSR \state_reg[1]  ( .D(n455), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[1]) );
  DFFSR \state_reg[0]  ( .D(n454), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[0]) );
  DFFSR \ahb_store_data_reg[9]  ( .D(next_ahb_store_data[9]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[9]) );
  DFFSR \ahb_store_data_reg[8]  ( .D(next_ahb_store_data[8]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[8]) );
  DFFSR \ahb_store_data_reg[7]  ( .D(next_ahb_store_data[7]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[7]) );
  DFFSR \ahb_store_data_reg[6]  ( .D(next_ahb_store_data[6]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[6]) );
  DFFSR \ahb_store_data_reg[63]  ( .D(next_ahb_store_data[63]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[63]) );
  DFFSR \ahb_store_data_reg[62]  ( .D(next_ahb_store_data[62]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[62]) );
  DFFSR \ahb_store_data_reg[61]  ( .D(next_ahb_store_data[61]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[61]) );
  DFFSR \ahb_store_data_reg[60]  ( .D(next_ahb_store_data[60]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[60]) );
  DFFSR \ahb_store_data_reg[5]  ( .D(next_ahb_store_data[5]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[5]) );
  DFFSR \ahb_store_data_reg[59]  ( .D(next_ahb_store_data[59]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[59]) );
  DFFSR \ahb_store_data_reg[58]  ( .D(next_ahb_store_data[58]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[58]) );
  DFFSR \ahb_store_data_reg[57]  ( .D(next_ahb_store_data[57]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[57]) );
  DFFSR \ahb_store_data_reg[56]  ( .D(next_ahb_store_data[56]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[56]) );
  DFFSR \ahb_store_data_reg[55]  ( .D(next_ahb_store_data[55]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[55]) );
  DFFSR \ahb_store_data_reg[54]  ( .D(next_ahb_store_data[54]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[54]) );
  DFFSR \ahb_store_data_reg[53]  ( .D(next_ahb_store_data[53]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[53]) );
  DFFSR \ahb_store_data_reg[52]  ( .D(next_ahb_store_data[52]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[52]) );
  DFFSR \ahb_store_data_reg[51]  ( .D(next_ahb_store_data[51]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[51]) );
  DFFSR \ahb_store_data_reg[50]  ( .D(next_ahb_store_data[50]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[50]) );
  DFFSR \ahb_store_data_reg[4]  ( .D(next_ahb_store_data[4]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[4]) );
  DFFSR \ahb_store_data_reg[49]  ( .D(next_ahb_store_data[49]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[49]) );
  DFFSR \ahb_store_data_reg[48]  ( .D(next_ahb_store_data[48]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[48]) );
  DFFSR \ahb_store_data_reg[47]  ( .D(next_ahb_store_data[47]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[47]) );
  DFFSR \ahb_store_data_reg[46]  ( .D(next_ahb_store_data[46]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[46]) );
  DFFSR \ahb_store_data_reg[45]  ( .D(next_ahb_store_data[45]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[45]) );
  DFFSR \ahb_store_data_reg[44]  ( .D(next_ahb_store_data[44]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[44]) );
  DFFSR \ahb_store_data_reg[43]  ( .D(next_ahb_store_data[43]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[43]) );
  DFFSR \ahb_store_data_reg[42]  ( .D(next_ahb_store_data[42]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[42]) );
  DFFSR \ahb_store_data_reg[41]  ( .D(next_ahb_store_data[41]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[41]) );
  DFFSR \ahb_store_data_reg[40]  ( .D(next_ahb_store_data[40]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[40]) );
  DFFSR \ahb_store_data_reg[3]  ( .D(next_ahb_store_data[3]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[3]) );
  DFFSR \ahb_store_data_reg[39]  ( .D(next_ahb_store_data[39]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[39]) );
  DFFSR \ahb_store_data_reg[38]  ( .D(next_ahb_store_data[38]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[38]) );
  DFFSR \ahb_store_data_reg[37]  ( .D(next_ahb_store_data[37]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[37]) );
  DFFSR \ahb_store_data_reg[36]  ( .D(next_ahb_store_data[36]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[36]) );
  DFFSR \ahb_store_data_reg[35]  ( .D(next_ahb_store_data[35]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[35]) );
  DFFSR \ahb_store_data_reg[34]  ( .D(next_ahb_store_data[34]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[34]) );
  DFFSR \ahb_store_data_reg[33]  ( .D(next_ahb_store_data[33]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[33]) );
  DFFSR \ahb_store_data_reg[32]  ( .D(next_ahb_store_data[32]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[32]) );
  DFFSR \ahb_store_data_reg[31]  ( .D(next_ahb_store_data[31]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[31]) );
  DFFSR \ahb_store_data_reg[30]  ( .D(next_ahb_store_data[30]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[30]) );
  DFFSR \ahb_store_data_reg[2]  ( .D(next_ahb_store_data[2]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[2]) );
  DFFSR \ahb_store_data_reg[29]  ( .D(next_ahb_store_data[29]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[29]) );
  DFFSR \ahb_store_data_reg[28]  ( .D(next_ahb_store_data[28]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[28]) );
  DFFSR \ahb_store_data_reg[27]  ( .D(next_ahb_store_data[27]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[27]) );
  DFFSR \ahb_store_data_reg[26]  ( .D(next_ahb_store_data[26]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[26]) );
  DFFSR \ahb_store_data_reg[25]  ( .D(next_ahb_store_data[25]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[25]) );
  DFFSR \ahb_store_data_reg[24]  ( .D(next_ahb_store_data[24]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[24]) );
  DFFSR \ahb_store_data_reg[23]  ( .D(next_ahb_store_data[23]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[23]) );
  DFFSR \ahb_store_data_reg[22]  ( .D(next_ahb_store_data[22]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[22]) );
  DFFSR \ahb_store_data_reg[21]  ( .D(next_ahb_store_data[21]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[21]) );
  DFFSR \ahb_store_data_reg[20]  ( .D(next_ahb_store_data[20]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[20]) );
  DFFSR \ahb_store_data_reg[1]  ( .D(next_ahb_store_data[1]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[1]) );
  DFFSR \ahb_store_data_reg[19]  ( .D(next_ahb_store_data[19]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[19]) );
  DFFSR \ahb_store_data_reg[18]  ( .D(next_ahb_store_data[18]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[18]) );
  DFFSR \ahb_store_data_reg[17]  ( .D(next_ahb_store_data[17]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[17]) );
  DFFSR \ahb_store_data_reg[16]  ( .D(next_ahb_store_data[16]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[16]) );
  DFFSR \ahb_store_data_reg[15]  ( .D(next_ahb_store_data[15]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[15]) );
  DFFSR \ahb_store_data_reg[14]  ( .D(next_ahb_store_data[14]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[14]) );
  DFFSR \ahb_store_data_reg[13]  ( .D(next_ahb_store_data[13]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[13]) );
  DFFSR \ahb_store_data_reg[12]  ( .D(next_ahb_store_data[12]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[12]) );
  DFFSR \ahb_store_data_reg[11]  ( .D(next_ahb_store_data[11]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[11]) );
  DFFSR \ahb_store_data_reg[10]  ( .D(next_ahb_store_data[10]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[10]) );
  DFFSR \ahb_store_data_reg[0]  ( .D(next_ahb_store_data[0]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_data[0]) );
  DFFSR \lat_counter_reg[0]  ( .D(n701), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        lat_counter[0]) );
  DFFSR \lat_counter_reg[1]  ( .D(n702), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        lat_counter[1]) );
  DFFSR \lat_counter_reg[2]  ( .D(n703), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        lat_counter[2]) );
  DFFSR \lat_counter_reg[3]  ( .D(n704), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        lat_counter[3]) );
  DFFSR \lat_counter_reg[4]  ( .D(n705), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        lat_counter[4]) );
  DFFSR \lat_counter_reg[5]  ( .D(n706), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        lat_counter[5]) );
  DFFSR \row_counter_reg[0]  ( .D(n446), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N533) );
  DFFSR \row_counter_reg[1]  ( .D(n445), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N534) );
  DFFSR \row_counter_reg[2]  ( .D(n444), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        N535) );
  DFFSR \wt_counter_reg[5]  ( .D(n447), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_counter[5]) );
  DFFSR \wt_counter_reg[1]  ( .D(n451), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_counter[1]) );
  DFFSR \wt_counter_reg[2]  ( .D(n450), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_counter[2]) );
  DFFSR \wt_counter_reg[3]  ( .D(n449), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_counter[3]) );
  DFFSR \wt_counter_reg[4]  ( .D(n448), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_counter[4]) );
  DFFSR \status_ff_reg[1]  ( .D(n443), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        status_reg[1]) );
  DFFSR \status_ff_reg[0]  ( .D(n442), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        status_reg[0]) );
  DFFSR \wt_wr_ptr_reg[0]  ( .D(n441), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_wr_ptr[0]) );
  DFFSR \wt_wr_ptr_reg[5]  ( .D(n440), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_wr_ptr[5]) );
  DFFSR \wt_wr_ptr_reg[4]  ( .D(n436), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_wr_ptr[4]) );
  DFFSR \wt_wr_ptr_reg[3]  ( .D(n437), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_wr_ptr[3]) );
  DFFSR \wt_wr_ptr_reg[2]  ( .D(n438), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_wr_ptr[2]) );
  DFFSR \wt_wr_ptr_reg[1]  ( .D(n439), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        wt_wr_ptr[1]) );
  DFFSR \in_wr_ptr_reg[0]  ( .D(n435), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N50)
         );
  DFFSR \in_wr_ptr_reg[1]  ( .D(n434), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N51)
         );
  DFFSR \in_wr_ptr_reg[2]  ( .D(n707), .CLK(clk), .R(n_rst), .S(1'b1), .Q(N52)
         );
  DFFSR ahb_store_en_reg ( .D(n463), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        ahb_store_en) );
  DFFSR \ahb_store_addr_reg[6]  ( .D(n708), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(ahb_store_addr[6]) );
  DFFSR \ahb_store_addr_reg[5]  ( .D(next_ahb_store_addr[5]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_addr[5]) );
  DFFSR \ahb_store_addr_reg[4]  ( .D(next_ahb_store_addr[4]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_addr[4]) );
  DFFSR \ahb_store_addr_reg[3]  ( .D(next_ahb_store_addr[3]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_addr[3]) );
  DFFSR \ahb_store_addr_reg[2]  ( .D(next_ahb_store_addr[2]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_addr[2]) );
  DFFSR \ahb_store_addr_reg[1]  ( .D(next_ahb_store_addr[1]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_addr[1]) );
  DFFSR \ahb_store_addr_reg[0]  ( .D(next_ahb_store_addr[0]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(ahb_store_addr[0]) );
  AND2X2 U601 ( .A(n592), .B(n587), .Y(n460) );
  AND2X2 U602 ( .A(n480), .B(n481), .Y(n461) );
  OR2X2 U603 ( .A(n479), .B(n633), .Y(n462) );
  INVX4 U604 ( .A(n461), .Y(n463) );
  INVX4 U605 ( .A(n462), .Y(n464) );
  INVX8 U606 ( .A(n460), .Y(n465) );
  INVX8 U607 ( .A(n466), .Y(n469) );
  NAND2X1 U609 ( .A(n460), .B(n466), .Y(sram_wr_en) );
  NAND2X1 U610 ( .A(n467), .B(n468), .Y(sram_addr[6]) );
  AOI21X1 U611 ( .A(ahb_store_addr[6]), .B(n469), .C(n465), .Y(n467) );
  NAND2X1 U612 ( .A(n470), .B(n460), .Y(sram_addr[3]) );
  AOI22X1 U613 ( .A(ahb_store_addr[3]), .B(n469), .C(wt_counter[3]), .D(n471), 
        .Y(n470) );
  NAND2X1 U614 ( .A(n472), .B(n473), .Y(sram_addr[2]) );
  AOI22X1 U615 ( .A(ahb_store_addr[2]), .B(n469), .C(N679), .D(n465), .Y(n473)
         );
  AOI22X1 U616 ( .A(wt_counter[2]), .B(n471), .C(N535), .D(n474), .Y(n472) );
  NAND2X1 U617 ( .A(n475), .B(n476), .Y(sram_addr[1]) );
  AOI22X1 U618 ( .A(ahb_store_addr[1]), .B(n469), .C(N678), .D(n465), .Y(n476)
         );
  AOI22X1 U619 ( .A(wt_counter[1]), .B(n471), .C(N534), .D(n474), .Y(n475) );
  NAND2X1 U620 ( .A(n477), .B(n478), .Y(sram_addr[0]) );
  AOI22X1 U621 ( .A(ahb_store_addr[0]), .B(n469), .C(N677), .D(n465), .Y(n478)
         );
  AOI22X1 U622 ( .A(wt_counter[0]), .B(n471), .C(N533), .D(n474), .Y(n477) );
  NOR2X1 U623 ( .A(n468), .B(n479), .Y(run_array) );
  AND2X1 U624 ( .A(hwdata[9]), .B(n463), .Y(next_ahb_store_data[9]) );
  AND2X1 U625 ( .A(hwdata[8]), .B(n463), .Y(next_ahb_store_data[8]) );
  AND2X1 U626 ( .A(hwdata[7]), .B(n463), .Y(next_ahb_store_data[7]) );
  AND2X1 U627 ( .A(hwdata[6]), .B(n463), .Y(next_ahb_store_data[6]) );
  AND2X1 U628 ( .A(hwdata[63]), .B(n463), .Y(next_ahb_store_data[63]) );
  AND2X1 U629 ( .A(hwdata[62]), .B(n463), .Y(next_ahb_store_data[62]) );
  AND2X1 U630 ( .A(hwdata[61]), .B(n463), .Y(next_ahb_store_data[61]) );
  AND2X1 U631 ( .A(hwdata[60]), .B(n463), .Y(next_ahb_store_data[60]) );
  AND2X1 U632 ( .A(hwdata[5]), .B(n463), .Y(next_ahb_store_data[5]) );
  AND2X1 U633 ( .A(hwdata[59]), .B(n463), .Y(next_ahb_store_data[59]) );
  AND2X1 U634 ( .A(hwdata[58]), .B(n463), .Y(next_ahb_store_data[58]) );
  AND2X1 U635 ( .A(hwdata[57]), .B(n463), .Y(next_ahb_store_data[57]) );
  AND2X1 U636 ( .A(hwdata[56]), .B(n463), .Y(next_ahb_store_data[56]) );
  AND2X1 U637 ( .A(hwdata[55]), .B(n463), .Y(next_ahb_store_data[55]) );
  AND2X1 U638 ( .A(hwdata[54]), .B(n463), .Y(next_ahb_store_data[54]) );
  AND2X1 U639 ( .A(hwdata[53]), .B(n463), .Y(next_ahb_store_data[53]) );
  AND2X1 U640 ( .A(hwdata[52]), .B(n463), .Y(next_ahb_store_data[52]) );
  AND2X1 U641 ( .A(hwdata[51]), .B(n463), .Y(next_ahb_store_data[51]) );
  AND2X1 U642 ( .A(hwdata[50]), .B(n463), .Y(next_ahb_store_data[50]) );
  AND2X1 U643 ( .A(hwdata[4]), .B(n463), .Y(next_ahb_store_data[4]) );
  AND2X1 U644 ( .A(hwdata[49]), .B(n463), .Y(next_ahb_store_data[49]) );
  AND2X1 U645 ( .A(hwdata[48]), .B(n463), .Y(next_ahb_store_data[48]) );
  AND2X1 U646 ( .A(hwdata[47]), .B(n463), .Y(next_ahb_store_data[47]) );
  AND2X1 U647 ( .A(hwdata[46]), .B(n463), .Y(next_ahb_store_data[46]) );
  AND2X1 U648 ( .A(hwdata[45]), .B(n463), .Y(next_ahb_store_data[45]) );
  AND2X1 U649 ( .A(hwdata[44]), .B(n463), .Y(next_ahb_store_data[44]) );
  AND2X1 U650 ( .A(hwdata[43]), .B(n463), .Y(next_ahb_store_data[43]) );
  AND2X1 U651 ( .A(hwdata[42]), .B(n463), .Y(next_ahb_store_data[42]) );
  AND2X1 U652 ( .A(hwdata[41]), .B(n463), .Y(next_ahb_store_data[41]) );
  AND2X1 U653 ( .A(hwdata[40]), .B(n463), .Y(next_ahb_store_data[40]) );
  AND2X1 U654 ( .A(hwdata[3]), .B(n463), .Y(next_ahb_store_data[3]) );
  AND2X1 U655 ( .A(hwdata[39]), .B(n463), .Y(next_ahb_store_data[39]) );
  AND2X1 U656 ( .A(hwdata[38]), .B(n463), .Y(next_ahb_store_data[38]) );
  AND2X1 U657 ( .A(hwdata[37]), .B(n463), .Y(next_ahb_store_data[37]) );
  AND2X1 U658 ( .A(hwdata[36]), .B(n463), .Y(next_ahb_store_data[36]) );
  AND2X1 U659 ( .A(hwdata[35]), .B(n463), .Y(next_ahb_store_data[35]) );
  AND2X1 U660 ( .A(hwdata[34]), .B(n463), .Y(next_ahb_store_data[34]) );
  AND2X1 U661 ( .A(hwdata[33]), .B(n463), .Y(next_ahb_store_data[33]) );
  AND2X1 U662 ( .A(hwdata[32]), .B(n463), .Y(next_ahb_store_data[32]) );
  AND2X1 U663 ( .A(hwdata[31]), .B(n463), .Y(next_ahb_store_data[31]) );
  AND2X1 U664 ( .A(hwdata[30]), .B(n463), .Y(next_ahb_store_data[30]) );
  AND2X1 U665 ( .A(hwdata[2]), .B(n463), .Y(next_ahb_store_data[2]) );
  AND2X1 U666 ( .A(hwdata[29]), .B(n463), .Y(next_ahb_store_data[29]) );
  AND2X1 U667 ( .A(hwdata[28]), .B(n463), .Y(next_ahb_store_data[28]) );
  AND2X1 U668 ( .A(hwdata[27]), .B(n463), .Y(next_ahb_store_data[27]) );
  AND2X1 U669 ( .A(hwdata[26]), .B(n463), .Y(next_ahb_store_data[26]) );
  AND2X1 U670 ( .A(hwdata[25]), .B(n463), .Y(next_ahb_store_data[25]) );
  AND2X1 U671 ( .A(hwdata[24]), .B(n463), .Y(next_ahb_store_data[24]) );
  AND2X1 U672 ( .A(hwdata[23]), .B(n463), .Y(next_ahb_store_data[23]) );
  AND2X1 U673 ( .A(hwdata[22]), .B(n463), .Y(next_ahb_store_data[22]) );
  AND2X1 U674 ( .A(hwdata[21]), .B(n463), .Y(next_ahb_store_data[21]) );
  AND2X1 U675 ( .A(hwdata[20]), .B(n463), .Y(next_ahb_store_data[20]) );
  AND2X1 U676 ( .A(hwdata[1]), .B(n463), .Y(next_ahb_store_data[1]) );
  AND2X1 U677 ( .A(hwdata[19]), .B(n463), .Y(next_ahb_store_data[19]) );
  AND2X1 U678 ( .A(hwdata[18]), .B(n463), .Y(next_ahb_store_data[18]) );
  AND2X1 U679 ( .A(hwdata[17]), .B(n463), .Y(next_ahb_store_data[17]) );
  AND2X1 U680 ( .A(hwdata[16]), .B(n463), .Y(next_ahb_store_data[16]) );
  AND2X1 U681 ( .A(hwdata[15]), .B(n463), .Y(next_ahb_store_data[15]) );
  AND2X1 U682 ( .A(hwdata[14]), .B(n463), .Y(next_ahb_store_data[14]) );
  AND2X1 U683 ( .A(hwdata[13]), .B(n463), .Y(next_ahb_store_data[13]) );
  AND2X1 U684 ( .A(hwdata[12]), .B(n463), .Y(next_ahb_store_data[12]) );
  AND2X1 U685 ( .A(hwdata[11]), .B(n463), .Y(next_ahb_store_data[11]) );
  AND2X1 U686 ( .A(hwdata[10]), .B(n463), .Y(next_ahb_store_data[10]) );
  AND2X1 U687 ( .A(hwdata[0]), .B(n463), .Y(next_ahb_store_data[0]) );
  NOR2X1 U688 ( .A(n481), .B(n482), .Y(next_ahb_store_addr[5]) );
  AND2X1 U689 ( .A(n483), .B(wt_wr_ptr[4]), .Y(next_ahb_store_addr[4]) );
  AND2X1 U690 ( .A(n483), .B(wt_wr_ptr[3]), .Y(next_ahb_store_addr[3]) );
  OAI22X1 U691 ( .A(n480), .B(n484), .C(n481), .D(n485), .Y(
        next_ahb_store_addr[2]) );
  INVX1 U692 ( .A(wt_wr_ptr[2]), .Y(n485) );
  INVX1 U693 ( .A(n486), .Y(next_ahb_store_addr[1]) );
  AOI22X1 U694 ( .A(n708), .B(N51), .C(n483), .D(wt_wr_ptr[1]), .Y(n486) );
  OAI22X1 U695 ( .A(n480), .B(n487), .C(n481), .D(n488), .Y(
        next_ahb_store_addr[0]) );
  MUX2X1 U696 ( .B(n489), .A(n490), .S(lat_counter[0]), .Y(n701) );
  MUX2X1 U697 ( .B(n491), .A(n492), .S(lat_counter[1]), .Y(n702) );
  NAND2X1 U698 ( .A(lat_counter[0]), .B(n493), .Y(n491) );
  MUX2X1 U699 ( .B(n494), .A(n495), .S(lat_counter[2]), .Y(n703) );
  INVX1 U700 ( .A(n496), .Y(n495) );
  OAI21X1 U701 ( .A(n489), .B(lat_counter[1]), .C(n492), .Y(n496) );
  INVX1 U702 ( .A(n497), .Y(n492) );
  OAI21X1 U703 ( .A(lat_counter[0]), .B(n489), .C(n490), .Y(n497) );
  NAND3X1 U704 ( .A(lat_counter[0]), .B(n493), .C(lat_counter[1]), .Y(n494) );
  MUX2X1 U705 ( .B(n498), .A(n499), .S(lat_counter[3]), .Y(n704) );
  NAND2X1 U706 ( .A(n500), .B(n493), .Y(n498) );
  INVX1 U707 ( .A(n501), .Y(n705) );
  MUX2X1 U708 ( .B(n502), .A(n503), .S(lat_counter[4]), .Y(n501) );
  MUX2X1 U709 ( .B(n504), .A(n505), .S(lat_counter[5]), .Y(n706) );
  AOI21X1 U710 ( .A(n493), .B(n506), .C(n503), .Y(n505) );
  OAI21X1 U711 ( .A(lat_counter[3]), .B(n489), .C(n499), .Y(n503) );
  AOI21X1 U712 ( .A(n507), .B(n493), .C(n508), .Y(n499) );
  INVX1 U713 ( .A(lat_counter[4]), .Y(n506) );
  NAND2X1 U714 ( .A(n502), .B(lat_counter[4]), .Y(n504) );
  INVX1 U715 ( .A(n509), .Y(n502) );
  NAND3X1 U716 ( .A(n500), .B(n493), .C(lat_counter[3]), .Y(n509) );
  INVX1 U717 ( .A(n507), .Y(n500) );
  NAND3X1 U718 ( .A(lat_counter[1]), .B(lat_counter[0]), .C(lat_counter[2]), 
        .Y(n507) );
  OAI21X1 U719 ( .A(n510), .B(n511), .C(n484), .Y(n707) );
  INVX1 U720 ( .A(N52), .Y(n484) );
  NAND2X1 U721 ( .A(N50), .B(N51), .Y(n511) );
  INVX1 U722 ( .A(n512), .Y(sram_wr_data[63]) );
  AOI22X1 U723 ( .A(ahb_store_data[63]), .B(n469), .C(activations[63]), .D(
        n465), .Y(n512) );
  INVX1 U724 ( .A(n513), .Y(sram_wr_data[62]) );
  AOI22X1 U725 ( .A(ahb_store_data[62]), .B(n469), .C(activations[62]), .D(
        n465), .Y(n513) );
  INVX1 U726 ( .A(n514), .Y(sram_wr_data[61]) );
  AOI22X1 U727 ( .A(ahb_store_data[61]), .B(n469), .C(activations[61]), .D(
        n465), .Y(n514) );
  INVX1 U728 ( .A(n515), .Y(sram_wr_data[60]) );
  AOI22X1 U729 ( .A(ahb_store_data[60]), .B(n469), .C(activations[60]), .D(
        n465), .Y(n515) );
  INVX1 U730 ( .A(n516), .Y(sram_wr_data[59]) );
  AOI22X1 U731 ( .A(ahb_store_data[59]), .B(n469), .C(activations[59]), .D(
        n465), .Y(n516) );
  INVX1 U732 ( .A(n517), .Y(sram_wr_data[58]) );
  AOI22X1 U733 ( .A(ahb_store_data[58]), .B(n469), .C(activations[58]), .D(
        n465), .Y(n517) );
  INVX1 U734 ( .A(n518), .Y(sram_wr_data[57]) );
  AOI22X1 U735 ( .A(ahb_store_data[57]), .B(n469), .C(activations[57]), .D(
        n465), .Y(n518) );
  INVX1 U736 ( .A(n519), .Y(sram_wr_data[56]) );
  AOI22X1 U737 ( .A(ahb_store_data[56]), .B(n469), .C(activations[56]), .D(
        n465), .Y(n519) );
  INVX1 U738 ( .A(n520), .Y(sram_wr_data[55]) );
  AOI22X1 U739 ( .A(ahb_store_data[55]), .B(n469), .C(activations[55]), .D(
        n465), .Y(n520) );
  INVX1 U740 ( .A(n521), .Y(sram_wr_data[54]) );
  AOI22X1 U741 ( .A(ahb_store_data[54]), .B(n469), .C(activations[54]), .D(
        n465), .Y(n521) );
  INVX1 U742 ( .A(n522), .Y(sram_wr_data[53]) );
  AOI22X1 U743 ( .A(ahb_store_data[53]), .B(n469), .C(activations[53]), .D(
        n465), .Y(n522) );
  INVX1 U744 ( .A(n523), .Y(sram_wr_data[52]) );
  AOI22X1 U745 ( .A(ahb_store_data[52]), .B(n469), .C(activations[52]), .D(
        n465), .Y(n523) );
  INVX1 U746 ( .A(n524), .Y(sram_wr_data[51]) );
  AOI22X1 U747 ( .A(ahb_store_data[51]), .B(n469), .C(activations[51]), .D(
        n465), .Y(n524) );
  INVX1 U748 ( .A(n525), .Y(sram_wr_data[50]) );
  AOI22X1 U749 ( .A(ahb_store_data[50]), .B(n469), .C(activations[50]), .D(
        n465), .Y(n525) );
  INVX1 U750 ( .A(n526), .Y(sram_wr_data[49]) );
  AOI22X1 U751 ( .A(ahb_store_data[49]), .B(n469), .C(activations[49]), .D(
        n465), .Y(n526) );
  INVX1 U752 ( .A(n527), .Y(sram_wr_data[48]) );
  AOI22X1 U753 ( .A(ahb_store_data[48]), .B(n469), .C(activations[48]), .D(
        n465), .Y(n527) );
  INVX1 U754 ( .A(n528), .Y(sram_wr_data[47]) );
  AOI22X1 U755 ( .A(ahb_store_data[47]), .B(n469), .C(activations[47]), .D(
        n465), .Y(n528) );
  INVX1 U756 ( .A(n529), .Y(sram_wr_data[46]) );
  AOI22X1 U757 ( .A(ahb_store_data[46]), .B(n469), .C(activations[46]), .D(
        n465), .Y(n529) );
  INVX1 U758 ( .A(n530), .Y(sram_wr_data[45]) );
  AOI22X1 U759 ( .A(ahb_store_data[45]), .B(n469), .C(activations[45]), .D(
        n465), .Y(n530) );
  INVX1 U760 ( .A(n531), .Y(sram_wr_data[44]) );
  AOI22X1 U761 ( .A(ahb_store_data[44]), .B(n469), .C(activations[44]), .D(
        n465), .Y(n531) );
  INVX1 U762 ( .A(n532), .Y(sram_wr_data[43]) );
  AOI22X1 U763 ( .A(ahb_store_data[43]), .B(n469), .C(activations[43]), .D(
        n465), .Y(n532) );
  INVX1 U764 ( .A(n533), .Y(sram_wr_data[42]) );
  AOI22X1 U765 ( .A(ahb_store_data[42]), .B(n469), .C(activations[42]), .D(
        n465), .Y(n533) );
  INVX1 U766 ( .A(n534), .Y(sram_wr_data[41]) );
  AOI22X1 U767 ( .A(ahb_store_data[41]), .B(n469), .C(activations[41]), .D(
        n465), .Y(n534) );
  INVX1 U768 ( .A(n535), .Y(sram_wr_data[40]) );
  AOI22X1 U769 ( .A(ahb_store_data[40]), .B(n469), .C(activations[40]), .D(
        n465), .Y(n535) );
  INVX1 U770 ( .A(n536), .Y(sram_wr_data[39]) );
  AOI22X1 U771 ( .A(ahb_store_data[39]), .B(n469), .C(activations[39]), .D(
        n465), .Y(n536) );
  INVX1 U772 ( .A(n537), .Y(sram_wr_data[38]) );
  AOI22X1 U773 ( .A(ahb_store_data[38]), .B(n469), .C(activations[38]), .D(
        n465), .Y(n537) );
  INVX1 U774 ( .A(n538), .Y(sram_wr_data[37]) );
  AOI22X1 U775 ( .A(ahb_store_data[37]), .B(n469), .C(activations[37]), .D(
        n465), .Y(n538) );
  INVX1 U776 ( .A(n539), .Y(sram_wr_data[36]) );
  AOI22X1 U777 ( .A(ahb_store_data[36]), .B(n469), .C(activations[36]), .D(
        n465), .Y(n539) );
  INVX1 U778 ( .A(n540), .Y(sram_wr_data[35]) );
  AOI22X1 U779 ( .A(ahb_store_data[35]), .B(n469), .C(activations[35]), .D(
        n465), .Y(n540) );
  INVX1 U780 ( .A(n541), .Y(sram_wr_data[34]) );
  AOI22X1 U781 ( .A(ahb_store_data[34]), .B(n469), .C(activations[34]), .D(
        n465), .Y(n541) );
  INVX1 U782 ( .A(n542), .Y(sram_wr_data[33]) );
  AOI22X1 U783 ( .A(ahb_store_data[33]), .B(n469), .C(activations[33]), .D(
        n465), .Y(n542) );
  INVX1 U784 ( .A(n543), .Y(sram_wr_data[32]) );
  AOI22X1 U785 ( .A(ahb_store_data[32]), .B(n469), .C(activations[32]), .D(
        n465), .Y(n543) );
  INVX1 U786 ( .A(n544), .Y(sram_wr_data[31]) );
  AOI22X1 U787 ( .A(ahb_store_data[31]), .B(n469), .C(activations[31]), .D(
        n465), .Y(n544) );
  INVX1 U788 ( .A(n545), .Y(sram_wr_data[30]) );
  AOI22X1 U789 ( .A(ahb_store_data[30]), .B(n469), .C(activations[30]), .D(
        n465), .Y(n545) );
  INVX1 U790 ( .A(n546), .Y(sram_wr_data[29]) );
  AOI22X1 U791 ( .A(ahb_store_data[29]), .B(n469), .C(activations[29]), .D(
        n465), .Y(n546) );
  INVX1 U792 ( .A(n547), .Y(sram_wr_data[28]) );
  AOI22X1 U793 ( .A(ahb_store_data[28]), .B(n469), .C(activations[28]), .D(
        n465), .Y(n547) );
  INVX1 U794 ( .A(n548), .Y(sram_wr_data[27]) );
  AOI22X1 U795 ( .A(ahb_store_data[27]), .B(n469), .C(activations[27]), .D(
        n465), .Y(n548) );
  INVX1 U796 ( .A(n549), .Y(sram_wr_data[26]) );
  AOI22X1 U797 ( .A(ahb_store_data[26]), .B(n469), .C(activations[26]), .D(
        n465), .Y(n549) );
  INVX1 U798 ( .A(n550), .Y(sram_wr_data[25]) );
  AOI22X1 U799 ( .A(ahb_store_data[25]), .B(n469), .C(activations[25]), .D(
        n465), .Y(n550) );
  INVX1 U800 ( .A(n551), .Y(sram_wr_data[24]) );
  AOI22X1 U801 ( .A(ahb_store_data[24]), .B(n469), .C(activations[24]), .D(
        n465), .Y(n551) );
  INVX1 U802 ( .A(n552), .Y(sram_wr_data[23]) );
  AOI22X1 U803 ( .A(ahb_store_data[23]), .B(n469), .C(activations[23]), .D(
        n465), .Y(n552) );
  INVX1 U804 ( .A(n553), .Y(sram_wr_data[22]) );
  AOI22X1 U805 ( .A(ahb_store_data[22]), .B(n469), .C(activations[22]), .D(
        n465), .Y(n553) );
  INVX1 U806 ( .A(n554), .Y(sram_wr_data[21]) );
  AOI22X1 U807 ( .A(ahb_store_data[21]), .B(n469), .C(activations[21]), .D(
        n465), .Y(n554) );
  INVX1 U808 ( .A(n555), .Y(sram_wr_data[20]) );
  AOI22X1 U809 ( .A(ahb_store_data[20]), .B(n469), .C(activations[20]), .D(
        n465), .Y(n555) );
  INVX1 U810 ( .A(n556), .Y(sram_wr_data[19]) );
  AOI22X1 U811 ( .A(ahb_store_data[19]), .B(n469), .C(activations[19]), .D(
        n465), .Y(n556) );
  INVX1 U812 ( .A(n557), .Y(sram_wr_data[18]) );
  AOI22X1 U813 ( .A(ahb_store_data[18]), .B(n469), .C(activations[18]), .D(
        n465), .Y(n557) );
  INVX1 U814 ( .A(n558), .Y(sram_wr_data[17]) );
  AOI22X1 U815 ( .A(ahb_store_data[17]), .B(n469), .C(activations[17]), .D(
        n465), .Y(n558) );
  INVX1 U816 ( .A(n559), .Y(sram_wr_data[16]) );
  AOI22X1 U817 ( .A(ahb_store_data[16]), .B(n469), .C(activations[16]), .D(
        n465), .Y(n559) );
  INVX1 U818 ( .A(n560), .Y(sram_wr_data[15]) );
  AOI22X1 U819 ( .A(ahb_store_data[15]), .B(n469), .C(activations[15]), .D(
        n465), .Y(n560) );
  INVX1 U820 ( .A(n561), .Y(sram_wr_data[14]) );
  AOI22X1 U821 ( .A(ahb_store_data[14]), .B(n469), .C(activations[14]), .D(
        n465), .Y(n561) );
  INVX1 U822 ( .A(n562), .Y(sram_wr_data[13]) );
  AOI22X1 U823 ( .A(ahb_store_data[13]), .B(n469), .C(activations[13]), .D(
        n465), .Y(n562) );
  INVX1 U824 ( .A(n563), .Y(sram_wr_data[12]) );
  AOI22X1 U825 ( .A(ahb_store_data[12]), .B(n469), .C(activations[12]), .D(
        n465), .Y(n563) );
  INVX1 U826 ( .A(n564), .Y(sram_wr_data[11]) );
  AOI22X1 U827 ( .A(ahb_store_data[11]), .B(n469), .C(activations[11]), .D(
        n465), .Y(n564) );
  INVX1 U828 ( .A(n565), .Y(sram_wr_data[10]) );
  AOI22X1 U829 ( .A(ahb_store_data[10]), .B(n469), .C(activations[10]), .D(
        n465), .Y(n565) );
  INVX1 U830 ( .A(n566), .Y(sram_wr_data[9]) );
  AOI22X1 U831 ( .A(ahb_store_data[9]), .B(n469), .C(activations[9]), .D(n465), 
        .Y(n566) );
  INVX1 U832 ( .A(n567), .Y(sram_wr_data[8]) );
  AOI22X1 U833 ( .A(ahb_store_data[8]), .B(n469), .C(activations[8]), .D(n465), 
        .Y(n567) );
  INVX1 U834 ( .A(n568), .Y(sram_wr_data[7]) );
  AOI22X1 U835 ( .A(ahb_store_data[7]), .B(n469), .C(activations[7]), .D(n465), 
        .Y(n568) );
  INVX1 U836 ( .A(n569), .Y(sram_wr_data[6]) );
  AOI22X1 U837 ( .A(ahb_store_data[6]), .B(n469), .C(activations[6]), .D(n465), 
        .Y(n569) );
  INVX1 U838 ( .A(n570), .Y(sram_wr_data[5]) );
  AOI22X1 U839 ( .A(ahb_store_data[5]), .B(n469), .C(activations[5]), .D(n465), 
        .Y(n570) );
  INVX1 U840 ( .A(n571), .Y(sram_wr_data[4]) );
  AOI22X1 U841 ( .A(ahb_store_data[4]), .B(n469), .C(activations[4]), .D(n465), 
        .Y(n571) );
  INVX1 U842 ( .A(n572), .Y(sram_wr_data[3]) );
  AOI22X1 U843 ( .A(ahb_store_data[3]), .B(n469), .C(activations[3]), .D(n465), 
        .Y(n572) );
  INVX1 U844 ( .A(n573), .Y(sram_wr_data[2]) );
  AOI22X1 U845 ( .A(ahb_store_data[2]), .B(n469), .C(activations[2]), .D(n465), 
        .Y(n573) );
  INVX1 U846 ( .A(n574), .Y(sram_wr_data[1]) );
  AOI22X1 U847 ( .A(ahb_store_data[1]), .B(n469), .C(activations[1]), .D(n465), 
        .Y(n574) );
  INVX1 U848 ( .A(n575), .Y(sram_wr_data[0]) );
  AOI22X1 U849 ( .A(ahb_store_data[0]), .B(n469), .C(activations[0]), .D(n465), 
        .Y(n575) );
  OAI21X1 U850 ( .A(n576), .B(n577), .C(n578), .Y(sram_addr[4]) );
  NAND2X1 U851 ( .A(ahb_store_addr[4]), .B(n469), .Y(n578) );
  INVX1 U852 ( .A(wt_counter[4]), .Y(n577) );
  OAI21X1 U853 ( .A(n576), .B(n579), .C(n580), .Y(sram_addr[5]) );
  NAND2X1 U854 ( .A(ahb_store_addr[5]), .B(n469), .Y(n580) );
  NAND2X1 U855 ( .A(ahb_store_en), .B(n581), .Y(n466) );
  XOR2X1 U856 ( .A(N677), .B(n582), .Y(n459) );
  OAI21X1 U857 ( .A(n583), .B(n584), .C(n585), .Y(n458) );
  OAI21X1 U858 ( .A(n583), .B(n586), .C(N679), .Y(n585) );
  NAND2X1 U859 ( .A(N678), .B(n586), .Y(n584) );
  OAI21X1 U860 ( .A(n586), .B(n587), .C(n588), .Y(n457) );
  AOI22X1 U861 ( .A(n589), .B(state[3]), .C(n590), .D(n591), .Y(n588) );
  INVX1 U862 ( .A(n592), .Y(n590) );
  AND2X1 U863 ( .A(n479), .B(n593), .Y(n589) );
  AOI21X1 U864 ( .A(n594), .B(n595), .C(n596), .Y(n456) );
  INVX1 U865 ( .A(n597), .Y(n596) );
  OAI21X1 U866 ( .A(n598), .B(n493), .C(state[2]), .Y(n595) );
  NOR2X1 U867 ( .A(n599), .B(n600), .Y(n594) );
  INVX1 U868 ( .A(n601), .Y(n599) );
  NAND2X1 U869 ( .A(n602), .B(n603), .Y(n455) );
  AOI21X1 U870 ( .A(state[1]), .B(n604), .C(n605), .Y(n603) );
  OAI21X1 U871 ( .A(n606), .B(n607), .C(n601), .Y(n605) );
  NAND3X1 U872 ( .A(n608), .B(n586), .C(n609), .Y(n601) );
  INVX1 U873 ( .A(n587), .Y(n609) );
  NAND3X1 U874 ( .A(N678), .B(N679), .C(N677), .Y(n586) );
  NAND2X1 U875 ( .A(N534), .B(N535), .Y(n607) );
  OAI21X1 U876 ( .A(n591), .B(n592), .C(n610), .Y(n604) );
  AOI21X1 U877 ( .A(n593), .B(n479), .C(n611), .Y(n610) );
  INVX1 U878 ( .A(n612), .Y(n611) );
  AOI22X1 U879 ( .A(n613), .B(n614), .C(n615), .D(n591), .Y(n602) );
  OR2X1 U880 ( .A(n616), .B(n617), .Y(n454) );
  OAI21X1 U881 ( .A(n618), .B(n619), .C(n620), .Y(n617) );
  AOI22X1 U882 ( .A(n608), .B(n593), .C(n621), .D(n591), .Y(n620) );
  INVX1 U883 ( .A(n622), .Y(n621) );
  NAND2X1 U884 ( .A(n623), .B(n587), .Y(n593) );
  INVX1 U885 ( .A(ctrl_reg[1]), .Y(n619) );
  OAI21X1 U886 ( .A(n612), .B(n624), .C(n625), .Y(n616) );
  NOR2X1 U887 ( .A(n626), .B(n598), .Y(n625) );
  AOI21X1 U888 ( .A(n592), .B(n627), .C(n591), .Y(n598) );
  AND2X1 U889 ( .A(sram_state[0]), .B(n628), .Y(n591) );
  INVX1 U890 ( .A(n629), .Y(n626) );
  OAI21X1 U891 ( .A(lat_counter[3]), .B(lat_counter[4]), .C(lat_counter[5]), 
        .Y(n624) );
  XNOR2X1 U892 ( .A(N678), .B(n583), .Y(n453) );
  NAND2X1 U893 ( .A(n582), .B(N677), .Y(n583) );
  NOR2X1 U894 ( .A(n630), .B(n631), .Y(n582) );
  NAND3X1 U895 ( .A(n608), .B(n612), .C(n632), .Y(n631) );
  NAND3X1 U896 ( .A(n592), .B(n633), .C(n618), .Y(n630) );
  MUX2X1 U897 ( .B(n634), .A(n635), .S(wt_counter[0]), .Y(n452) );
  MUX2X1 U898 ( .B(n636), .A(n637), .S(wt_counter[1]), .Y(n451) );
  NAND2X1 U899 ( .A(n638), .B(wt_counter[0]), .Y(n636) );
  MUX2X1 U900 ( .B(n639), .A(n640), .S(wt_counter[2]), .Y(n450) );
  INVX1 U901 ( .A(n641), .Y(n640) );
  OAI21X1 U902 ( .A(n634), .B(wt_counter[1]), .C(n637), .Y(n641) );
  INVX1 U903 ( .A(n642), .Y(n637) );
  OAI21X1 U904 ( .A(wt_counter[0]), .B(n634), .C(n635), .Y(n642) );
  NAND3X1 U905 ( .A(wt_counter[0]), .B(wt_counter[1]), .C(n638), .Y(n639) );
  MUX2X1 U906 ( .B(n643), .A(n644), .S(wt_counter[3]), .Y(n449) );
  NAND2X1 U907 ( .A(n638), .B(n645), .Y(n643) );
  MUX2X1 U908 ( .B(n646), .A(n647), .S(wt_counter[4]), .Y(n448) );
  INVX1 U909 ( .A(n648), .Y(n647) );
  NAND3X1 U910 ( .A(n645), .B(wt_counter[3]), .C(n638), .Y(n646) );
  OAI21X1 U911 ( .A(n649), .B(n634), .C(n650), .Y(n447) );
  OAI21X1 U912 ( .A(n638), .B(n648), .C(wt_counter[5]), .Y(n650) );
  OAI21X1 U913 ( .A(wt_counter[3]), .B(n634), .C(n644), .Y(n648) );
  INVX1 U914 ( .A(n651), .Y(n644) );
  OAI21X1 U915 ( .A(n645), .B(n634), .C(n635), .Y(n651) );
  NOR2X1 U916 ( .A(n652), .B(n653), .Y(n635) );
  NAND3X1 U917 ( .A(n632), .B(n460), .C(n489), .Y(n653) );
  INVX1 U918 ( .A(n493), .Y(n489) );
  INVX1 U919 ( .A(n654), .Y(n632) );
  OAI21X1 U920 ( .A(n608), .B(n623), .C(n655), .Y(n652) );
  NOR2X1 U921 ( .A(n600), .B(n615), .Y(n655) );
  INVX1 U922 ( .A(n627), .Y(n615) );
  INVX1 U923 ( .A(n634), .Y(n638) );
  NAND3X1 U924 ( .A(n608), .B(n656), .C(n614), .Y(n634) );
  INVX1 U925 ( .A(n613), .Y(n656) );
  NOR2X1 U926 ( .A(n649), .B(n579), .Y(n613) );
  INVX1 U927 ( .A(wt_counter[5]), .Y(n579) );
  NAND3X1 U928 ( .A(wt_counter[4]), .B(wt_counter[3]), .C(n645), .Y(n649) );
  INVX1 U929 ( .A(n657), .Y(n645) );
  NAND3X1 U930 ( .A(wt_counter[1]), .B(wt_counter[2]), .C(wt_counter[0]), .Y(
        n657) );
  MUX2X1 U931 ( .B(n658), .A(n659), .S(N533), .Y(n446) );
  NOR2X1 U932 ( .A(n660), .B(n661), .Y(n659) );
  NAND2X1 U933 ( .A(n490), .B(n612), .Y(n661) );
  NAND2X1 U934 ( .A(n622), .B(n629), .Y(n660) );
  NAND2X1 U935 ( .A(n662), .B(n608), .Y(n658) );
  INVX1 U936 ( .A(n663), .Y(n445) );
  MUX2X1 U937 ( .B(n664), .A(n665), .S(N534), .Y(n663) );
  MUX2X1 U938 ( .B(n666), .A(n667), .S(N535), .Y(n444) );
  AOI21X1 U939 ( .A(n662), .B(n668), .C(n665), .Y(n667) );
  NAND3X1 U940 ( .A(n669), .B(n629), .C(n490), .Y(n665) );
  INVX1 U941 ( .A(n508), .Y(n490) );
  NAND3X1 U942 ( .A(n460), .B(n670), .C(n671), .Y(n508) );
  NOR2X1 U943 ( .A(n471), .B(n654), .Y(n671) );
  OAI21X1 U944 ( .A(n672), .B(n673), .C(n674), .Y(n654) );
  NOR2X1 U945 ( .A(ctrl_reg_clear[1]), .B(ctrl_reg_clear[0]), .Y(n674) );
  INVX1 U946 ( .A(n675), .Y(ctrl_reg_clear[0]) );
  OAI21X1 U947 ( .A(ctrl_reg[1]), .B(n676), .C(n581), .Y(n670) );
  NAND2X1 U948 ( .A(n662), .B(n479), .Y(n629) );
  OAI21X1 U949 ( .A(n677), .B(n678), .C(n493), .Y(n669) );
  NAND2X1 U950 ( .A(n468), .B(n612), .Y(n493) );
  NAND2X1 U951 ( .A(n612), .B(n622), .Y(n678) );
  INVX1 U952 ( .A(N533), .Y(n677) );
  INVX1 U953 ( .A(N534), .Y(n668) );
  NAND2X1 U954 ( .A(n664), .B(N534), .Y(n666) );
  INVX1 U955 ( .A(n606), .Y(n664) );
  NAND3X1 U956 ( .A(n608), .B(N533), .C(n662), .Y(n606) );
  INVX1 U957 ( .A(n679), .Y(n662) );
  MUX2X1 U958 ( .B(n618), .A(n680), .S(n681), .Y(n443) );
  INVX1 U959 ( .A(status_reg[1]), .Y(n680) );
  NAND2X1 U960 ( .A(n675), .B(n682), .Y(n442) );
  OAI21X1 U961 ( .A(ctrl_reg_clear[1]), .B(n681), .C(status_reg[0]), .Y(n682)
         );
  OR2X1 U962 ( .A(n683), .B(n684), .Y(n681) );
  OAI21X1 U963 ( .A(n672), .B(n673), .C(n460), .Y(n684) );
  NAND3X1 U964 ( .A(n672), .B(n685), .C(state[3]), .Y(n587) );
  NAND3X1 U965 ( .A(state[0]), .B(n686), .C(state[1]), .Y(n592) );
  NAND3X1 U966 ( .A(n597), .B(n633), .C(n612), .Y(n683) );
  NAND3X1 U967 ( .A(n686), .B(n685), .C(state[1]), .Y(n612) );
  NAND2X1 U968 ( .A(n600), .B(n676), .Y(n597) );
  INVX1 U969 ( .A(ctrl_reg[0]), .Y(n676) );
  NOR2X1 U970 ( .A(n618), .B(ctrl_reg[1]), .Y(n600) );
  NOR2X1 U971 ( .A(n687), .B(n685), .Y(ctrl_reg_clear[1]) );
  NAND3X1 U972 ( .A(state[3]), .B(n672), .C(state[0]), .Y(n675) );
  XOR2X1 U973 ( .A(n488), .B(n688), .Y(n441) );
  OAI21X1 U974 ( .A(n689), .B(n688), .C(n482), .Y(n440) );
  XOR2X1 U975 ( .A(wt_wr_ptr[1]), .B(n690), .Y(n439) );
  XNOR2X1 U976 ( .A(wt_wr_ptr[2]), .B(n691), .Y(n438) );
  NAND2X1 U977 ( .A(n690), .B(wt_wr_ptr[1]), .Y(n691) );
  NOR2X1 U978 ( .A(n688), .B(n488), .Y(n690) );
  INVX1 U979 ( .A(wt_wr_ptr[0]), .Y(n488) );
  XOR2X1 U980 ( .A(wt_wr_ptr[3]), .B(n692), .Y(n437) );
  XNOR2X1 U981 ( .A(wt_wr_ptr[4]), .B(n693), .Y(n436) );
  NAND2X1 U982 ( .A(n692), .B(wt_wr_ptr[3]), .Y(n693) );
  NOR2X1 U983 ( .A(n688), .B(n694), .Y(n692) );
  OAI21X1 U984 ( .A(n482), .B(n689), .C(n483), .Y(n688) );
  INVX1 U985 ( .A(n481), .Y(n483) );
  NAND2X1 U986 ( .A(ahb_wr_weight), .B(n581), .Y(n481) );
  NAND3X1 U987 ( .A(wt_wr_ptr[3]), .B(wt_wr_ptr[4]), .C(n695), .Y(n689) );
  INVX1 U988 ( .A(n694), .Y(n695) );
  NAND3X1 U989 ( .A(wt_wr_ptr[1]), .B(wt_wr_ptr[2]), .C(wt_wr_ptr[0]), .Y(n694) );
  INVX1 U990 ( .A(wt_wr_ptr[5]), .Y(n482) );
  XOR2X1 U991 ( .A(n487), .B(n510), .Y(n435) );
  XOR2X1 U992 ( .A(N51), .B(n696), .Y(n434) );
  NOR2X1 U993 ( .A(n487), .B(n510), .Y(n696) );
  OAI21X1 U994 ( .A(n487), .B(n697), .C(n708), .Y(n510) );
  INVX1 U995 ( .A(n480), .Y(n708) );
  NAND3X1 U996 ( .A(n581), .B(n698), .C(ahb_wr_input), .Y(n480) );
  INVX1 U997 ( .A(ahb_wr_weight), .Y(n698) );
  INVX1 U998 ( .A(n618), .Y(n581) );
  NAND3X1 U999 ( .A(n685), .B(n673), .C(n672), .Y(n618) );
  NAND2X1 U1000 ( .A(N51), .B(N52), .Y(n697) );
  INVX1 U1001 ( .A(N50), .Y(n487) );
  NOR2X1 U1002 ( .A(n576), .B(n479), .Y(load_weights) );
  AND2X1 U1003 ( .A(sram_rd_data[9]), .B(n464), .Y(input_vec[9]) );
  AND2X1 U1004 ( .A(sram_rd_data[8]), .B(n464), .Y(input_vec[8]) );
  AND2X1 U1005 ( .A(sram_rd_data[7]), .B(n464), .Y(input_vec[7]) );
  AND2X1 U1006 ( .A(sram_rd_data[6]), .B(n464), .Y(input_vec[6]) );
  AND2X1 U1007 ( .A(sram_rd_data[63]), .B(n464), .Y(input_vec[63]) );
  AND2X1 U1008 ( .A(sram_rd_data[62]), .B(n464), .Y(input_vec[62]) );
  AND2X1 U1009 ( .A(sram_rd_data[61]), .B(n464), .Y(input_vec[61]) );
  AND2X1 U1010 ( .A(sram_rd_data[60]), .B(n464), .Y(input_vec[60]) );
  AND2X1 U1011 ( .A(sram_rd_data[5]), .B(n464), .Y(input_vec[5]) );
  AND2X1 U1012 ( .A(sram_rd_data[59]), .B(n464), .Y(input_vec[59]) );
  AND2X1 U1013 ( .A(sram_rd_data[58]), .B(n464), .Y(input_vec[58]) );
  AND2X1 U1014 ( .A(sram_rd_data[57]), .B(n464), .Y(input_vec[57]) );
  AND2X1 U1015 ( .A(sram_rd_data[56]), .B(n464), .Y(input_vec[56]) );
  AND2X1 U1016 ( .A(sram_rd_data[55]), .B(n464), .Y(input_vec[55]) );
  AND2X1 U1017 ( .A(sram_rd_data[54]), .B(n464), .Y(input_vec[54]) );
  AND2X1 U1018 ( .A(sram_rd_data[53]), .B(n464), .Y(input_vec[53]) );
  AND2X1 U1019 ( .A(sram_rd_data[52]), .B(n464), .Y(input_vec[52]) );
  AND2X1 U1020 ( .A(sram_rd_data[51]), .B(n464), .Y(input_vec[51]) );
  AND2X1 U1021 ( .A(sram_rd_data[50]), .B(n464), .Y(input_vec[50]) );
  AND2X1 U1022 ( .A(sram_rd_data[4]), .B(n464), .Y(input_vec[4]) );
  AND2X1 U1023 ( .A(sram_rd_data[49]), .B(n464), .Y(input_vec[49]) );
  AND2X1 U1024 ( .A(sram_rd_data[48]), .B(n464), .Y(input_vec[48]) );
  AND2X1 U1025 ( .A(sram_rd_data[47]), .B(n464), .Y(input_vec[47]) );
  AND2X1 U1026 ( .A(sram_rd_data[46]), .B(n464), .Y(input_vec[46]) );
  AND2X1 U1027 ( .A(sram_rd_data[45]), .B(n464), .Y(input_vec[45]) );
  AND2X1 U1028 ( .A(sram_rd_data[44]), .B(n464), .Y(input_vec[44]) );
  AND2X1 U1029 ( .A(sram_rd_data[43]), .B(n464), .Y(input_vec[43]) );
  AND2X1 U1030 ( .A(sram_rd_data[42]), .B(n464), .Y(input_vec[42]) );
  AND2X1 U1031 ( .A(sram_rd_data[41]), .B(n464), .Y(input_vec[41]) );
  AND2X1 U1032 ( .A(sram_rd_data[40]), .B(n464), .Y(input_vec[40]) );
  AND2X1 U1033 ( .A(sram_rd_data[3]), .B(n464), .Y(input_vec[3]) );
  AND2X1 U1034 ( .A(sram_rd_data[39]), .B(n464), .Y(input_vec[39]) );
  AND2X1 U1035 ( .A(sram_rd_data[38]), .B(n464), .Y(input_vec[38]) );
  AND2X1 U1036 ( .A(sram_rd_data[37]), .B(n464), .Y(input_vec[37]) );
  AND2X1 U1037 ( .A(sram_rd_data[36]), .B(n464), .Y(input_vec[36]) );
  AND2X1 U1038 ( .A(sram_rd_data[35]), .B(n464), .Y(input_vec[35]) );
  AND2X1 U1039 ( .A(sram_rd_data[34]), .B(n464), .Y(input_vec[34]) );
  AND2X1 U1040 ( .A(sram_rd_data[33]), .B(n464), .Y(input_vec[33]) );
  AND2X1 U1041 ( .A(sram_rd_data[32]), .B(n464), .Y(input_vec[32]) );
  AND2X1 U1042 ( .A(sram_rd_data[31]), .B(n464), .Y(input_vec[31]) );
  AND2X1 U1043 ( .A(sram_rd_data[30]), .B(n464), .Y(input_vec[30]) );
  AND2X1 U1044 ( .A(sram_rd_data[2]), .B(n464), .Y(input_vec[2]) );
  AND2X1 U1045 ( .A(sram_rd_data[29]), .B(n464), .Y(input_vec[29]) );
  AND2X1 U1046 ( .A(sram_rd_data[28]), .B(n464), .Y(input_vec[28]) );
  AND2X1 U1047 ( .A(sram_rd_data[27]), .B(n464), .Y(input_vec[27]) );
  AND2X1 U1048 ( .A(sram_rd_data[26]), .B(n464), .Y(input_vec[26]) );
  AND2X1 U1049 ( .A(sram_rd_data[25]), .B(n464), .Y(input_vec[25]) );
  AND2X1 U1050 ( .A(sram_rd_data[24]), .B(n464), .Y(input_vec[24]) );
  AND2X1 U1051 ( .A(sram_rd_data[23]), .B(n464), .Y(input_vec[23]) );
  AND2X1 U1052 ( .A(sram_rd_data[22]), .B(n464), .Y(input_vec[22]) );
  AND2X1 U1053 ( .A(sram_rd_data[21]), .B(n464), .Y(input_vec[21]) );
  AND2X1 U1054 ( .A(sram_rd_data[20]), .B(n464), .Y(input_vec[20]) );
  AND2X1 U1055 ( .A(sram_rd_data[1]), .B(n464), .Y(input_vec[1]) );
  AND2X1 U1056 ( .A(sram_rd_data[19]), .B(n464), .Y(input_vec[19]) );
  AND2X1 U1057 ( .A(sram_rd_data[18]), .B(n464), .Y(input_vec[18]) );
  AND2X1 U1058 ( .A(sram_rd_data[17]), .B(n464), .Y(input_vec[17]) );
  AND2X1 U1059 ( .A(sram_rd_data[16]), .B(n464), .Y(input_vec[16]) );
  AND2X1 U1060 ( .A(sram_rd_data[15]), .B(n464), .Y(input_vec[15]) );
  AND2X1 U1061 ( .A(sram_rd_data[14]), .B(n464), .Y(input_vec[14]) );
  AND2X1 U1062 ( .A(sram_rd_data[13]), .B(n464), .Y(input_vec[13]) );
  AND2X1 U1063 ( .A(sram_rd_data[12]), .B(n464), .Y(input_vec[12]) );
  AND2X1 U1064 ( .A(sram_rd_data[11]), .B(n464), .Y(input_vec[11]) );
  AND2X1 U1065 ( .A(sram_rd_data[10]), .B(n464), .Y(input_vec[10]) );
  AND2X1 U1066 ( .A(sram_rd_data[0]), .B(n464), .Y(input_vec[0]) );
  INVX1 U1067 ( .A(sram_rd_en), .Y(n633) );
  NAND2X1 U1068 ( .A(n468), .B(n576), .Y(sram_rd_en) );
  INVX1 U1069 ( .A(n471), .Y(n576) );
  NAND2X1 U1070 ( .A(n627), .B(n623), .Y(n471) );
  INVX1 U1071 ( .A(n614), .Y(n623) );
  NOR2X1 U1072 ( .A(n687), .B(state[0]), .Y(n614) );
  NAND3X1 U1073 ( .A(n699), .B(n673), .C(state[1]), .Y(n687) );
  NAND3X1 U1074 ( .A(n672), .B(n673), .C(state[0]), .Y(n627) );
  INVX1 U1075 ( .A(state[3]), .Y(n673) );
  NOR2X1 U1076 ( .A(state[2]), .B(state[1]), .Y(n672) );
  INVX1 U1077 ( .A(n474), .Y(n468) );
  NAND2X1 U1078 ( .A(n622), .B(n679), .Y(n474) );
  NAND3X1 U1079 ( .A(n686), .B(n700), .C(state[0]), .Y(n679) );
  NAND3X1 U1080 ( .A(n685), .B(n700), .C(n686), .Y(n622) );
  NOR2X1 U1081 ( .A(n699), .B(state[3]), .Y(n686) );
  INVX1 U1082 ( .A(state[2]), .Y(n699) );
  INVX1 U1083 ( .A(state[1]), .Y(n700) );
  INVX1 U1084 ( .A(state[0]), .Y(n685) );
  INVX1 U1085 ( .A(n608), .Y(n479) );
  NOR2X1 U1086 ( .A(n628), .B(sram_state[0]), .Y(n608) );
  INVX1 U1087 ( .A(sram_state[1]), .Y(n628) );
endmodule

