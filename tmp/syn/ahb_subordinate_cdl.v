/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Sat Apr 18 16:19:02 2026
/////////////////////////////////////////////////////////////


module ahb_subordinate_cdl ( clk, n_rst, hsel, inference_complete, haddr, 
        htrans, hsize, hwrite, hwdata, hrdata, hresp, hready, active_mode, 
        bias, ctrl_reg, hready_stall, occ_err, act_ctrl_out, overrun_err, 
        ctrl_reg_clear, status_reg_ctrl, ahb_wr_weight, ahb_wr_input, nan_err, 
        inf_err, clear_errors );
  input [9:0] haddr;
  input [1:0] htrans;
  input [2:0] hsize;
  input [63:0] hwdata;
  output [63:0] hrdata;
  output [2:0] active_mode;
  output [63:0] bias;
  output [1:0] ctrl_reg;
  input [2:0] act_ctrl_out;
  input [1:0] ctrl_reg_clear;
  input [1:0] status_reg_ctrl;
  input clk, n_rst, hsel, inference_complete, hwrite, hready_stall, occ_err,
         overrun_err, nan_err, inf_err;
  output hresp, hready, ahb_wr_weight, ahb_wr_input, clear_errors;
  wire   \err_next[1] , dph_valid, N114, dph_write, dph_error, N129, N130,
         N131, n439, n441, n443, n445, n447, n449, n451, n453, n462, n464,
         n533, n534, n535, n536, n537, n538, n539, n540, n541, n542, n543,
         n544, n545, n546, n547, n548, n549, n550, n551, n552, n553, n554,
         n555, n556, n557, n558, n559, n560, n561, n562, n563, n564, n565,
         n566, n567, n568, n569, n570, n571, n572, n573, n574, n575, n576,
         n577, n578, n579, n580, n581, n582, n583, n584, n585, n586, n587,
         n588, n589, n590, n591, n592, n593, n594, n595, n596, n599, n600,
         n601, n602, n603, n604, n605, n606, n607, n608, n609, n610, n611,
         n612, n613, n614, n615, n616, n617, n618, n619, n620, n621, n622,
         n623, n624, n625, n626, n627, n628, n629, n630, n631, n632, n633,
         n634, n635, n636, n637, n638, n639, n640, n641, n642, n643, n644,
         n645, n646, n647, n648, n649, n650, n651, n652, n653, n654, n655,
         n656, n657, n658, n659, n660, n661, n662, n663, n664, n665, n666,
         n667, n668, n669, n670, n671, n672, n673, n674, n675, n676, n677,
         n678, n679, n680, n681, n682, n683, n684, n685, n686, n687, n688,
         n689, n690, n691, n692, n693, n694, n695, n696, n697, n698, n699,
         n700, n701, n702, n703, n704, n705, n706, n707, n708, n709, n710,
         n711, n712, n713, n714, n715, n716, n717, n718, n719, n720, n721,
         n722, n723, n724, n725, n726, n727, n728, n729, n730, n731, n732,
         n733, n734, n735, n736, n737, n738, n739, n740, n741, n742, n743,
         n744, n745, n746, n747, n748, n749, n750, n751, n752, n753, n754,
         n755, n756, n757, n758, n759, n760, n761, n762, n763, n764, n765,
         n766, n767, n768, n769, n770, n771, n772, n773, n774, n775, n776,
         n777, n778, n779, n780, n781, n782, n783, n784, n785, n786, n787,
         n788, n789, n790, n791, n792, n793, n794, n795, n796, n797, n798,
         n799, n800, n801, n802, n803, n804, n805, n806, n807, n808, n809,
         n810, n811, n812, n813, n814, n815, n816, n817, n818, n819, n820,
         n821, n822, n823, n824, n825, n826, n827, n828, n829, n830, n831,
         n832, n833, n834, n835, n836, n837, n838, n839, n840, n841, n842,
         n843, n844, n845, n846, n847, n848, n849, n850, n851, n852, n853,
         n854, n855, n856, n857, n858, n859, n860, n861, n862, n863, n864,
         n865, n866, n867, n868, n869, n870, n871, n872, n873, n874, n875,
         n876, n877, n878, n879, n880, n881, n882, n883, n884, n885, n886,
         n887, n888, n889, n890, n891, n892, n893, n894, n895, n896, n897,
         n898, n899, n900, n901, n902, n903, n904, n905, n906, n907, n908,
         n909, n910, n911, n912, n913, n914, n915, n916, n917, n918, n919,
         n920, n921, n922, n923, n924, n925, n926, n927, n928, n929, n930,
         n931, n932, n933, n934, n935, n936, n937, n938, n939, n940, n941,
         n942, n943, n944, n945, n946, n947, n948, n949, n950, n951, n952,
         n953, n954, n955, n956, n957, n958, n959, n960, n961, n962, n963,
         n964, n965, n966, n967, n968, n969, n970;
  wire   [1:0] err_state;
  wire   [9:0] dph_haddr;

  DFFSR \err_state_reg[0]  ( .D(n900), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        err_state[0]) );
  DFFSR \err_state_reg[1]  ( .D(\err_next[1] ), .CLK(clk), .R(n_rst), .S(1'b1), 
        .Q(err_state[1]) );
  DFFSR hresp_reg ( .D(n900), .CLK(clk), .R(n_rst), .S(1'b1), .Q(hresp) );
  DFFSR dph_error_reg ( .D(n464), .CLK(clk), .R(n_rst), .S(1'b1), .Q(dph_error) );
  DFFSR dph_valid_reg ( .D(n462), .CLK(clk), .R(n_rst), .S(1'b1), .Q(dph_valid) );
  DFFSR hready_reg ( .D(N114), .CLK(clk), .R(1'b1), .S(n_rst), .Q(hready) );
  DFFSR dph_write_reg ( .D(n903), .CLK(clk), .R(n_rst), .S(1'b1), .Q(dph_write) );
  DFFSR \dph_haddr_reg[9]  ( .D(n901), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[9]) );
  DFFSR \dph_haddr_reg[8]  ( .D(n902), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[8]) );
  DFFSR \dph_haddr_reg[7]  ( .D(n453), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[7]) );
  DFFSR \dph_haddr_reg[6]  ( .D(n451), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[6]) );
  DFFSR \dph_haddr_reg[5]  ( .D(n449), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[5]) );
  DFFSR \dph_haddr_reg[4]  ( .D(n447), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[4]) );
  DFFSR \dph_haddr_reg[3]  ( .D(n445), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[3]) );
  DFFSR \dph_haddr_reg[2]  ( .D(n443), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[2]) );
  DFFSR \dph_haddr_reg[1]  ( .D(n441), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[1]) );
  DFFSR \dph_haddr_reg[0]  ( .D(n439), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        dph_haddr[0]) );
  DFFSR \reg_act_reg[2]  ( .D(n934), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        active_mode[2]) );
  DFFSR \reg_act_reg[1]  ( .D(n936), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        active_mode[1]) );
  DFFSR \reg_act_reg[0]  ( .D(n938), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        active_mode[0]) );
  DFFSR \reg_ctrl_reg[1]  ( .D(n600), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        ctrl_reg[1]) );
  DFFSR \reg_ctrl_reg[0]  ( .D(n599), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        ctrl_reg[0]) );
  DFFSR \reg_bias_reg[63]  ( .D(n904), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[63]) );
  DFFSR \reg_bias_reg[62]  ( .D(n905), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[62]) );
  DFFSR \reg_bias_reg[61]  ( .D(n906), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[61]) );
  DFFSR \reg_bias_reg[60]  ( .D(n907), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[60]) );
  DFFSR \reg_bias_reg[59]  ( .D(n908), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[59]) );
  DFFSR \reg_bias_reg[58]  ( .D(n909), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[58]) );
  DFFSR \reg_bias_reg[57]  ( .D(n910), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[57]) );
  DFFSR \reg_bias_reg[56]  ( .D(n911), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[56]) );
  DFFSR \reg_bias_reg[55]  ( .D(n912), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[55]) );
  DFFSR \reg_bias_reg[54]  ( .D(n913), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[54]) );
  DFFSR \reg_bias_reg[53]  ( .D(n914), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[53]) );
  DFFSR \reg_bias_reg[52]  ( .D(n915), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[52]) );
  DFFSR \reg_bias_reg[51]  ( .D(n916), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[51]) );
  DFFSR \reg_bias_reg[50]  ( .D(n917), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[50]) );
  DFFSR \reg_bias_reg[49]  ( .D(n918), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[49]) );
  DFFSR \reg_bias_reg[48]  ( .D(n919), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[48]) );
  DFFSR \reg_bias_reg[47]  ( .D(n920), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[47]) );
  DFFSR \reg_bias_reg[46]  ( .D(n921), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[46]) );
  DFFSR \reg_bias_reg[45]  ( .D(n922), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[45]) );
  DFFSR \reg_bias_reg[44]  ( .D(n923), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[44]) );
  DFFSR \reg_bias_reg[43]  ( .D(n924), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[43]) );
  DFFSR \reg_bias_reg[42]  ( .D(n925), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[42]) );
  DFFSR \reg_bias_reg[41]  ( .D(n926), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[41]) );
  DFFSR \reg_bias_reg[40]  ( .D(n927), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[40]) );
  DFFSR \reg_bias_reg[39]  ( .D(n928), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[39]) );
  DFFSR \reg_bias_reg[38]  ( .D(n929), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[38]) );
  DFFSR \reg_bias_reg[37]  ( .D(n930), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[37]) );
  DFFSR \reg_bias_reg[36]  ( .D(n931), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[36]) );
  DFFSR \reg_bias_reg[35]  ( .D(n932), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[35]) );
  DFFSR \reg_bias_reg[34]  ( .D(n933), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[34]) );
  DFFSR \reg_bias_reg[33]  ( .D(n935), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[33]) );
  DFFSR \reg_bias_reg[32]  ( .D(n937), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[32]) );
  DFFSR \reg_bias_reg[31]  ( .D(n939), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[31]) );
  DFFSR \reg_bias_reg[30]  ( .D(n940), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[30]) );
  DFFSR \reg_bias_reg[29]  ( .D(n941), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[29]) );
  DFFSR \reg_bias_reg[28]  ( .D(n942), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[28]) );
  DFFSR \reg_bias_reg[27]  ( .D(n943), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[27]) );
  DFFSR \reg_bias_reg[26]  ( .D(n944), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[26]) );
  DFFSR \reg_bias_reg[25]  ( .D(n945), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[25]) );
  DFFSR \reg_bias_reg[24]  ( .D(n946), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[24]) );
  DFFSR \reg_bias_reg[23]  ( .D(n947), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[23]) );
  DFFSR \reg_bias_reg[22]  ( .D(n948), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[22]) );
  DFFSR \reg_bias_reg[21]  ( .D(n949), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[21]) );
  DFFSR \reg_bias_reg[20]  ( .D(n950), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[20]) );
  DFFSR \reg_bias_reg[19]  ( .D(n951), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[19]) );
  DFFSR \reg_bias_reg[18]  ( .D(n952), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[18]) );
  DFFSR \reg_bias_reg[17]  ( .D(n953), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[17]) );
  DFFSR \reg_bias_reg[16]  ( .D(n954), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[16]) );
  DFFSR \reg_bias_reg[15]  ( .D(n955), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[15]) );
  DFFSR \reg_bias_reg[14]  ( .D(n956), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[14]) );
  DFFSR \reg_bias_reg[13]  ( .D(n957), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[13]) );
  DFFSR \reg_bias_reg[12]  ( .D(n958), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[12]) );
  DFFSR \reg_bias_reg[11]  ( .D(n959), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[11]) );
  DFFSR \reg_bias_reg[10]  ( .D(n960), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[10]) );
  DFFSR \reg_bias_reg[9]  ( .D(n961), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[9]) );
  DFFSR \reg_bias_reg[8]  ( .D(n962), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[8]) );
  DFFSR \reg_bias_reg[7]  ( .D(n963), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[7]) );
  DFFSR \reg_bias_reg[6]  ( .D(n964), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[6]) );
  DFFSR \reg_bias_reg[5]  ( .D(n965), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[5]) );
  DFFSR \reg_bias_reg[4]  ( .D(n966), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[4]) );
  DFFSR \reg_bias_reg[3]  ( .D(n967), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[3]) );
  DFFSR \reg_bias_reg[2]  ( .D(n968), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[2]) );
  DFFSR \reg_bias_reg[1]  ( .D(n969), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[1]) );
  DFFSR \reg_bias_reg[0]  ( .D(n970), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        bias[0]) );
  DFFSR clear_errors_reg ( .D(N131), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        clear_errors) );
  DFFSR ahb_wr_weight_reg ( .D(N129), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        ahb_wr_weight) );
  DFFSR ahb_wr_input_reg ( .D(N130), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        ahb_wr_input) );
  DFFSR \hrdata_reg[63]  ( .D(n596), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[63]) );
  DFFSR \hrdata_reg[62]  ( .D(n595), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[62]) );
  DFFSR \hrdata_reg[61]  ( .D(n594), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[61]) );
  DFFSR \hrdata_reg[60]  ( .D(n593), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[60]) );
  DFFSR \hrdata_reg[59]  ( .D(n592), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[59]) );
  DFFSR \hrdata_reg[58]  ( .D(n591), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[58]) );
  DFFSR \hrdata_reg[57]  ( .D(n590), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[57]) );
  DFFSR \hrdata_reg[56]  ( .D(n589), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[56]) );
  DFFSR \hrdata_reg[55]  ( .D(n588), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[55]) );
  DFFSR \hrdata_reg[54]  ( .D(n587), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[54]) );
  DFFSR \hrdata_reg[53]  ( .D(n586), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[53]) );
  DFFSR \hrdata_reg[52]  ( .D(n585), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[52]) );
  DFFSR \hrdata_reg[51]  ( .D(n584), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[51]) );
  DFFSR \hrdata_reg[50]  ( .D(n583), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[50]) );
  DFFSR \hrdata_reg[49]  ( .D(n582), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[49]) );
  DFFSR \hrdata_reg[48]  ( .D(n581), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[48]) );
  DFFSR \hrdata_reg[47]  ( .D(n580), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[47]) );
  DFFSR \hrdata_reg[46]  ( .D(n579), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[46]) );
  DFFSR \hrdata_reg[45]  ( .D(n578), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[45]) );
  DFFSR \hrdata_reg[44]  ( .D(n577), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[44]) );
  DFFSR \hrdata_reg[43]  ( .D(n576), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[43]) );
  DFFSR \hrdata_reg[42]  ( .D(n575), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[42]) );
  DFFSR \hrdata_reg[41]  ( .D(n574), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[41]) );
  DFFSR \hrdata_reg[40]  ( .D(n573), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[40]) );
  DFFSR \hrdata_reg[39]  ( .D(n572), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[39]) );
  DFFSR \hrdata_reg[38]  ( .D(n571), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[38]) );
  DFFSR \hrdata_reg[37]  ( .D(n570), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[37]) );
  DFFSR \hrdata_reg[36]  ( .D(n569), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[36]) );
  DFFSR \hrdata_reg[35]  ( .D(n568), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[35]) );
  DFFSR \hrdata_reg[34]  ( .D(n567), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[34]) );
  DFFSR \hrdata_reg[33]  ( .D(n566), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[33]) );
  DFFSR \hrdata_reg[32]  ( .D(n565), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[32]) );
  DFFSR \hrdata_reg[31]  ( .D(n564), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[31]) );
  DFFSR \hrdata_reg[30]  ( .D(n563), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[30]) );
  DFFSR \hrdata_reg[29]  ( .D(n562), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[29]) );
  DFFSR \hrdata_reg[28]  ( .D(n561), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[28]) );
  DFFSR \hrdata_reg[27]  ( .D(n560), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[27]) );
  DFFSR \hrdata_reg[26]  ( .D(n559), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[26]) );
  DFFSR \hrdata_reg[25]  ( .D(n558), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[25]) );
  DFFSR \hrdata_reg[24]  ( .D(n557), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[24]) );
  DFFSR \hrdata_reg[23]  ( .D(n556), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[23]) );
  DFFSR \hrdata_reg[22]  ( .D(n555), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[22]) );
  DFFSR \hrdata_reg[21]  ( .D(n554), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[21]) );
  DFFSR \hrdata_reg[20]  ( .D(n553), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[20]) );
  DFFSR \hrdata_reg[19]  ( .D(n552), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[19]) );
  DFFSR \hrdata_reg[18]  ( .D(n551), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[18]) );
  DFFSR \hrdata_reg[17]  ( .D(n550), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[17]) );
  DFFSR \hrdata_reg[16]  ( .D(n549), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[16]) );
  DFFSR \hrdata_reg[15]  ( .D(n548), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[15]) );
  DFFSR \hrdata_reg[14]  ( .D(n547), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[14]) );
  DFFSR \hrdata_reg[13]  ( .D(n546), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[13]) );
  DFFSR \hrdata_reg[12]  ( .D(n545), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[12]) );
  DFFSR \hrdata_reg[11]  ( .D(n544), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[11]) );
  DFFSR \hrdata_reg[10]  ( .D(n543), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[10]) );
  DFFSR \hrdata_reg[9]  ( .D(n542), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[9]) );
  DFFSR \hrdata_reg[8]  ( .D(n541), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[8]) );
  DFFSR \hrdata_reg[7]  ( .D(n540), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[7]) );
  DFFSR \hrdata_reg[6]  ( .D(n539), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[6]) );
  DFFSR \hrdata_reg[5]  ( .D(n538), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[5]) );
  DFFSR \hrdata_reg[4]  ( .D(n537), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[4]) );
  DFFSR \hrdata_reg[3]  ( .D(n536), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[3]) );
  DFFSR \hrdata_reg[2]  ( .D(n535), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[2]) );
  DFFSR \hrdata_reg[1]  ( .D(n534), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[1]) );
  DFFSR \hrdata_reg[0]  ( .D(n533), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hrdata[0]) );
  OR2X2 U605 ( .A(n851), .B(n604), .Y(n601) );
  OR2X2 U606 ( .A(n848), .B(n852), .Y(n602) );
  INVX1 U607 ( .A(n764), .Y(n603) );
  INVX2 U608 ( .A(n603), .Y(n604) );
  INVX8 U609 ( .A(n602), .Y(n605) );
  INVX8 U610 ( .A(n601), .Y(n606) );
  INVX1 U611 ( .A(n617), .Y(n607) );
  INVX8 U612 ( .A(n607), .Y(n608) );
  BUFX2 U613 ( .A(n612), .Y(n609) );
  INVX4 U614 ( .A(n604), .Y(n702) );
  MUX2X1 U615 ( .B(n610), .A(n611), .S(n609), .Y(n901) );
  MUX2X1 U616 ( .B(n613), .A(n614), .S(n609), .Y(n902) );
  INVX1 U617 ( .A(n615), .Y(n903) );
  MUX2X1 U618 ( .B(dph_write), .A(hwrite), .S(n609), .Y(n615) );
  INVX1 U619 ( .A(n616), .Y(n904) );
  MUX2X1 U620 ( .B(hwdata[63]), .A(bias[63]), .S(n608), .Y(n616) );
  INVX1 U621 ( .A(n618), .Y(n905) );
  MUX2X1 U622 ( .B(hwdata[62]), .A(bias[62]), .S(n608), .Y(n618) );
  INVX1 U623 ( .A(n619), .Y(n906) );
  MUX2X1 U624 ( .B(hwdata[61]), .A(bias[61]), .S(n608), .Y(n619) );
  INVX1 U625 ( .A(n620), .Y(n907) );
  MUX2X1 U626 ( .B(hwdata[60]), .A(bias[60]), .S(n608), .Y(n620) );
  INVX1 U627 ( .A(n621), .Y(n908) );
  MUX2X1 U628 ( .B(hwdata[59]), .A(bias[59]), .S(n608), .Y(n621) );
  INVX1 U629 ( .A(n622), .Y(n909) );
  MUX2X1 U630 ( .B(hwdata[58]), .A(bias[58]), .S(n608), .Y(n622) );
  INVX1 U631 ( .A(n623), .Y(n910) );
  MUX2X1 U632 ( .B(hwdata[57]), .A(bias[57]), .S(n608), .Y(n623) );
  INVX1 U633 ( .A(n624), .Y(n911) );
  MUX2X1 U634 ( .B(hwdata[56]), .A(bias[56]), .S(n608), .Y(n624) );
  INVX1 U635 ( .A(n625), .Y(n912) );
  MUX2X1 U636 ( .B(hwdata[55]), .A(bias[55]), .S(n608), .Y(n625) );
  INVX1 U637 ( .A(n626), .Y(n913) );
  MUX2X1 U638 ( .B(hwdata[54]), .A(bias[54]), .S(n608), .Y(n626) );
  INVX1 U639 ( .A(n627), .Y(n914) );
  MUX2X1 U640 ( .B(hwdata[53]), .A(bias[53]), .S(n608), .Y(n627) );
  INVX1 U641 ( .A(n628), .Y(n915) );
  MUX2X1 U642 ( .B(hwdata[52]), .A(bias[52]), .S(n608), .Y(n628) );
  INVX1 U643 ( .A(n629), .Y(n916) );
  MUX2X1 U644 ( .B(hwdata[51]), .A(bias[51]), .S(n608), .Y(n629) );
  INVX1 U645 ( .A(n630), .Y(n917) );
  MUX2X1 U646 ( .B(hwdata[50]), .A(bias[50]), .S(n608), .Y(n630) );
  INVX1 U647 ( .A(n631), .Y(n918) );
  MUX2X1 U648 ( .B(hwdata[49]), .A(bias[49]), .S(n608), .Y(n631) );
  INVX1 U649 ( .A(n632), .Y(n919) );
  MUX2X1 U650 ( .B(hwdata[48]), .A(bias[48]), .S(n608), .Y(n632) );
  INVX1 U651 ( .A(n633), .Y(n920) );
  MUX2X1 U652 ( .B(hwdata[47]), .A(bias[47]), .S(n608), .Y(n633) );
  INVX1 U653 ( .A(n634), .Y(n921) );
  MUX2X1 U654 ( .B(hwdata[46]), .A(bias[46]), .S(n608), .Y(n634) );
  INVX1 U655 ( .A(n635), .Y(n922) );
  MUX2X1 U656 ( .B(hwdata[45]), .A(bias[45]), .S(n608), .Y(n635) );
  INVX1 U657 ( .A(n636), .Y(n923) );
  MUX2X1 U658 ( .B(hwdata[44]), .A(bias[44]), .S(n608), .Y(n636) );
  INVX1 U659 ( .A(n637), .Y(n924) );
  MUX2X1 U660 ( .B(hwdata[43]), .A(bias[43]), .S(n608), .Y(n637) );
  INVX1 U661 ( .A(n638), .Y(n925) );
  MUX2X1 U662 ( .B(hwdata[42]), .A(bias[42]), .S(n608), .Y(n638) );
  INVX1 U663 ( .A(n639), .Y(n926) );
  MUX2X1 U664 ( .B(hwdata[41]), .A(bias[41]), .S(n608), .Y(n639) );
  INVX1 U665 ( .A(n640), .Y(n927) );
  MUX2X1 U666 ( .B(hwdata[40]), .A(bias[40]), .S(n608), .Y(n640) );
  INVX1 U667 ( .A(n641), .Y(n928) );
  MUX2X1 U668 ( .B(hwdata[39]), .A(bias[39]), .S(n608), .Y(n641) );
  INVX1 U669 ( .A(n642), .Y(n929) );
  MUX2X1 U670 ( .B(hwdata[38]), .A(bias[38]), .S(n608), .Y(n642) );
  INVX1 U671 ( .A(n643), .Y(n930) );
  MUX2X1 U672 ( .B(hwdata[37]), .A(bias[37]), .S(n608), .Y(n643) );
  INVX1 U673 ( .A(n644), .Y(n931) );
  MUX2X1 U674 ( .B(hwdata[36]), .A(bias[36]), .S(n608), .Y(n644) );
  INVX1 U675 ( .A(n645), .Y(n932) );
  MUX2X1 U676 ( .B(hwdata[35]), .A(bias[35]), .S(n608), .Y(n645) );
  INVX1 U677 ( .A(n646), .Y(n933) );
  MUX2X1 U678 ( .B(hwdata[34]), .A(bias[34]), .S(n608), .Y(n646) );
  INVX1 U679 ( .A(n647), .Y(n934) );
  MUX2X1 U680 ( .B(hwdata[34]), .A(active_mode[2]), .S(n648), .Y(n647) );
  INVX1 U681 ( .A(n649), .Y(n935) );
  MUX2X1 U682 ( .B(hwdata[33]), .A(bias[33]), .S(n608), .Y(n649) );
  INVX1 U683 ( .A(n650), .Y(n936) );
  MUX2X1 U684 ( .B(hwdata[33]), .A(active_mode[1]), .S(n648), .Y(n650) );
  INVX1 U685 ( .A(n651), .Y(n937) );
  MUX2X1 U686 ( .B(hwdata[32]), .A(bias[32]), .S(n608), .Y(n651) );
  INVX1 U687 ( .A(n652), .Y(n938) );
  MUX2X1 U688 ( .B(hwdata[32]), .A(active_mode[0]), .S(n648), .Y(n652) );
  NAND3X1 U689 ( .A(n653), .B(n654), .C(dph_haddr[2]), .Y(n648) );
  INVX1 U690 ( .A(n655), .Y(n939) );
  MUX2X1 U691 ( .B(hwdata[31]), .A(bias[31]), .S(n608), .Y(n655) );
  INVX1 U692 ( .A(n656), .Y(n940) );
  MUX2X1 U693 ( .B(hwdata[30]), .A(bias[30]), .S(n608), .Y(n656) );
  INVX1 U694 ( .A(n657), .Y(n941) );
  MUX2X1 U695 ( .B(hwdata[29]), .A(bias[29]), .S(n608), .Y(n657) );
  INVX1 U696 ( .A(n658), .Y(n942) );
  MUX2X1 U697 ( .B(hwdata[28]), .A(bias[28]), .S(n608), .Y(n658) );
  INVX1 U698 ( .A(n659), .Y(n943) );
  MUX2X1 U699 ( .B(hwdata[27]), .A(bias[27]), .S(n608), .Y(n659) );
  INVX1 U700 ( .A(n660), .Y(n944) );
  MUX2X1 U701 ( .B(hwdata[26]), .A(bias[26]), .S(n608), .Y(n660) );
  INVX1 U702 ( .A(n661), .Y(n945) );
  MUX2X1 U703 ( .B(hwdata[25]), .A(bias[25]), .S(n608), .Y(n661) );
  INVX1 U704 ( .A(n662), .Y(n946) );
  MUX2X1 U705 ( .B(hwdata[24]), .A(bias[24]), .S(n608), .Y(n662) );
  INVX1 U706 ( .A(n663), .Y(n947) );
  MUX2X1 U707 ( .B(hwdata[23]), .A(bias[23]), .S(n608), .Y(n663) );
  INVX1 U708 ( .A(n664), .Y(n948) );
  MUX2X1 U709 ( .B(hwdata[22]), .A(bias[22]), .S(n608), .Y(n664) );
  INVX1 U710 ( .A(n665), .Y(n949) );
  MUX2X1 U711 ( .B(hwdata[21]), .A(bias[21]), .S(n608), .Y(n665) );
  INVX1 U712 ( .A(n666), .Y(n950) );
  MUX2X1 U713 ( .B(hwdata[20]), .A(bias[20]), .S(n608), .Y(n666) );
  INVX1 U714 ( .A(n667), .Y(n951) );
  MUX2X1 U715 ( .B(hwdata[19]), .A(bias[19]), .S(n608), .Y(n667) );
  INVX1 U716 ( .A(n668), .Y(n952) );
  MUX2X1 U717 ( .B(hwdata[18]), .A(bias[18]), .S(n608), .Y(n668) );
  INVX1 U718 ( .A(n669), .Y(n953) );
  MUX2X1 U719 ( .B(hwdata[17]), .A(bias[17]), .S(n608), .Y(n669) );
  INVX1 U720 ( .A(n670), .Y(n954) );
  MUX2X1 U721 ( .B(hwdata[16]), .A(bias[16]), .S(n608), .Y(n670) );
  INVX1 U722 ( .A(n671), .Y(n955) );
  MUX2X1 U723 ( .B(hwdata[15]), .A(bias[15]), .S(n608), .Y(n671) );
  INVX1 U724 ( .A(n672), .Y(n956) );
  MUX2X1 U725 ( .B(hwdata[14]), .A(bias[14]), .S(n608), .Y(n672) );
  INVX1 U726 ( .A(n673), .Y(n957) );
  MUX2X1 U727 ( .B(hwdata[13]), .A(bias[13]), .S(n608), .Y(n673) );
  INVX1 U728 ( .A(n674), .Y(n958) );
  MUX2X1 U729 ( .B(hwdata[12]), .A(bias[12]), .S(n608), .Y(n674) );
  INVX1 U730 ( .A(n675), .Y(n959) );
  MUX2X1 U731 ( .B(hwdata[11]), .A(bias[11]), .S(n608), .Y(n675) );
  INVX1 U732 ( .A(n676), .Y(n960) );
  MUX2X1 U733 ( .B(hwdata[10]), .A(bias[10]), .S(n608), .Y(n676) );
  INVX1 U734 ( .A(n677), .Y(n961) );
  MUX2X1 U735 ( .B(hwdata[9]), .A(bias[9]), .S(n608), .Y(n677) );
  INVX1 U736 ( .A(n678), .Y(n962) );
  MUX2X1 U737 ( .B(hwdata[8]), .A(bias[8]), .S(n608), .Y(n678) );
  INVX1 U738 ( .A(n679), .Y(n963) );
  MUX2X1 U739 ( .B(hwdata[7]), .A(bias[7]), .S(n608), .Y(n679) );
  INVX1 U740 ( .A(n680), .Y(n964) );
  MUX2X1 U741 ( .B(hwdata[6]), .A(bias[6]), .S(n608), .Y(n680) );
  INVX1 U742 ( .A(n681), .Y(n965) );
  MUX2X1 U743 ( .B(hwdata[5]), .A(bias[5]), .S(n608), .Y(n681) );
  INVX1 U744 ( .A(n682), .Y(n966) );
  MUX2X1 U745 ( .B(hwdata[4]), .A(bias[4]), .S(n608), .Y(n682) );
  INVX1 U746 ( .A(n683), .Y(n967) );
  MUX2X1 U747 ( .B(hwdata[3]), .A(bias[3]), .S(n608), .Y(n683) );
  INVX1 U748 ( .A(n684), .Y(n968) );
  MUX2X1 U749 ( .B(hwdata[2]), .A(bias[2]), .S(n608), .Y(n684) );
  INVX1 U750 ( .A(n685), .Y(n969) );
  MUX2X1 U751 ( .B(hwdata[1]), .A(bias[1]), .S(n608), .Y(n685) );
  INVX1 U752 ( .A(n686), .Y(n970) );
  MUX2X1 U753 ( .B(hwdata[0]), .A(bias[0]), .S(n608), .Y(n686) );
  NAND3X1 U754 ( .A(dph_haddr[4]), .B(n687), .C(n688), .Y(n617) );
  NOR2X1 U755 ( .A(dph_haddr[5]), .B(dph_haddr[3]), .Y(n688) );
  MUX2X1 U756 ( .B(n689), .A(n690), .S(n691), .Y(n600) );
  OR2X1 U757 ( .A(ctrl_reg_clear[1]), .B(n692), .Y(n690) );
  INVX1 U758 ( .A(hwdata[17]), .Y(n689) );
  MUX2X1 U759 ( .B(n693), .A(n694), .S(n691), .Y(n599) );
  NAND3X1 U760 ( .A(n653), .B(n695), .C(dph_haddr[1]), .Y(n691) );
  INVX1 U761 ( .A(n696), .Y(n653) );
  NAND3X1 U762 ( .A(dph_haddr[5]), .B(n687), .C(n697), .Y(n696) );
  NOR2X1 U763 ( .A(dph_haddr[0]), .B(n698), .Y(n697) );
  NAND2X1 U764 ( .A(n699), .B(n700), .Y(n698) );
  OR2X1 U765 ( .A(ctrl_reg_clear[0]), .B(n701), .Y(n694) );
  INVX1 U766 ( .A(hwdata[16]), .Y(n693) );
  OAI21X1 U767 ( .A(n702), .B(n703), .C(n704), .Y(n596) );
  AOI22X1 U768 ( .A(n605), .B(bias[63]), .C(n606), .D(hwdata[63]), .Y(n704) );
  INVX1 U769 ( .A(hrdata[63]), .Y(n703) );
  OAI21X1 U770 ( .A(n702), .B(n705), .C(n706), .Y(n595) );
  AOI22X1 U771 ( .A(n605), .B(bias[62]), .C(n606), .D(hwdata[62]), .Y(n706) );
  INVX1 U772 ( .A(hrdata[62]), .Y(n705) );
  OAI21X1 U773 ( .A(n702), .B(n707), .C(n708), .Y(n594) );
  AOI22X1 U774 ( .A(n605), .B(bias[61]), .C(n606), .D(hwdata[61]), .Y(n708) );
  INVX1 U775 ( .A(hrdata[61]), .Y(n707) );
  OAI21X1 U776 ( .A(n702), .B(n709), .C(n710), .Y(n593) );
  AOI22X1 U777 ( .A(n605), .B(bias[60]), .C(n606), .D(hwdata[60]), .Y(n710) );
  INVX1 U778 ( .A(hrdata[60]), .Y(n709) );
  OAI21X1 U779 ( .A(n702), .B(n711), .C(n712), .Y(n592) );
  AOI22X1 U780 ( .A(n605), .B(bias[59]), .C(n606), .D(hwdata[59]), .Y(n712) );
  INVX1 U781 ( .A(hrdata[59]), .Y(n711) );
  OAI21X1 U782 ( .A(n702), .B(n713), .C(n714), .Y(n591) );
  AOI22X1 U783 ( .A(n605), .B(bias[58]), .C(n606), .D(hwdata[58]), .Y(n714) );
  INVX1 U784 ( .A(hrdata[58]), .Y(n713) );
  OAI21X1 U785 ( .A(n702), .B(n715), .C(n716), .Y(n590) );
  AOI22X1 U786 ( .A(n605), .B(bias[57]), .C(n606), .D(hwdata[57]), .Y(n716) );
  INVX1 U787 ( .A(hrdata[57]), .Y(n715) );
  OAI21X1 U788 ( .A(n702), .B(n717), .C(n718), .Y(n589) );
  AOI22X1 U789 ( .A(n605), .B(bias[56]), .C(n606), .D(hwdata[56]), .Y(n718) );
  INVX1 U790 ( .A(hrdata[56]), .Y(n717) );
  OAI21X1 U791 ( .A(n702), .B(n719), .C(n720), .Y(n588) );
  AOI22X1 U792 ( .A(n605), .B(bias[55]), .C(n606), .D(hwdata[55]), .Y(n720) );
  INVX1 U793 ( .A(hrdata[55]), .Y(n719) );
  OAI21X1 U794 ( .A(n702), .B(n721), .C(n722), .Y(n587) );
  AOI22X1 U795 ( .A(n605), .B(bias[54]), .C(n606), .D(hwdata[54]), .Y(n722) );
  INVX1 U796 ( .A(hrdata[54]), .Y(n721) );
  OAI21X1 U797 ( .A(n702), .B(n723), .C(n724), .Y(n586) );
  AOI22X1 U798 ( .A(n605), .B(bias[53]), .C(n606), .D(hwdata[53]), .Y(n724) );
  INVX1 U799 ( .A(hrdata[53]), .Y(n723) );
  OAI21X1 U800 ( .A(n702), .B(n725), .C(n726), .Y(n585) );
  AOI22X1 U801 ( .A(n605), .B(bias[52]), .C(n606), .D(hwdata[52]), .Y(n726) );
  INVX1 U802 ( .A(hrdata[52]), .Y(n725) );
  OAI21X1 U803 ( .A(n702), .B(n727), .C(n728), .Y(n584) );
  AOI22X1 U804 ( .A(n605), .B(bias[51]), .C(n606), .D(hwdata[51]), .Y(n728) );
  INVX1 U805 ( .A(hrdata[51]), .Y(n727) );
  OAI21X1 U806 ( .A(n702), .B(n729), .C(n730), .Y(n583) );
  AOI22X1 U807 ( .A(n605), .B(bias[50]), .C(n606), .D(hwdata[50]), .Y(n730) );
  INVX1 U808 ( .A(hrdata[50]), .Y(n729) );
  OAI21X1 U809 ( .A(n702), .B(n731), .C(n732), .Y(n582) );
  AOI22X1 U810 ( .A(n605), .B(bias[49]), .C(n606), .D(hwdata[49]), .Y(n732) );
  INVX1 U811 ( .A(hrdata[49]), .Y(n731) );
  OAI21X1 U812 ( .A(n702), .B(n733), .C(n734), .Y(n581) );
  AOI22X1 U813 ( .A(n605), .B(bias[48]), .C(n606), .D(hwdata[48]), .Y(n734) );
  INVX1 U814 ( .A(hrdata[48]), .Y(n733) );
  OAI21X1 U815 ( .A(n702), .B(n735), .C(n736), .Y(n580) );
  AOI22X1 U816 ( .A(n605), .B(bias[47]), .C(n606), .D(hwdata[47]), .Y(n736) );
  INVX1 U817 ( .A(hrdata[47]), .Y(n735) );
  OAI21X1 U818 ( .A(n702), .B(n737), .C(n738), .Y(n579) );
  AOI22X1 U819 ( .A(n605), .B(bias[46]), .C(n606), .D(hwdata[46]), .Y(n738) );
  INVX1 U820 ( .A(hrdata[46]), .Y(n737) );
  OAI21X1 U821 ( .A(n702), .B(n739), .C(n740), .Y(n578) );
  AOI22X1 U822 ( .A(n605), .B(bias[45]), .C(n606), .D(hwdata[45]), .Y(n740) );
  INVX1 U823 ( .A(hrdata[45]), .Y(n739) );
  OAI21X1 U824 ( .A(n702), .B(n741), .C(n742), .Y(n577) );
  AOI22X1 U825 ( .A(n605), .B(bias[44]), .C(n606), .D(hwdata[44]), .Y(n742) );
  INVX1 U826 ( .A(hrdata[44]), .Y(n741) );
  OAI21X1 U827 ( .A(n702), .B(n743), .C(n744), .Y(n576) );
  AOI22X1 U828 ( .A(n605), .B(bias[43]), .C(n606), .D(hwdata[43]), .Y(n744) );
  INVX1 U829 ( .A(hrdata[43]), .Y(n743) );
  OAI21X1 U830 ( .A(n702), .B(n745), .C(n746), .Y(n575) );
  AOI22X1 U831 ( .A(n605), .B(bias[42]), .C(n606), .D(hwdata[42]), .Y(n746) );
  INVX1 U832 ( .A(hrdata[42]), .Y(n745) );
  OAI21X1 U833 ( .A(n702), .B(n747), .C(n748), .Y(n574) );
  AOI22X1 U834 ( .A(n605), .B(bias[41]), .C(n606), .D(hwdata[41]), .Y(n748) );
  INVX1 U835 ( .A(hrdata[41]), .Y(n747) );
  OAI21X1 U836 ( .A(n702), .B(n749), .C(n750), .Y(n573) );
  AOI22X1 U837 ( .A(n605), .B(bias[40]), .C(n606), .D(hwdata[40]), .Y(n750) );
  INVX1 U838 ( .A(hrdata[40]), .Y(n749) );
  OAI21X1 U839 ( .A(n702), .B(n751), .C(n752), .Y(n572) );
  AOI22X1 U840 ( .A(n605), .B(bias[39]), .C(n606), .D(hwdata[39]), .Y(n752) );
  INVX1 U841 ( .A(hrdata[39]), .Y(n751) );
  OAI21X1 U842 ( .A(n702), .B(n753), .C(n754), .Y(n571) );
  AOI22X1 U843 ( .A(n605), .B(bias[38]), .C(n606), .D(hwdata[38]), .Y(n754) );
  INVX1 U844 ( .A(hrdata[38]), .Y(n753) );
  OAI21X1 U845 ( .A(n702), .B(n755), .C(n756), .Y(n570) );
  AOI22X1 U846 ( .A(n605), .B(bias[37]), .C(n606), .D(hwdata[37]), .Y(n756) );
  INVX1 U847 ( .A(hrdata[37]), .Y(n755) );
  OAI21X1 U848 ( .A(n702), .B(n757), .C(n758), .Y(n569) );
  AOI22X1 U849 ( .A(n605), .B(bias[36]), .C(n606), .D(hwdata[36]), .Y(n758) );
  INVX1 U850 ( .A(hrdata[36]), .Y(n757) );
  OAI21X1 U851 ( .A(n702), .B(n759), .C(n760), .Y(n568) );
  AOI22X1 U852 ( .A(n605), .B(bias[35]), .C(n606), .D(hwdata[35]), .Y(n760) );
  INVX1 U853 ( .A(hrdata[35]), .Y(n759) );
  NAND2X1 U854 ( .A(n761), .B(n762), .Y(n567) );
  AOI22X1 U855 ( .A(n763), .B(active_mode[2]), .C(n605), .D(bias[34]), .Y(n762) );
  AOI22X1 U856 ( .A(n606), .B(hwdata[34]), .C(hrdata[34]), .D(n604), .Y(n761)
         );
  NAND2X1 U857 ( .A(n765), .B(n766), .Y(n566) );
  AOI22X1 U858 ( .A(n763), .B(active_mode[1]), .C(n605), .D(bias[33]), .Y(n766) );
  AOI22X1 U859 ( .A(n606), .B(hwdata[33]), .C(hrdata[33]), .D(n604), .Y(n765)
         );
  NAND2X1 U860 ( .A(n767), .B(n768), .Y(n565) );
  AOI22X1 U861 ( .A(n763), .B(active_mode[0]), .C(n605), .D(bias[32]), .Y(n768) );
  INVX1 U862 ( .A(n769), .Y(n763) );
  NAND3X1 U863 ( .A(haddr[5]), .B(haddr[2]), .C(n770), .Y(n769) );
  AOI22X1 U864 ( .A(n606), .B(hwdata[32]), .C(hrdata[32]), .D(n604), .Y(n767)
         );
  OAI21X1 U865 ( .A(n702), .B(n771), .C(n772), .Y(n564) );
  AOI22X1 U866 ( .A(n605), .B(bias[31]), .C(n606), .D(hwdata[31]), .Y(n772) );
  INVX1 U867 ( .A(hrdata[31]), .Y(n771) );
  OAI21X1 U868 ( .A(n702), .B(n773), .C(n774), .Y(n563) );
  AOI22X1 U869 ( .A(n605), .B(bias[30]), .C(n606), .D(hwdata[30]), .Y(n774) );
  INVX1 U870 ( .A(hrdata[30]), .Y(n773) );
  OAI21X1 U871 ( .A(n702), .B(n775), .C(n776), .Y(n562) );
  AOI22X1 U872 ( .A(n605), .B(bias[29]), .C(n606), .D(hwdata[29]), .Y(n776) );
  INVX1 U873 ( .A(hrdata[29]), .Y(n775) );
  OAI21X1 U874 ( .A(n702), .B(n777), .C(n778), .Y(n561) );
  AOI22X1 U875 ( .A(n605), .B(bias[28]), .C(n606), .D(hwdata[28]), .Y(n778) );
  INVX1 U876 ( .A(hrdata[28]), .Y(n777) );
  OAI21X1 U877 ( .A(n702), .B(n779), .C(n780), .Y(n560) );
  AOI22X1 U878 ( .A(n605), .B(bias[27]), .C(n606), .D(hwdata[27]), .Y(n780) );
  INVX1 U879 ( .A(hrdata[27]), .Y(n779) );
  OAI21X1 U880 ( .A(n702), .B(n781), .C(n782), .Y(n559) );
  AOI22X1 U881 ( .A(n605), .B(bias[26]), .C(n606), .D(hwdata[26]), .Y(n782) );
  INVX1 U882 ( .A(hrdata[26]), .Y(n781) );
  NAND2X1 U883 ( .A(n783), .B(n784), .Y(n558) );
  AOI22X1 U884 ( .A(n785), .B(status_reg_ctrl[1]), .C(n605), .D(bias[25]), .Y(
        n784) );
  AOI22X1 U885 ( .A(n606), .B(hwdata[25]), .C(hrdata[25]), .D(n604), .Y(n783)
         );
  NAND2X1 U886 ( .A(n786), .B(n787), .Y(n557) );
  AOI22X1 U887 ( .A(n785), .B(status_reg_ctrl[0]), .C(n605), .D(bias[24]), .Y(
        n787) );
  NOR2X1 U888 ( .A(n788), .B(n789), .Y(n785) );
  INVX1 U889 ( .A(n790), .Y(n789) );
  AOI22X1 U890 ( .A(n606), .B(hwdata[24]), .C(hrdata[24]), .D(n604), .Y(n786)
         );
  OAI21X1 U891 ( .A(n702), .B(n791), .C(n792), .Y(n556) );
  AOI22X1 U892 ( .A(n605), .B(bias[23]), .C(n606), .D(hwdata[23]), .Y(n792) );
  INVX1 U893 ( .A(hrdata[23]), .Y(n791) );
  OAI21X1 U894 ( .A(n702), .B(n793), .C(n794), .Y(n555) );
  AOI22X1 U895 ( .A(n605), .B(bias[22]), .C(n606), .D(hwdata[22]), .Y(n794) );
  INVX1 U896 ( .A(hrdata[22]), .Y(n793) );
  OAI21X1 U897 ( .A(n702), .B(n795), .C(n796), .Y(n554) );
  AOI22X1 U898 ( .A(n605), .B(bias[21]), .C(n606), .D(hwdata[21]), .Y(n796) );
  INVX1 U899 ( .A(hrdata[21]), .Y(n795) );
  OAI21X1 U900 ( .A(n702), .B(n797), .C(n798), .Y(n553) );
  AOI22X1 U901 ( .A(n605), .B(bias[20]), .C(n606), .D(hwdata[20]), .Y(n798) );
  INVX1 U902 ( .A(hrdata[20]), .Y(n797) );
  OAI21X1 U903 ( .A(n702), .B(n799), .C(n800), .Y(n552) );
  AOI22X1 U904 ( .A(n605), .B(bias[19]), .C(n606), .D(hwdata[19]), .Y(n800) );
  INVX1 U905 ( .A(hrdata[19]), .Y(n799) );
  OAI21X1 U906 ( .A(n702), .B(n801), .C(n802), .Y(n551) );
  AOI22X1 U907 ( .A(n605), .B(bias[18]), .C(n606), .D(hwdata[18]), .Y(n802) );
  INVX1 U908 ( .A(hrdata[18]), .Y(n801) );
  NAND2X1 U909 ( .A(n803), .B(n804), .Y(n550) );
  AOI22X1 U910 ( .A(n805), .B(n790), .C(n605), .D(bias[17]), .Y(n804) );
  NOR2X1 U911 ( .A(haddr[0]), .B(n692), .Y(n805) );
  INVX1 U912 ( .A(ctrl_reg[1]), .Y(n692) );
  AOI22X1 U913 ( .A(n606), .B(hwdata[17]), .C(hrdata[17]), .D(n604), .Y(n803)
         );
  NAND2X1 U914 ( .A(n806), .B(n807), .Y(n549) );
  AOI22X1 U915 ( .A(n808), .B(n790), .C(n605), .D(bias[16]), .Y(n807) );
  NOR2X1 U916 ( .A(n809), .B(n810), .Y(n790) );
  NOR2X1 U917 ( .A(haddr[0]), .B(n701), .Y(n808) );
  INVX1 U918 ( .A(ctrl_reg[0]), .Y(n701) );
  AOI22X1 U919 ( .A(n606), .B(hwdata[16]), .C(hrdata[16]), .D(n604), .Y(n806)
         );
  OAI21X1 U920 ( .A(n702), .B(n811), .C(n812), .Y(n548) );
  AOI22X1 U921 ( .A(n605), .B(bias[15]), .C(n606), .D(hwdata[15]), .Y(n812) );
  INVX1 U922 ( .A(hrdata[15]), .Y(n811) );
  OAI21X1 U923 ( .A(n702), .B(n813), .C(n814), .Y(n547) );
  AOI22X1 U924 ( .A(n605), .B(bias[14]), .C(n606), .D(hwdata[14]), .Y(n814) );
  INVX1 U925 ( .A(hrdata[14]), .Y(n813) );
  OAI21X1 U926 ( .A(n702), .B(n815), .C(n816), .Y(n546) );
  AOI22X1 U927 ( .A(n605), .B(bias[13]), .C(n606), .D(hwdata[13]), .Y(n816) );
  INVX1 U928 ( .A(hrdata[13]), .Y(n815) );
  OAI21X1 U929 ( .A(n702), .B(n817), .C(n818), .Y(n545) );
  AOI22X1 U930 ( .A(n605), .B(bias[12]), .C(n606), .D(hwdata[12]), .Y(n818) );
  INVX1 U931 ( .A(hrdata[12]), .Y(n817) );
  OAI21X1 U932 ( .A(n702), .B(n819), .C(n820), .Y(n544) );
  AOI22X1 U933 ( .A(n605), .B(bias[11]), .C(n606), .D(hwdata[11]), .Y(n820) );
  INVX1 U934 ( .A(hrdata[11]), .Y(n819) );
  OAI21X1 U935 ( .A(n702), .B(n821), .C(n822), .Y(n543) );
  AOI22X1 U936 ( .A(n605), .B(bias[10]), .C(n606), .D(hwdata[10]), .Y(n822) );
  INVX1 U937 ( .A(hrdata[10]), .Y(n821) );
  NAND2X1 U938 ( .A(n823), .B(n824), .Y(n542) );
  AOI22X1 U939 ( .A(n825), .B(inf_err), .C(n605), .D(bias[9]), .Y(n824) );
  AOI22X1 U940 ( .A(n606), .B(hwdata[9]), .C(hrdata[9]), .D(n604), .Y(n823) );
  NAND2X1 U941 ( .A(n826), .B(n827), .Y(n541) );
  AOI22X1 U942 ( .A(n825), .B(nan_err), .C(n605), .D(bias[8]), .Y(n827) );
  NOR2X1 U943 ( .A(n788), .B(n828), .Y(n825) );
  AOI22X1 U944 ( .A(n606), .B(hwdata[8]), .C(hrdata[8]), .D(n604), .Y(n826) );
  OAI21X1 U945 ( .A(n702), .B(n829), .C(n830), .Y(n540) );
  AOI22X1 U946 ( .A(n605), .B(bias[7]), .C(n606), .D(hwdata[7]), .Y(n830) );
  INVX1 U947 ( .A(hrdata[7]), .Y(n829) );
  OAI21X1 U948 ( .A(n702), .B(n831), .C(n832), .Y(n539) );
  AOI22X1 U949 ( .A(n605), .B(bias[6]), .C(n606), .D(hwdata[6]), .Y(n832) );
  INVX1 U950 ( .A(hrdata[6]), .Y(n831) );
  OAI21X1 U951 ( .A(n702), .B(n833), .C(n834), .Y(n538) );
  AOI22X1 U952 ( .A(n605), .B(bias[5]), .C(n606), .D(hwdata[5]), .Y(n834) );
  INVX1 U953 ( .A(hrdata[5]), .Y(n833) );
  OAI21X1 U954 ( .A(n702), .B(n835), .C(n836), .Y(n537) );
  AOI22X1 U955 ( .A(n605), .B(bias[4]), .C(n606), .D(hwdata[4]), .Y(n836) );
  INVX1 U956 ( .A(hrdata[4]), .Y(n835) );
  NAND2X1 U957 ( .A(n837), .B(n838), .Y(n536) );
  AOI21X1 U958 ( .A(n605), .B(bias[3]), .C(n839), .Y(n838) );
  AOI22X1 U959 ( .A(n606), .B(hwdata[3]), .C(hrdata[3]), .D(n604), .Y(n837) );
  NAND2X1 U960 ( .A(n840), .B(n841), .Y(n535) );
  AOI22X1 U961 ( .A(n842), .B(overrun_err), .C(n605), .D(bias[2]), .Y(n841) );
  NOR2X1 U962 ( .A(haddr[0]), .B(n828), .Y(n842) );
  INVX1 U963 ( .A(n843), .Y(n828) );
  AOI22X1 U964 ( .A(n606), .B(hwdata[2]), .C(hrdata[2]), .D(n604), .Y(n840) );
  NAND2X1 U965 ( .A(n844), .B(n845), .Y(n534) );
  AOI21X1 U966 ( .A(n605), .B(bias[1]), .C(n839), .Y(n845) );
  INVX1 U967 ( .A(n846), .Y(n839) );
  NAND3X1 U968 ( .A(occ_err), .B(n788), .C(n843), .Y(n846) );
  NOR2X1 U969 ( .A(n809), .B(haddr[1]), .Y(n843) );
  NAND3X1 U970 ( .A(haddr[5]), .B(n847), .C(n770), .Y(n809) );
  INVX1 U971 ( .A(n848), .Y(n770) );
  AOI22X1 U972 ( .A(n606), .B(hwdata[1]), .C(hrdata[1]), .D(n604), .Y(n844) );
  OAI21X1 U973 ( .A(n702), .B(n849), .C(n850), .Y(n533) );
  AOI22X1 U974 ( .A(n605), .B(bias[0]), .C(n606), .D(hwdata[0]), .Y(n850) );
  NAND3X1 U975 ( .A(n851), .B(n853), .C(n702), .Y(n848) );
  NAND3X1 U976 ( .A(n854), .B(n855), .C(n856), .Y(n851) );
  NOR2X1 U977 ( .A(n857), .B(n858), .Y(n856) );
  XNOR2X1 U978 ( .A(n853), .B(dph_haddr[3]), .Y(n858) );
  XNOR2X1 U979 ( .A(haddr[4]), .B(dph_haddr[4]), .Y(n855) );
  MUX2X1 U980 ( .B(dph_haddr[5]), .A(n859), .S(haddr[5]), .Y(n854) );
  NAND3X1 U981 ( .A(n860), .B(dph_haddr[5]), .C(n861), .Y(n859) );
  NOR2X1 U982 ( .A(n862), .B(n863), .Y(n861) );
  XNOR2X1 U983 ( .A(n847), .B(dph_haddr[2]), .Y(n863) );
  XNOR2X1 U984 ( .A(n810), .B(dph_haddr[1]), .Y(n862) );
  XNOR2X1 U985 ( .A(n864), .B(n788), .Y(n860) );
  INVX1 U986 ( .A(hrdata[0]), .Y(n849) );
  NAND3X1 U987 ( .A(n609), .B(htrans[1]), .C(n865), .Y(n764) );
  NOR2X1 U988 ( .A(n866), .B(n867), .Y(n865) );
  NAND2X1 U989 ( .A(n868), .B(n869), .Y(n867) );
  INVX1 U990 ( .A(hsel), .Y(n866) );
  MUX2X1 U991 ( .B(n870), .A(n871), .S(n609), .Y(n464) );
  NAND2X1 U992 ( .A(htrans[1]), .B(n872), .Y(n871) );
  MUX2X1 U993 ( .B(n873), .A(n874), .S(n609), .Y(n462) );
  NAND3X1 U994 ( .A(hsel), .B(n868), .C(htrans[1]), .Y(n874) );
  INVX1 U995 ( .A(dph_valid), .Y(n873) );
  MUX2X1 U996 ( .B(n875), .A(n876), .S(n609), .Y(n453) );
  MUX2X1 U997 ( .B(n877), .A(n878), .S(n609), .Y(n451) );
  MUX2X1 U998 ( .B(n879), .A(n880), .S(n609), .Y(n449) );
  INVX1 U999 ( .A(haddr[5]), .Y(n880) );
  MUX2X1 U1000 ( .B(n700), .A(n852), .S(n609), .Y(n447) );
  MUX2X1 U1001 ( .B(n699), .A(n853), .S(n609), .Y(n445) );
  MUX2X1 U1002 ( .B(n695), .A(n847), .S(n609), .Y(n443) );
  MUX2X1 U1003 ( .B(n654), .A(n810), .S(n609), .Y(n441) );
  MUX2X1 U1004 ( .B(n864), .A(n788), .S(n609), .Y(n439) );
  NOR3X1 U1005 ( .A(err_state[1]), .B(hready_stall), .C(err_state[0]), .Y(n612) );
  INVX1 U1006 ( .A(dph_haddr[0]), .Y(n864) );
  NOR2X1 U1007 ( .A(err_state[1]), .B(n881), .Y(\err_next[1] ) );
  NOR2X1 U1008 ( .A(n882), .B(n883), .Y(N131) );
  NAND3X1 U1009 ( .A(n884), .B(n654), .C(dph_haddr[5]), .Y(n883) );
  INVX1 U1010 ( .A(dph_haddr[1]), .Y(n654) );
  NAND3X1 U1011 ( .A(n695), .B(n699), .C(n885), .Y(n882) );
  NOR2X1 U1012 ( .A(dph_write), .B(dph_haddr[4]), .Y(n885) );
  INVX1 U1013 ( .A(dph_haddr[2]), .Y(n695) );
  NOR2X1 U1014 ( .A(n699), .B(n886), .Y(N130) );
  INVX1 U1015 ( .A(dph_haddr[3]), .Y(n699) );
  NOR2X1 U1016 ( .A(dph_haddr[3]), .B(n886), .Y(N129) );
  NAND3X1 U1017 ( .A(n700), .B(n879), .C(n687), .Y(n886) );
  INVX1 U1018 ( .A(n857), .Y(n687) );
  NAND2X1 U1019 ( .A(n884), .B(dph_write), .Y(n857) );
  NOR2X1 U1020 ( .A(n887), .B(n888), .Y(n884) );
  NAND3X1 U1021 ( .A(n870), .B(n877), .C(dph_valid), .Y(n888) );
  INVX1 U1022 ( .A(dph_haddr[6]), .Y(n877) );
  INVX1 U1023 ( .A(dph_error), .Y(n870) );
  NAND3X1 U1024 ( .A(n613), .B(n610), .C(n875), .Y(n887) );
  INVX1 U1025 ( .A(dph_haddr[7]), .Y(n875) );
  INVX1 U1026 ( .A(dph_haddr[9]), .Y(n610) );
  INVX1 U1027 ( .A(dph_haddr[8]), .Y(n613) );
  INVX1 U1028 ( .A(dph_haddr[5]), .Y(n879) );
  INVX1 U1029 ( .A(dph_haddr[4]), .Y(n700) );
  AOI21X1 U1030 ( .A(hready_stall), .B(dph_valid), .C(n900), .Y(N114) );
  INVX1 U1031 ( .A(n889), .Y(n900) );
  NAND3X1 U1032 ( .A(n881), .B(n890), .C(n891), .Y(n889) );
  AND2X1 U1033 ( .A(n872), .B(htrans[1]), .Y(n891) );
  INVX1 U1034 ( .A(n868), .Y(n872) );
  OAI21X1 U1035 ( .A(n892), .B(n893), .C(hsel), .Y(n868) );
  NAND3X1 U1036 ( .A(n894), .B(n878), .C(n895), .Y(n893) );
  MUX2X1 U1037 ( .B(occ_err), .A(n896), .S(haddr[5]), .Y(n895) );
  NAND3X1 U1038 ( .A(n853), .B(n852), .C(n897), .Y(n896) );
  MUX2X1 U1039 ( .B(n898), .A(n899), .S(n847), .Y(n897) );
  INVX1 U1040 ( .A(haddr[2]), .Y(n847) );
  NOR2X1 U1041 ( .A(haddr[1]), .B(n869), .Y(n899) );
  INVX1 U1042 ( .A(hwrite), .Y(n869) );
  NAND2X1 U1043 ( .A(n810), .B(n788), .Y(n898) );
  INVX1 U1044 ( .A(haddr[0]), .Y(n788) );
  INVX1 U1045 ( .A(haddr[1]), .Y(n810) );
  INVX1 U1046 ( .A(haddr[4]), .Y(n852) );
  INVX1 U1047 ( .A(haddr[3]), .Y(n853) );
  INVX1 U1048 ( .A(haddr[6]), .Y(n878) );
  NAND3X1 U1049 ( .A(haddr[4]), .B(haddr[3]), .C(hwrite), .Y(n894) );
  NAND3X1 U1050 ( .A(n614), .B(n611), .C(n876), .Y(n892) );
  INVX1 U1051 ( .A(haddr[7]), .Y(n876) );
  INVX1 U1052 ( .A(haddr[9]), .Y(n611) );
  INVX1 U1053 ( .A(haddr[8]), .Y(n614) );
  INVX1 U1054 ( .A(err_state[1]), .Y(n890) );
  INVX1 U1055 ( .A(err_state[0]), .Y(n881) );
endmodule

