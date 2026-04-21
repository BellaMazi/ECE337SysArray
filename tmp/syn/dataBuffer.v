/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP4
// Date      : Fri Apr 17 13:53:43 2026
/////////////////////////////////////////////////////////////


module dataBuffer ( clk, n_rst, sram_rd_en, sram_wr_en, sram_addr, 
        sram_wr_data, ctrl_reg_clear, ctrl_reg_0, haddr, hwdata, hwrite, 
        ahb_req, sram_rd_data, sram_state_out, hready_stall, occ_err, 
        overrun_err );
  input [9:0] sram_addr;
  input [63:0] sram_wr_data;
  input [1:0] ctrl_reg_clear;
  input [9:0] haddr;
  input [63:0] hwdata;
  output [63:0] sram_rd_data;
  output [1:0] sram_state_out;
  input clk, n_rst, sram_rd_en, sram_wr_en, ctrl_reg_0, hwrite, ahb_req;
  output hready_stall, occ_err, overrun_err;
  wire   hold_re, hold_we, sram_re, sram_we, next_occ_err, next_overrun_err,
         N33, N34, N35, N41, N42, N43, N207, N290, N380, N388, n683, n685,
         n687, n689, n690, n693, n825, n827, n829, n831, n835, n837, n839,
         n841, n843, n845, n865, n867, n869, n871, n873, n875, n877, n879,
         n881, n883, n885, n887, n889, n891, n893, n895, n897, n899, n901,
         n903, n905, n907, n909, n911, n913, n915, n917, n919, n921, n923,
         n925, n927, n929, n931, n933, n935, n937, n939, n941, n943, n945,
         n947, n949, n951, n953, n955, n957, n959, n961, n963, n965, n967,
         n969, n971, n973, n975, n977, n979, n981, n983, n985, n987, n989,
         n991, n993, n995, n997, n999, n1001, n1003, n1005, n1006, n1007,
         n1008, n1009, n1010, n1011, n1012, n1013, n1014, n1015, n1016, n1017,
         n1018, n1019, n1020, n1021, n1022, n1023, n1024, n1025, n1026, n1027,
         n1028, n1029, n1030, n1031, n1032, n1033, n1034, n1035, n1036, n1037,
         n1038, n1039, n1040, n1041, n1042, n1043, n1044, n1045, n1046, n1047,
         n1048, n1049, n1050, n1051, n1052, n1053, n1054, n1055, n1056, n1057,
         n1058, n1059, n1060, n1061, n1062, n1063, n1064, n1065, n1066, n1067,
         n1068, n1069, n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077,
         n1078, n1079, n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087,
         n1088, n1089, n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097,
         n1098, n1099, n1100, n1101, n1102, n1103, n1104, n1105, n1106, n1107,
         n1108, n1109, n1110, n1111, n1112, n1113, n1114, n1115, n1116, n1117,
         n1118, n1119, n1120, n1121, n1122, n1123, n1124, n1125, n1126, n1127,
         n1128, n1129, n1130, n1131, n1132, n1133, n1134, n1135, n1136, n1137,
         n1138, n1139, n1140, n1141, n1142, n1143, n1144, n1145, n1146, n1147,
         n1148, n1149, n1150, n1151, n1152, n1153, n1154, n1155, n1156, n1157,
         n1158, n1159, n1160, n1161, n1162, n1163, n1164, n1165, n1166, n1167,
         n1168, n1169, n1170, n1171, n1172, n1173, n1174, n1175, n1176, n1177,
         n1178, n1179, n1180, n1181, n1182, n1183, n1184, n1185, n1186, n1187,
         n1188, n1189, n1190, n1191, n1192, n1193, n1194, n1195, n1196, n1197,
         n1198, n1199, n1200, n1201, n1202, n1203, n1204, n1205, n1206, n1207,
         n1208, n1209, n1210, n1211, n1212, n1213, n1214, n1215, n1216, n1217,
         n1218, n1219, n1220, n1221, n1222, n1223, n1224, n1225, n1226, n1227,
         n1228, n1229, n1230, n1231, n1232, n1233, n1234, n1235, n1236, n1237,
         n1238, n1239, n1240, n1241, n1242, n1243, n1244, n1245, n1246, n1247,
         n1248, n1249, n1250, n1251, n1252, n1253, n1254, n1255, n1256, n1257,
         n1258, n1259, n1260, n1261, n1262, n1263, n1264, n1265, n1266, n1267,
         n1268, n1269, n1270, n1271, n1272, n1273, n1274, n1275, n1276, n1277,
         n1278, n1279, n1280, n1281, n1282, n1283, n1284, n1285, n1286, n1287,
         n1288, n1289, n1290, n1291, n1292, n1293, n1294, n1295, n1296, n1297,
         n1298, n1299, n1300, n1301, n1302, n1303, n1304, n1305, n1306, n1307,
         n1308, n1309, n1310, n1311, n1312, n1313, n1314, n1315, n1316, n1317,
         n1318, n1319, n1320, n1321, n1322, n1323, n1324, n1325, n1326, n1327,
         n1328, n1329, n1330, n1331, n1332, n1333, n1334, n1335, n1336, n1337,
         n1338, n1339, n1340, n1341, n1342, n1343, n1344, n1345, n1346, n1347,
         n1348, n1349, n1350, n1351, n1352, n1353, n1354, n1355, n1356, n1357,
         n1358, n1359, n1360, n1361, n1362, n1363, n1364, n1365, n1366, n1367,
         n1368, n1369, n1370, n1371, n1372, n1373, n1374, n1375, n1376, n1377,
         n1378, n1379, n1380, n1381, n1382, n1383, n1384, n1385, n1386, n1387,
         n1388, n1389, n1390, n1391, n1392, n1393, n1394, n1395, n1396, n1397,
         n1398, n1399, n1400, n1401, n1402, n1403, n1404, n1405, n1406, n1407,
         n1408, n1409, n1410, n1411, n1412, n1413, n1414, n1415, n1416, n1417,
         n1418, n1419, n1420, n1421, n1422, n1423, n1424, n1425, n1426, n1427,
         n1428, n1429, n1430, n1431, n1432, n1433, n1434, n1435, n1436, n1437,
         n1438, n1439, n1440, n1441, n1442, n1443, n1444, n1445, n1446, n1447,
         n1448, n1449, n1450, n1451, n1452, n1453, n1454, n1455, n1456, n1457,
         n1458, n1459, n1460, n1461, n1462, n1463, n1464, n1465, n1466, n1467,
         n1468, n1469, n1470, n1471, n1472, n1473, n1474, n1475, n1476, n1477,
         n1478, n1479, n1480, n1481, n1482, n1483, n1484, n1485, n1486, n1487,
         n1488, n1489, n1490, n1491, n1492, n1493, n1494, n1495, n1496, n1497,
         n1498, n1499, n1500, n1501, n1502, n1503, n1504, n1505, n1506, n1507,
         n1508, n1509, n1510, n1511, n1512, n1513, n1514, n1515, n1516, n1517,
         n1518, n1519, n1520, n1521, n1522, n1523, n1524, n1525, n1526, n1527,
         n1528, n1529, n1530, n1531, n1532, n1533, n1534, n1535, n1536, n1537,
         n1538, n1539, n1540, n1541, n1542, n1543, n1544, n1545, n1546, n1547,
         n1548, n1549, n1550, n1551, n1552, n1553, n1554, n1555, n1556, n1557,
         n1558, n1559, n1560, n1561, n1562, n1563, n1564, n1565, n1566, n1567,
         n1568, n1569, n1570, n1571, n1572, n1573, n1574, n1575, n1576, n1577,
         n1578, n1579, n1580, n1581, n1582, n1583, n1584, n1585, n1586, n1587,
         n1588, n1589, n1590, n1591, n1592, n1593, n1594, n1595, n1596, n1597,
         n1598, n1599, n1600, n1601, n1602, n1603, n1604, n1605, n1606, n1607,
         n1608, n1609, n1610, n1611, n1612, n1613, n1614, n1615, n1616, n1617,
         n1618, n1619, n1620, n1621, n1622, n1623, n1624, n1625, n1626, n1627,
         n1628, n1629, n1630, n1631, n1632, n1633, n1634, n1635, n1636, n1637,
         n1638, n1639, n1640, n1641, n1642, n1643, n1644, n1645, n1646, n1647,
         n1648, n1649, n1650, n1651, n1652, n1653, n1654, n1659, n1660, n1661,
         n1662, n1663, n1664, n1665, n1666, n1667, n1668, n1669, n1670, n1671,
         n1672, n1673, n1674, n1675, n1676, n1677, n1678, n1679, n1680, n1681,
         n1682, n1683, n1684, n1685, n1686, n1687, n1688, n1689, n1690, n1691,
         n1692, n1693, n1694, n1695, n1696, n1697, n1698, n1699, n1700, n1701,
         n1702, n1703, n1704, n1705, n1706, n1707, n1708, n1709, n1710, n1711,
         n1712, n1713, n1714, n1715, n1716, n1717, n1718, n1719, n1720, n1721,
         n1722, n1723, n1724, n1725, n1726, n1727, n1728, n1729, n1730, n1731,
         n1732, n1733, n1734, n1735, n1736, n1737, n1738, n1739, n1740, n1741,
         n1742, n1743, n1744, n1745, n1746, n1747, n1748, n1749, n1750, n1751,
         n1752, n1753, n1754, n1755, n1756, n1757, n1758, n1759, n1760, n1761,
         n1762, n1763, n1764, n1765, n1766, n1767, n1768, n1769, n1770, n1771,
         n1772, n1773, n1774, n1775, n1776, n1777, n1778, n1779, n1780, n1781,
         n1782, n1783, n1784, n1785, n1786, n1787, n1788, n1789, n1790, n1791,
         n1792, n1793, n1794, n1795, n1796, n1797, n1798, n1799;
  wire   [5:0] wt_wr_ptr;
  wire   [3:0] out_valid_cnt;
  wire   [9:0] hold_addr;
  wire   [63:0] hold_wdata;
  wire   [5:0] next_wt_wr_ptr;
  wire   [2:0] next_in_wr_ptr;
  wire   [2:0] next_out_rd_ptr;
  wire   [3:0] next_out_valid_cnt;
  wire   [1:0] next_last_rd_region;
  wire   [1:0] last_rd_region;
  wire   [10:0] \sub_240/carry ;
  wire   [10:0] \sub_239/carry ;
  tri   clk;
  tri   n_rst;
  tri   [1:0] sram_state_out;
  tri   [9:0] sram_address;
  tri   [63:0] sram_wdata;
  tri   wt_re;
  tri   in_re;
  tri   out_re;
  tri   wt_we;
  tri   in_we;
  tri   out_we;
  tri   [9:0] in_addr;
  tri   [9:0] out_addr;
  tri   [31:0] wt_hi_rd;
  tri   [31:0] wt_lo_rd;
  tri   [31:0] in_hi_rd;
  tri   [31:0] in_lo_rd;
  tri   [31:0] out_hi_rd;
  tri   [31:0] out_lo_rd;

  AND2X2 C1117 ( .A(sram_we), .B(N290), .Y(out_we) );
  AND2X2 C1112 ( .A(N388), .B(N207), .Y(in_we) );
  AND2X2 C1107 ( .A(sram_we), .B(n1797), .Y(wt_we) );
  AND2X2 C1106 ( .A(sram_re), .B(N290), .Y(out_re) );
  AND2X2 C1101 ( .A(N380), .B(N207), .Y(in_re) );
  AND2X2 C1096 ( .A(sram_re), .B(n1797), .Y(wt_re) );
  DFFSR hold_we_reg ( .D(n1003), .CLK(clk), .R(n_rst), .S(1'b1), .Q(hold_we)
         );
  DFFSR hold_re_reg ( .D(n1001), .CLK(clk), .R(n_rst), .S(1'b1), .Q(hold_re)
         );
  DFFSR \hold_addr_reg[0]  ( .D(n999), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[0]) );
  DFFSR \hold_addr_reg[1]  ( .D(n997), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[1]) );
  DFFSR \hold_addr_reg[2]  ( .D(n995), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[2]) );
  DFFSR \hold_addr_reg[3]  ( .D(n993), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[3]) );
  DFFSR \hold_wdata_reg[63]  ( .D(n991), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[63]) );
  DFFSR \hold_wdata_reg[62]  ( .D(n989), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[62]) );
  DFFSR \hold_wdata_reg[61]  ( .D(n987), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[61]) );
  DFFSR \hold_wdata_reg[60]  ( .D(n985), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[60]) );
  DFFSR \hold_wdata_reg[59]  ( .D(n983), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[59]) );
  DFFSR \hold_wdata_reg[58]  ( .D(n981), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[58]) );
  DFFSR \hold_wdata_reg[57]  ( .D(n979), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[57]) );
  DFFSR \hold_wdata_reg[56]  ( .D(n977), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[56]) );
  DFFSR \hold_wdata_reg[55]  ( .D(n975), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[55]) );
  DFFSR \hold_wdata_reg[54]  ( .D(n973), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[54]) );
  DFFSR \hold_wdata_reg[53]  ( .D(n971), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[53]) );
  DFFSR \hold_wdata_reg[52]  ( .D(n969), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[52]) );
  DFFSR \hold_wdata_reg[51]  ( .D(n967), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[51]) );
  DFFSR \hold_wdata_reg[50]  ( .D(n965), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[50]) );
  DFFSR \hold_wdata_reg[49]  ( .D(n963), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[49]) );
  DFFSR \hold_wdata_reg[48]  ( .D(n961), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[48]) );
  DFFSR \hold_wdata_reg[47]  ( .D(n959), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[47]) );
  DFFSR \hold_wdata_reg[46]  ( .D(n957), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[46]) );
  DFFSR \hold_wdata_reg[45]  ( .D(n955), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[45]) );
  DFFSR \hold_wdata_reg[44]  ( .D(n953), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[44]) );
  DFFSR \hold_wdata_reg[43]  ( .D(n951), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[43]) );
  DFFSR \hold_wdata_reg[42]  ( .D(n949), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[42]) );
  DFFSR \hold_wdata_reg[41]  ( .D(n947), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[41]) );
  DFFSR \hold_wdata_reg[40]  ( .D(n945), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[40]) );
  DFFSR \hold_wdata_reg[39]  ( .D(n943), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[39]) );
  DFFSR \hold_wdata_reg[38]  ( .D(n941), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[38]) );
  DFFSR \hold_wdata_reg[37]  ( .D(n939), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[37]) );
  DFFSR \hold_wdata_reg[36]  ( .D(n937), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[36]) );
  DFFSR \hold_wdata_reg[35]  ( .D(n935), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[35]) );
  DFFSR \hold_wdata_reg[34]  ( .D(n933), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[34]) );
  DFFSR \hold_wdata_reg[33]  ( .D(n931), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[33]) );
  DFFSR \hold_wdata_reg[32]  ( .D(n929), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[32]) );
  DFFSR \hold_wdata_reg[31]  ( .D(n927), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[31]) );
  DFFSR \hold_wdata_reg[30]  ( .D(n925), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[30]) );
  DFFSR \hold_wdata_reg[29]  ( .D(n923), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[29]) );
  DFFSR \hold_wdata_reg[28]  ( .D(n921), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[28]) );
  DFFSR \hold_wdata_reg[27]  ( .D(n919), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[27]) );
  DFFSR \hold_wdata_reg[26]  ( .D(n917), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[26]) );
  DFFSR \hold_wdata_reg[25]  ( .D(n915), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[25]) );
  DFFSR \hold_wdata_reg[24]  ( .D(n913), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[24]) );
  DFFSR \hold_wdata_reg[23]  ( .D(n911), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[23]) );
  DFFSR \hold_wdata_reg[22]  ( .D(n909), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[22]) );
  DFFSR \hold_wdata_reg[21]  ( .D(n907), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[21]) );
  DFFSR \hold_wdata_reg[20]  ( .D(n905), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[20]) );
  DFFSR \hold_wdata_reg[19]  ( .D(n903), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[19]) );
  DFFSR \hold_wdata_reg[18]  ( .D(n901), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[18]) );
  DFFSR \hold_wdata_reg[17]  ( .D(n899), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[17]) );
  DFFSR \hold_wdata_reg[16]  ( .D(n897), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[16]) );
  DFFSR \hold_wdata_reg[15]  ( .D(n895), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[15]) );
  DFFSR \hold_wdata_reg[14]  ( .D(n893), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[14]) );
  DFFSR \hold_wdata_reg[13]  ( .D(n891), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[13]) );
  DFFSR \hold_wdata_reg[12]  ( .D(n889), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[12]) );
  DFFSR \hold_wdata_reg[11]  ( .D(n887), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[11]) );
  DFFSR \hold_wdata_reg[10]  ( .D(n885), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[10]) );
  DFFSR \hold_wdata_reg[9]  ( .D(n883), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[9]) );
  DFFSR \hold_wdata_reg[8]  ( .D(n881), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[8]) );
  DFFSR \hold_wdata_reg[7]  ( .D(n879), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[7]) );
  DFFSR \hold_wdata_reg[6]  ( .D(n877), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[6]) );
  DFFSR \hold_wdata_reg[5]  ( .D(n875), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[5]) );
  DFFSR \hold_wdata_reg[4]  ( .D(n873), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[4]) );
  DFFSR \hold_wdata_reg[3]  ( .D(n871), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[3]) );
  DFFSR \hold_wdata_reg[2]  ( .D(n869), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[2]) );
  DFFSR \hold_wdata_reg[1]  ( .D(n867), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[1]) );
  DFFSR \hold_wdata_reg[0]  ( .D(n865), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_wdata[0]) );
  DFFSR \wt_wr_ptr_reg[0]  ( .D(next_wt_wr_ptr[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(wt_wr_ptr[0]) );
  DFFSR \wt_wr_ptr_reg[1]  ( .D(next_wt_wr_ptr[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(wt_wr_ptr[1]) );
  DFFSR \wt_wr_ptr_reg[2]  ( .D(next_wt_wr_ptr[2]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(wt_wr_ptr[2]) );
  DFFSR \wt_wr_ptr_reg[3]  ( .D(next_wt_wr_ptr[3]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(wt_wr_ptr[3]) );
  DFFSR \wt_wr_ptr_reg[4]  ( .D(next_wt_wr_ptr[4]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(wt_wr_ptr[4]) );
  DFFSR \wt_wr_ptr_reg[5]  ( .D(next_wt_wr_ptr[5]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(wt_wr_ptr[5]) );
  DFFSR \in_wr_ptr_reg[0]  ( .D(next_in_wr_ptr[0]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(N33) );
  DFFSR \in_wr_ptr_reg[1]  ( .D(next_in_wr_ptr[1]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(N34) );
  DFFSR \in_wr_ptr_reg[2]  ( .D(next_in_wr_ptr[2]), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(N35) );
  DFFSR \out_rd_ptr_reg[0]  ( .D(next_out_rd_ptr[0]), .CLK(clk), .R(n_rst), 
        .S(1'b1), .Q(N41) );
  DFFSR \out_rd_ptr_reg[1]  ( .D(next_out_rd_ptr[1]), .CLK(clk), .R(n_rst), 
        .S(1'b1), .Q(N42) );
  DFFSR \out_rd_ptr_reg[2]  ( .D(next_out_rd_ptr[2]), .CLK(clk), .R(n_rst), 
        .S(1'b1), .Q(N43) );
  DFFSR \out_valid_cnt_reg[0]  ( .D(next_out_valid_cnt[0]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(out_valid_cnt[0]) );
  DFFSR \out_valid_cnt_reg[1]  ( .D(next_out_valid_cnt[1]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(out_valid_cnt[1]) );
  DFFSR \out_valid_cnt_reg[3]  ( .D(next_out_valid_cnt[3]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(out_valid_cnt[3]) );
  DFFSR \out_valid_cnt_reg[2]  ( .D(next_out_valid_cnt[2]), .CLK(clk), .R(
        n_rst), .S(1'b1), .Q(out_valid_cnt[2]) );
  DFFSR occ_err_ff_reg ( .D(next_occ_err), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        occ_err) );
  DFFSR overrun_err_ff_reg ( .D(next_overrun_err), .CLK(clk), .R(n_rst), .S(
        1'b1), .Q(overrun_err) );
  DFFSR \hold_addr_reg[9]  ( .D(n845), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[9]) );
  DFFSR \hold_addr_reg[8]  ( .D(n843), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[8]) );
  DFFSR \hold_addr_reg[7]  ( .D(n841), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[7]) );
  DFFSR \hold_addr_reg[6]  ( .D(n839), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[6]) );
  DFFSR \hold_addr_reg[5]  ( .D(n837), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[5]) );
  DFFSR \hold_addr_reg[4]  ( .D(n835), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        hold_addr[4]) );
  DFFSR \last_rd_region_reg[1]  ( .D(next_last_rd_region[1]), .CLK(clk), .R(
        1'b1), .S(n_rst), .Q(last_rd_region[1]) );
  DFFSR \last_rd_region_reg[0]  ( .D(next_last_rd_region[0]), .CLK(clk), .R(
        1'b1), .S(n_rst), .Q(last_rd_region[0]) );
  OR2X2 U980 ( .A(n683), .B(n1659), .Y(sram_address[4]) );
  OR2X2 U981 ( .A(n685), .B(n1660), .Y(sram_address[5]) );
  OR2X2 U982 ( .A(n687), .B(n1661), .Y(sram_address[6]) );
  OR2X2 U983 ( .A(n689), .B(n1662), .Y(sram_address[7]) );
  OAI21X1 U984 ( .A(n1796), .B(n1799), .C(n690), .Y(sram_address[8]) );
  OAI21X1 U985 ( .A(n1795), .B(n1798), .C(n693), .Y(sram_address[9]) );
  OR2X2 U986 ( .A(n1731), .B(n1663), .Y(sram_wdata[0]) );
  OR2X2 U987 ( .A(n1732), .B(n1664), .Y(sram_wdata[1]) );
  OR2X2 U988 ( .A(n1733), .B(n1665), .Y(sram_wdata[2]) );
  OR2X2 U989 ( .A(n1734), .B(n1666), .Y(sram_wdata[3]) );
  OR2X2 U990 ( .A(n1735), .B(n1667), .Y(sram_wdata[4]) );
  OR2X2 U991 ( .A(n1736), .B(n1668), .Y(sram_wdata[5]) );
  OR2X2 U992 ( .A(n1737), .B(n1669), .Y(sram_wdata[6]) );
  OR2X2 U993 ( .A(n1738), .B(n1670), .Y(sram_wdata[7]) );
  OR2X2 U994 ( .A(n1739), .B(n1671), .Y(sram_wdata[8]) );
  OR2X2 U995 ( .A(n1740), .B(n1672), .Y(sram_wdata[9]) );
  OR2X2 U996 ( .A(n1741), .B(n1673), .Y(sram_wdata[10]) );
  OR2X2 U997 ( .A(n1742), .B(n1674), .Y(sram_wdata[11]) );
  OR2X2 U998 ( .A(n1743), .B(n1675), .Y(sram_wdata[12]) );
  OR2X2 U999 ( .A(n1744), .B(n1676), .Y(sram_wdata[13]) );
  OR2X2 U1000 ( .A(n1745), .B(n1677), .Y(sram_wdata[14]) );
  OR2X2 U1001 ( .A(n1746), .B(n1678), .Y(sram_wdata[15]) );
  OR2X2 U1002 ( .A(n1747), .B(n1679), .Y(sram_wdata[16]) );
  OR2X2 U1003 ( .A(n1748), .B(n1680), .Y(sram_wdata[17]) );
  OR2X2 U1004 ( .A(n1749), .B(n1681), .Y(sram_wdata[18]) );
  OR2X2 U1005 ( .A(n1750), .B(n1682), .Y(sram_wdata[19]) );
  OR2X2 U1006 ( .A(n1751), .B(n1683), .Y(sram_wdata[20]) );
  OR2X2 U1007 ( .A(n1752), .B(n1684), .Y(sram_wdata[21]) );
  OR2X2 U1008 ( .A(n1753), .B(n1685), .Y(sram_wdata[22]) );
  OR2X2 U1009 ( .A(n1754), .B(n1686), .Y(sram_wdata[23]) );
  OR2X2 U1010 ( .A(n1755), .B(n1687), .Y(sram_wdata[24]) );
  OR2X2 U1011 ( .A(n1756), .B(n1688), .Y(sram_wdata[25]) );
  OR2X2 U1012 ( .A(n1757), .B(n1689), .Y(sram_wdata[26]) );
  OR2X2 U1013 ( .A(n1758), .B(n1690), .Y(sram_wdata[27]) );
  OR2X2 U1014 ( .A(n1759), .B(n1691), .Y(sram_wdata[28]) );
  OR2X2 U1015 ( .A(n1760), .B(n1692), .Y(sram_wdata[29]) );
  OR2X2 U1016 ( .A(n1761), .B(n1693), .Y(sram_wdata[30]) );
  OR2X2 U1017 ( .A(n1762), .B(n1694), .Y(sram_wdata[31]) );
  OR2X2 U1018 ( .A(n1763), .B(n1695), .Y(sram_wdata[32]) );
  OR2X2 U1019 ( .A(n1764), .B(n1696), .Y(sram_wdata[33]) );
  OR2X2 U1020 ( .A(n1765), .B(n1697), .Y(sram_wdata[34]) );
  OR2X2 U1021 ( .A(n1766), .B(n1698), .Y(sram_wdata[35]) );
  OR2X2 U1022 ( .A(n1767), .B(n1699), .Y(sram_wdata[36]) );
  OR2X2 U1023 ( .A(n1768), .B(n1700), .Y(sram_wdata[37]) );
  OR2X2 U1024 ( .A(n1769), .B(n1701), .Y(sram_wdata[38]) );
  OR2X2 U1025 ( .A(n1770), .B(n1702), .Y(sram_wdata[39]) );
  OR2X2 U1026 ( .A(n1771), .B(n1703), .Y(sram_wdata[40]) );
  OR2X2 U1027 ( .A(n1772), .B(n1704), .Y(sram_wdata[41]) );
  OR2X2 U1028 ( .A(n1773), .B(n1705), .Y(sram_wdata[42]) );
  OR2X2 U1029 ( .A(n1774), .B(n1706), .Y(sram_wdata[43]) );
  OR2X2 U1030 ( .A(n1775), .B(n1707), .Y(sram_wdata[44]) );
  OR2X2 U1031 ( .A(n1776), .B(n1708), .Y(sram_wdata[45]) );
  OR2X2 U1032 ( .A(n1777), .B(n1709), .Y(sram_wdata[46]) );
  OR2X2 U1033 ( .A(n1778), .B(n1710), .Y(sram_wdata[47]) );
  OR2X2 U1034 ( .A(n1779), .B(n1711), .Y(sram_wdata[48]) );
  OR2X2 U1035 ( .A(n1780), .B(n1712), .Y(sram_wdata[49]) );
  OR2X2 U1036 ( .A(n1781), .B(n1713), .Y(sram_wdata[50]) );
  OR2X2 U1037 ( .A(n1782), .B(n1714), .Y(sram_wdata[51]) );
  OR2X2 U1038 ( .A(n1783), .B(n1715), .Y(sram_wdata[52]) );
  OR2X2 U1039 ( .A(n1784), .B(n1716), .Y(sram_wdata[53]) );
  OR2X2 U1040 ( .A(n1785), .B(n1717), .Y(sram_wdata[54]) );
  OR2X2 U1041 ( .A(n1786), .B(n1718), .Y(sram_wdata[55]) );
  OR2X2 U1042 ( .A(n1787), .B(n1719), .Y(sram_wdata[56]) );
  OR2X2 U1043 ( .A(n1788), .B(n1720), .Y(sram_wdata[57]) );
  OR2X2 U1044 ( .A(n1789), .B(n1721), .Y(sram_wdata[58]) );
  OR2X2 U1045 ( .A(n1790), .B(n1722), .Y(sram_wdata[59]) );
  OR2X2 U1046 ( .A(n1791), .B(n1723), .Y(sram_wdata[60]) );
  OR2X2 U1047 ( .A(n1792), .B(n1724), .Y(sram_wdata[61]) );
  OR2X2 U1048 ( .A(n1793), .B(n1725), .Y(sram_wdata[62]) );
  OR2X2 U1049 ( .A(n1794), .B(n1726), .Y(sram_wdata[63]) );
  OR2X2 U1050 ( .A(n825), .B(n1727), .Y(sram_address[3]) );
  OR2X2 U1051 ( .A(n827), .B(n1728), .Y(sram_address[2]) );
  OR2X2 U1052 ( .A(n829), .B(n1729), .Y(sram_address[1]) );
  OR2X2 U1053 ( .A(n831), .B(n1730), .Y(sram_address[0]) );
  sram1024x32_wrapper wt_sram_hi ( .clk(clk), .n_rst(n_rst), .address(
        sram_address), .read_enable(wt_re), .write_enable(wt_we), .write_data(
        sram_wdata[63:32]), .read_data(wt_hi_rd) );
  sram1024x32_wrapper wt_sram_lo ( .clk(clk), .n_rst(n_rst), .address(
        sram_address), .read_enable(wt_re), .write_enable(wt_we), .write_data(
        sram_wdata[31:0]), .read_data(wt_lo_rd), .sram_state(sram_state_out)
         );
  sram1024x32_wrapper in_sram_hi ( .clk(clk), .n_rst(n_rst), .address(in_addr), 
        .read_enable(in_re), .write_enable(in_we), .write_data(
        sram_wdata[63:32]), .read_data(in_hi_rd) );
  sram1024x32_wrapper in_sram_lo ( .clk(clk), .n_rst(n_rst), .address(in_addr), 
        .read_enable(in_re), .write_enable(in_we), .write_data(
        sram_wdata[31:0]), .read_data(in_lo_rd) );
  sram1024x32_wrapper out_sram_hi ( .clk(clk), .n_rst(n_rst), .address(
        out_addr), .read_enable(out_re), .write_enable(out_we), .write_data(
        sram_wdata[63:32]), .read_data(out_hi_rd) );
  sram1024x32_wrapper out_sram_lo ( .clk(clk), .n_rst(n_rst), .address(
        out_addr), .read_enable(out_re), .write_enable(out_we), .write_data(
        sram_wdata[31:0]), .read_data(out_lo_rd) );
  FAX1 \sub_240/U2_0  ( .A(sram_address[0]), .B(1'b1), .C(1'b1), .YC(
        \sub_240/carry [1]), .YS(out_addr[0]) );
  FAX1 \sub_240/U2_1  ( .A(sram_address[1]), .B(1'b1), .C(\sub_240/carry [1]), 
        .YC(\sub_240/carry [2]), .YS(out_addr[1]) );
  FAX1 \sub_240/U2_2  ( .A(sram_address[2]), .B(1'b1), .C(\sub_240/carry [2]), 
        .YC(\sub_240/carry [3]), .YS(out_addr[2]) );
  FAX1 \sub_240/U2_3  ( .A(sram_address[3]), .B(1'b0), .C(\sub_240/carry [3]), 
        .YC(\sub_240/carry [4]), .YS(out_addr[3]) );
  FAX1 \sub_240/U2_4  ( .A(sram_address[4]), .B(1'b1), .C(\sub_240/carry [4]), 
        .YC(\sub_240/carry [5]), .YS(out_addr[4]) );
  FAX1 \sub_240/U2_5  ( .A(sram_address[5]), .B(1'b1), .C(\sub_240/carry [5]), 
        .YC(\sub_240/carry [6]), .YS(out_addr[5]) );
  FAX1 \sub_240/U2_6  ( .A(sram_address[6]), .B(1'b0), .C(\sub_240/carry [6]), 
        .YC(\sub_240/carry [7]), .YS(out_addr[6]) );
  FAX1 \sub_240/U2_7  ( .A(sram_address[7]), .B(1'b1), .C(\sub_240/carry [7]), 
        .YC(\sub_240/carry [8]), .YS(out_addr[7]) );
  FAX1 \sub_240/U2_8  ( .A(sram_address[8]), .B(1'b1), .C(\sub_240/carry [8]), 
        .YC(\sub_240/carry [9]), .YS(out_addr[8]) );
  FAX1 \sub_240/U2_9  ( .A(sram_address[9]), .B(1'b1), .C(\sub_240/carry [9]), 
        .YS(out_addr[9]) );
  FAX1 \sub_239/U2_0  ( .A(sram_address[0]), .B(1'b1), .C(1'b1), .YC(
        \sub_239/carry [1]), .YS(in_addr[0]) );
  FAX1 \sub_239/U2_1  ( .A(sram_address[1]), .B(1'b1), .C(\sub_239/carry [1]), 
        .YC(\sub_239/carry [2]), .YS(in_addr[1]) );
  FAX1 \sub_239/U2_2  ( .A(sram_address[2]), .B(1'b1), .C(\sub_239/carry [2]), 
        .YC(\sub_239/carry [3]), .YS(in_addr[2]) );
  FAX1 \sub_239/U2_3  ( .A(sram_address[3]), .B(1'b1), .C(\sub_239/carry [3]), 
        .YC(\sub_239/carry [4]), .YS(in_addr[3]) );
  FAX1 \sub_239/U2_4  ( .A(sram_address[4]), .B(1'b1), .C(\sub_239/carry [4]), 
        .YC(\sub_239/carry [5]), .YS(in_addr[4]) );
  FAX1 \sub_239/U2_5  ( .A(sram_address[5]), .B(1'b1), .C(\sub_239/carry [5]), 
        .YC(\sub_239/carry [6]), .YS(in_addr[5]) );
  FAX1 \sub_239/U2_6  ( .A(sram_address[6]), .B(1'b0), .C(\sub_239/carry [6]), 
        .YC(\sub_239/carry [7]), .YS(in_addr[6]) );
  FAX1 \sub_239/U2_7  ( .A(sram_address[7]), .B(1'b1), .C(\sub_239/carry [7]), 
        .YC(\sub_239/carry [8]), .YS(in_addr[7]) );
  FAX1 \sub_239/U2_8  ( .A(sram_address[8]), .B(1'b1), .C(\sub_239/carry [8]), 
        .YC(\sub_239/carry [9]), .YS(in_addr[8]) );
  FAX1 \sub_239/U2_9  ( .A(sram_address[9]), .B(1'b1), .C(\sub_239/carry [9]), 
        .YS(in_addr[9]) );
  OR2X2 U1150 ( .A(sram_state_out[0]), .B(sram_state_out[1]), .Y(n1005) );
  AND2X2 U1151 ( .A(n1018), .B(n1639), .Y(n1006) );
  NOR2X1 U1152 ( .A(n1224), .B(n1015), .Y(n1007) );
  OR2X2 U1153 ( .A(n1147), .B(last_rd_region[1]), .Y(n1008) );
  OR2X2 U1154 ( .A(sram_rd_en), .B(sram_wr_en), .Y(n1009) );
  OR2X2 U1155 ( .A(n1148), .B(last_rd_region[0]), .Y(n1010) );
  AND2X2 U1156 ( .A(n1148), .B(n1147), .Y(n1011) );
  INVX8 U1157 ( .A(n1011), .Y(n1012) );
  INVX8 U1158 ( .A(n1010), .Y(n1013) );
  INVX8 U1159 ( .A(hready_stall), .Y(n1239) );
  INVX8 U1160 ( .A(n1008), .Y(n1014) );
  INVX8 U1161 ( .A(n1639), .Y(n1241) );
  INVX8 U1162 ( .A(n1009), .Y(n1015) );
  INVX8 U1163 ( .A(n1006), .Y(n1016) );
  INVX8 U1164 ( .A(n1007), .Y(n1017) );
  INVX8 U1165 ( .A(n1613), .Y(n1224) );
  INVX8 U1166 ( .A(n1005), .Y(n1018) );
  OAI21X1 U1167 ( .A(n1012), .B(n1019), .C(n1020), .Y(sram_rd_data[9]) );
  AOI22X1 U1168 ( .A(out_lo_rd[9]), .B(n1013), .C(in_lo_rd[9]), .D(n1014), .Y(
        n1020) );
  INVX1 U1169 ( .A(wt_lo_rd[9]), .Y(n1019) );
  OAI21X1 U1170 ( .A(n1012), .B(n1021), .C(n1022), .Y(sram_rd_data[8]) );
  AOI22X1 U1171 ( .A(out_lo_rd[8]), .B(n1013), .C(in_lo_rd[8]), .D(n1014), .Y(
        n1022) );
  INVX1 U1172 ( .A(wt_lo_rd[8]), .Y(n1021) );
  OAI21X1 U1173 ( .A(n1012), .B(n1023), .C(n1024), .Y(sram_rd_data[7]) );
  AOI22X1 U1174 ( .A(out_lo_rd[7]), .B(n1013), .C(in_lo_rd[7]), .D(n1014), .Y(
        n1024) );
  INVX1 U1175 ( .A(wt_lo_rd[7]), .Y(n1023) );
  OAI21X1 U1176 ( .A(n1012), .B(n1025), .C(n1026), .Y(sram_rd_data[6]) );
  AOI22X1 U1177 ( .A(out_lo_rd[6]), .B(n1013), .C(in_lo_rd[6]), .D(n1014), .Y(
        n1026) );
  INVX1 U1178 ( .A(wt_lo_rd[6]), .Y(n1025) );
  OAI21X1 U1179 ( .A(n1012), .B(n1027), .C(n1028), .Y(sram_rd_data[63]) );
  AOI22X1 U1180 ( .A(out_hi_rd[31]), .B(n1013), .C(in_hi_rd[31]), .D(n1014), 
        .Y(n1028) );
  INVX1 U1181 ( .A(wt_hi_rd[31]), .Y(n1027) );
  OAI21X1 U1182 ( .A(n1012), .B(n1029), .C(n1030), .Y(sram_rd_data[62]) );
  AOI22X1 U1183 ( .A(out_hi_rd[30]), .B(n1013), .C(in_hi_rd[30]), .D(n1014), 
        .Y(n1030) );
  INVX1 U1184 ( .A(wt_hi_rd[30]), .Y(n1029) );
  OAI21X1 U1185 ( .A(n1012), .B(n1031), .C(n1032), .Y(sram_rd_data[61]) );
  AOI22X1 U1186 ( .A(out_hi_rd[29]), .B(n1013), .C(in_hi_rd[29]), .D(n1014), 
        .Y(n1032) );
  INVX1 U1187 ( .A(wt_hi_rd[29]), .Y(n1031) );
  OAI21X1 U1188 ( .A(n1012), .B(n1033), .C(n1034), .Y(sram_rd_data[60]) );
  AOI22X1 U1189 ( .A(out_hi_rd[28]), .B(n1013), .C(in_hi_rd[28]), .D(n1014), 
        .Y(n1034) );
  INVX1 U1190 ( .A(wt_hi_rd[28]), .Y(n1033) );
  OAI21X1 U1191 ( .A(n1012), .B(n1035), .C(n1036), .Y(sram_rd_data[5]) );
  AOI22X1 U1192 ( .A(out_lo_rd[5]), .B(n1013), .C(in_lo_rd[5]), .D(n1014), .Y(
        n1036) );
  INVX1 U1193 ( .A(wt_lo_rd[5]), .Y(n1035) );
  OAI21X1 U1194 ( .A(n1012), .B(n1037), .C(n1038), .Y(sram_rd_data[59]) );
  AOI22X1 U1195 ( .A(out_hi_rd[27]), .B(n1013), .C(in_hi_rd[27]), .D(n1014), 
        .Y(n1038) );
  INVX1 U1196 ( .A(wt_hi_rd[27]), .Y(n1037) );
  OAI21X1 U1197 ( .A(n1012), .B(n1039), .C(n1040), .Y(sram_rd_data[58]) );
  AOI22X1 U1198 ( .A(out_hi_rd[26]), .B(n1013), .C(in_hi_rd[26]), .D(n1014), 
        .Y(n1040) );
  INVX1 U1199 ( .A(wt_hi_rd[26]), .Y(n1039) );
  OAI21X1 U1200 ( .A(n1012), .B(n1041), .C(n1042), .Y(sram_rd_data[57]) );
  AOI22X1 U1201 ( .A(out_hi_rd[25]), .B(n1013), .C(in_hi_rd[25]), .D(n1014), 
        .Y(n1042) );
  INVX1 U1202 ( .A(wt_hi_rd[25]), .Y(n1041) );
  OAI21X1 U1203 ( .A(n1012), .B(n1043), .C(n1044), .Y(sram_rd_data[56]) );
  AOI22X1 U1204 ( .A(out_hi_rd[24]), .B(n1013), .C(in_hi_rd[24]), .D(n1014), 
        .Y(n1044) );
  INVX1 U1205 ( .A(wt_hi_rd[24]), .Y(n1043) );
  OAI21X1 U1206 ( .A(n1012), .B(n1045), .C(n1046), .Y(sram_rd_data[55]) );
  AOI22X1 U1207 ( .A(out_hi_rd[23]), .B(n1013), .C(in_hi_rd[23]), .D(n1014), 
        .Y(n1046) );
  INVX1 U1208 ( .A(wt_hi_rd[23]), .Y(n1045) );
  OAI21X1 U1209 ( .A(n1012), .B(n1047), .C(n1048), .Y(sram_rd_data[54]) );
  AOI22X1 U1210 ( .A(out_hi_rd[22]), .B(n1013), .C(in_hi_rd[22]), .D(n1014), 
        .Y(n1048) );
  INVX1 U1211 ( .A(wt_hi_rd[22]), .Y(n1047) );
  OAI21X1 U1212 ( .A(n1012), .B(n1049), .C(n1050), .Y(sram_rd_data[53]) );
  AOI22X1 U1213 ( .A(out_hi_rd[21]), .B(n1013), .C(in_hi_rd[21]), .D(n1014), 
        .Y(n1050) );
  INVX1 U1214 ( .A(wt_hi_rd[21]), .Y(n1049) );
  OAI21X1 U1215 ( .A(n1012), .B(n1051), .C(n1052), .Y(sram_rd_data[52]) );
  AOI22X1 U1216 ( .A(out_hi_rd[20]), .B(n1013), .C(in_hi_rd[20]), .D(n1014), 
        .Y(n1052) );
  INVX1 U1217 ( .A(wt_hi_rd[20]), .Y(n1051) );
  OAI21X1 U1218 ( .A(n1012), .B(n1053), .C(n1054), .Y(sram_rd_data[51]) );
  AOI22X1 U1219 ( .A(out_hi_rd[19]), .B(n1013), .C(in_hi_rd[19]), .D(n1014), 
        .Y(n1054) );
  INVX1 U1220 ( .A(wt_hi_rd[19]), .Y(n1053) );
  OAI21X1 U1221 ( .A(n1012), .B(n1055), .C(n1056), .Y(sram_rd_data[50]) );
  AOI22X1 U1222 ( .A(out_hi_rd[18]), .B(n1013), .C(in_hi_rd[18]), .D(n1014), 
        .Y(n1056) );
  INVX1 U1223 ( .A(wt_hi_rd[18]), .Y(n1055) );
  OAI21X1 U1224 ( .A(n1012), .B(n1057), .C(n1058), .Y(sram_rd_data[4]) );
  AOI22X1 U1225 ( .A(out_lo_rd[4]), .B(n1013), .C(in_lo_rd[4]), .D(n1014), .Y(
        n1058) );
  INVX1 U1226 ( .A(wt_lo_rd[4]), .Y(n1057) );
  OAI21X1 U1227 ( .A(n1012), .B(n1059), .C(n1060), .Y(sram_rd_data[49]) );
  AOI22X1 U1228 ( .A(out_hi_rd[17]), .B(n1013), .C(in_hi_rd[17]), .D(n1014), 
        .Y(n1060) );
  INVX1 U1229 ( .A(wt_hi_rd[17]), .Y(n1059) );
  OAI21X1 U1230 ( .A(n1012), .B(n1061), .C(n1062), .Y(sram_rd_data[48]) );
  AOI22X1 U1231 ( .A(out_hi_rd[16]), .B(n1013), .C(in_hi_rd[16]), .D(n1014), 
        .Y(n1062) );
  INVX1 U1232 ( .A(wt_hi_rd[16]), .Y(n1061) );
  OAI21X1 U1233 ( .A(n1012), .B(n1063), .C(n1064), .Y(sram_rd_data[47]) );
  AOI22X1 U1234 ( .A(out_hi_rd[15]), .B(n1013), .C(in_hi_rd[15]), .D(n1014), 
        .Y(n1064) );
  INVX1 U1235 ( .A(wt_hi_rd[15]), .Y(n1063) );
  OAI21X1 U1236 ( .A(n1012), .B(n1065), .C(n1066), .Y(sram_rd_data[46]) );
  AOI22X1 U1237 ( .A(out_hi_rd[14]), .B(n1013), .C(in_hi_rd[14]), .D(n1014), 
        .Y(n1066) );
  INVX1 U1238 ( .A(wt_hi_rd[14]), .Y(n1065) );
  OAI21X1 U1239 ( .A(n1012), .B(n1067), .C(n1068), .Y(sram_rd_data[45]) );
  AOI22X1 U1240 ( .A(out_hi_rd[13]), .B(n1013), .C(in_hi_rd[13]), .D(n1014), 
        .Y(n1068) );
  INVX1 U1241 ( .A(wt_hi_rd[13]), .Y(n1067) );
  OAI21X1 U1242 ( .A(n1012), .B(n1069), .C(n1070), .Y(sram_rd_data[44]) );
  AOI22X1 U1243 ( .A(out_hi_rd[12]), .B(n1013), .C(in_hi_rd[12]), .D(n1014), 
        .Y(n1070) );
  INVX1 U1244 ( .A(wt_hi_rd[12]), .Y(n1069) );
  OAI21X1 U1245 ( .A(n1012), .B(n1071), .C(n1072), .Y(sram_rd_data[43]) );
  AOI22X1 U1246 ( .A(out_hi_rd[11]), .B(n1013), .C(in_hi_rd[11]), .D(n1014), 
        .Y(n1072) );
  INVX1 U1247 ( .A(wt_hi_rd[11]), .Y(n1071) );
  OAI21X1 U1248 ( .A(n1012), .B(n1073), .C(n1074), .Y(sram_rd_data[42]) );
  AOI22X1 U1249 ( .A(out_hi_rd[10]), .B(n1013), .C(in_hi_rd[10]), .D(n1014), 
        .Y(n1074) );
  INVX1 U1250 ( .A(wt_hi_rd[10]), .Y(n1073) );
  OAI21X1 U1251 ( .A(n1012), .B(n1075), .C(n1076), .Y(sram_rd_data[41]) );
  AOI22X1 U1252 ( .A(out_hi_rd[9]), .B(n1013), .C(in_hi_rd[9]), .D(n1014), .Y(
        n1076) );
  INVX1 U1253 ( .A(wt_hi_rd[9]), .Y(n1075) );
  OAI21X1 U1254 ( .A(n1012), .B(n1077), .C(n1078), .Y(sram_rd_data[40]) );
  AOI22X1 U1255 ( .A(out_hi_rd[8]), .B(n1013), .C(in_hi_rd[8]), .D(n1014), .Y(
        n1078) );
  INVX1 U1256 ( .A(wt_hi_rd[8]), .Y(n1077) );
  OAI21X1 U1257 ( .A(n1012), .B(n1079), .C(n1080), .Y(sram_rd_data[3]) );
  AOI22X1 U1258 ( .A(out_lo_rd[3]), .B(n1013), .C(in_lo_rd[3]), .D(n1014), .Y(
        n1080) );
  INVX1 U1259 ( .A(wt_lo_rd[3]), .Y(n1079) );
  OAI21X1 U1260 ( .A(n1012), .B(n1081), .C(n1082), .Y(sram_rd_data[39]) );
  AOI22X1 U1261 ( .A(out_hi_rd[7]), .B(n1013), .C(in_hi_rd[7]), .D(n1014), .Y(
        n1082) );
  INVX1 U1262 ( .A(wt_hi_rd[7]), .Y(n1081) );
  OAI21X1 U1263 ( .A(n1012), .B(n1083), .C(n1084), .Y(sram_rd_data[38]) );
  AOI22X1 U1264 ( .A(out_hi_rd[6]), .B(n1013), .C(in_hi_rd[6]), .D(n1014), .Y(
        n1084) );
  INVX1 U1265 ( .A(wt_hi_rd[6]), .Y(n1083) );
  OAI21X1 U1266 ( .A(n1012), .B(n1085), .C(n1086), .Y(sram_rd_data[37]) );
  AOI22X1 U1267 ( .A(out_hi_rd[5]), .B(n1013), .C(in_hi_rd[5]), .D(n1014), .Y(
        n1086) );
  INVX1 U1268 ( .A(wt_hi_rd[5]), .Y(n1085) );
  OAI21X1 U1269 ( .A(n1012), .B(n1087), .C(n1088), .Y(sram_rd_data[36]) );
  AOI22X1 U1270 ( .A(out_hi_rd[4]), .B(n1013), .C(in_hi_rd[4]), .D(n1014), .Y(
        n1088) );
  INVX1 U1271 ( .A(wt_hi_rd[4]), .Y(n1087) );
  OAI21X1 U1272 ( .A(n1012), .B(n1089), .C(n1090), .Y(sram_rd_data[35]) );
  AOI22X1 U1273 ( .A(out_hi_rd[3]), .B(n1013), .C(in_hi_rd[3]), .D(n1014), .Y(
        n1090) );
  INVX1 U1274 ( .A(wt_hi_rd[3]), .Y(n1089) );
  OAI21X1 U1275 ( .A(n1012), .B(n1091), .C(n1092), .Y(sram_rd_data[34]) );
  AOI22X1 U1276 ( .A(out_hi_rd[2]), .B(n1013), .C(in_hi_rd[2]), .D(n1014), .Y(
        n1092) );
  INVX1 U1277 ( .A(wt_hi_rd[2]), .Y(n1091) );
  OAI21X1 U1278 ( .A(n1012), .B(n1093), .C(n1094), .Y(sram_rd_data[33]) );
  AOI22X1 U1279 ( .A(out_hi_rd[1]), .B(n1013), .C(in_hi_rd[1]), .D(n1014), .Y(
        n1094) );
  INVX1 U1280 ( .A(wt_hi_rd[1]), .Y(n1093) );
  OAI21X1 U1281 ( .A(n1012), .B(n1095), .C(n1096), .Y(sram_rd_data[32]) );
  AOI22X1 U1282 ( .A(out_hi_rd[0]), .B(n1013), .C(in_hi_rd[0]), .D(n1014), .Y(
        n1096) );
  INVX1 U1283 ( .A(wt_hi_rd[0]), .Y(n1095) );
  OAI21X1 U1284 ( .A(n1012), .B(n1097), .C(n1098), .Y(sram_rd_data[31]) );
  AOI22X1 U1285 ( .A(out_lo_rd[31]), .B(n1013), .C(in_lo_rd[31]), .D(n1014), 
        .Y(n1098) );
  INVX1 U1286 ( .A(wt_lo_rd[31]), .Y(n1097) );
  OAI21X1 U1287 ( .A(n1012), .B(n1099), .C(n1100), .Y(sram_rd_data[30]) );
  AOI22X1 U1288 ( .A(out_lo_rd[30]), .B(n1013), .C(in_lo_rd[30]), .D(n1014), 
        .Y(n1100) );
  INVX1 U1289 ( .A(wt_lo_rd[30]), .Y(n1099) );
  OAI21X1 U1290 ( .A(n1012), .B(n1101), .C(n1102), .Y(sram_rd_data[2]) );
  AOI22X1 U1291 ( .A(out_lo_rd[2]), .B(n1013), .C(in_lo_rd[2]), .D(n1014), .Y(
        n1102) );
  INVX1 U1292 ( .A(wt_lo_rd[2]), .Y(n1101) );
  OAI21X1 U1293 ( .A(n1012), .B(n1103), .C(n1104), .Y(sram_rd_data[29]) );
  AOI22X1 U1294 ( .A(out_lo_rd[29]), .B(n1013), .C(in_lo_rd[29]), .D(n1014), 
        .Y(n1104) );
  INVX1 U1295 ( .A(wt_lo_rd[29]), .Y(n1103) );
  OAI21X1 U1296 ( .A(n1012), .B(n1105), .C(n1106), .Y(sram_rd_data[28]) );
  AOI22X1 U1297 ( .A(out_lo_rd[28]), .B(n1013), .C(in_lo_rd[28]), .D(n1014), 
        .Y(n1106) );
  INVX1 U1298 ( .A(wt_lo_rd[28]), .Y(n1105) );
  OAI21X1 U1299 ( .A(n1012), .B(n1107), .C(n1108), .Y(sram_rd_data[27]) );
  AOI22X1 U1300 ( .A(out_lo_rd[27]), .B(n1013), .C(in_lo_rd[27]), .D(n1014), 
        .Y(n1108) );
  INVX1 U1301 ( .A(wt_lo_rd[27]), .Y(n1107) );
  OAI21X1 U1302 ( .A(n1012), .B(n1109), .C(n1110), .Y(sram_rd_data[26]) );
  AOI22X1 U1303 ( .A(out_lo_rd[26]), .B(n1013), .C(in_lo_rd[26]), .D(n1014), 
        .Y(n1110) );
  INVX1 U1304 ( .A(wt_lo_rd[26]), .Y(n1109) );
  OAI21X1 U1305 ( .A(n1012), .B(n1111), .C(n1112), .Y(sram_rd_data[25]) );
  AOI22X1 U1306 ( .A(out_lo_rd[25]), .B(n1013), .C(in_lo_rd[25]), .D(n1014), 
        .Y(n1112) );
  INVX1 U1307 ( .A(wt_lo_rd[25]), .Y(n1111) );
  OAI21X1 U1308 ( .A(n1012), .B(n1113), .C(n1114), .Y(sram_rd_data[24]) );
  AOI22X1 U1309 ( .A(out_lo_rd[24]), .B(n1013), .C(in_lo_rd[24]), .D(n1014), 
        .Y(n1114) );
  INVX1 U1310 ( .A(wt_lo_rd[24]), .Y(n1113) );
  OAI21X1 U1311 ( .A(n1012), .B(n1115), .C(n1116), .Y(sram_rd_data[23]) );
  AOI22X1 U1312 ( .A(out_lo_rd[23]), .B(n1013), .C(in_lo_rd[23]), .D(n1014), 
        .Y(n1116) );
  INVX1 U1313 ( .A(wt_lo_rd[23]), .Y(n1115) );
  OAI21X1 U1314 ( .A(n1012), .B(n1117), .C(n1118), .Y(sram_rd_data[22]) );
  AOI22X1 U1315 ( .A(out_lo_rd[22]), .B(n1013), .C(in_lo_rd[22]), .D(n1014), 
        .Y(n1118) );
  INVX1 U1316 ( .A(wt_lo_rd[22]), .Y(n1117) );
  OAI21X1 U1317 ( .A(n1012), .B(n1119), .C(n1120), .Y(sram_rd_data[21]) );
  AOI22X1 U1318 ( .A(out_lo_rd[21]), .B(n1013), .C(in_lo_rd[21]), .D(n1014), 
        .Y(n1120) );
  INVX1 U1319 ( .A(wt_lo_rd[21]), .Y(n1119) );
  OAI21X1 U1320 ( .A(n1012), .B(n1121), .C(n1122), .Y(sram_rd_data[20]) );
  AOI22X1 U1321 ( .A(out_lo_rd[20]), .B(n1013), .C(in_lo_rd[20]), .D(n1014), 
        .Y(n1122) );
  INVX1 U1322 ( .A(wt_lo_rd[20]), .Y(n1121) );
  OAI21X1 U1323 ( .A(n1012), .B(n1123), .C(n1124), .Y(sram_rd_data[1]) );
  AOI22X1 U1324 ( .A(out_lo_rd[1]), .B(n1013), .C(in_lo_rd[1]), .D(n1014), .Y(
        n1124) );
  INVX1 U1325 ( .A(wt_lo_rd[1]), .Y(n1123) );
  OAI21X1 U1326 ( .A(n1012), .B(n1125), .C(n1126), .Y(sram_rd_data[19]) );
  AOI22X1 U1327 ( .A(out_lo_rd[19]), .B(n1013), .C(in_lo_rd[19]), .D(n1014), 
        .Y(n1126) );
  INVX1 U1328 ( .A(wt_lo_rd[19]), .Y(n1125) );
  OAI21X1 U1329 ( .A(n1012), .B(n1127), .C(n1128), .Y(sram_rd_data[18]) );
  AOI22X1 U1330 ( .A(out_lo_rd[18]), .B(n1013), .C(in_lo_rd[18]), .D(n1014), 
        .Y(n1128) );
  INVX1 U1331 ( .A(wt_lo_rd[18]), .Y(n1127) );
  OAI21X1 U1332 ( .A(n1012), .B(n1129), .C(n1130), .Y(sram_rd_data[17]) );
  AOI22X1 U1333 ( .A(out_lo_rd[17]), .B(n1013), .C(in_lo_rd[17]), .D(n1014), 
        .Y(n1130) );
  INVX1 U1334 ( .A(wt_lo_rd[17]), .Y(n1129) );
  OAI21X1 U1335 ( .A(n1012), .B(n1131), .C(n1132), .Y(sram_rd_data[16]) );
  AOI22X1 U1336 ( .A(out_lo_rd[16]), .B(n1013), .C(in_lo_rd[16]), .D(n1014), 
        .Y(n1132) );
  INVX1 U1337 ( .A(wt_lo_rd[16]), .Y(n1131) );
  OAI21X1 U1338 ( .A(n1012), .B(n1133), .C(n1134), .Y(sram_rd_data[15]) );
  AOI22X1 U1339 ( .A(out_lo_rd[15]), .B(n1013), .C(in_lo_rd[15]), .D(n1014), 
        .Y(n1134) );
  INVX1 U1340 ( .A(wt_lo_rd[15]), .Y(n1133) );
  OAI21X1 U1341 ( .A(n1012), .B(n1135), .C(n1136), .Y(sram_rd_data[14]) );
  AOI22X1 U1342 ( .A(out_lo_rd[14]), .B(n1013), .C(in_lo_rd[14]), .D(n1014), 
        .Y(n1136) );
  INVX1 U1343 ( .A(wt_lo_rd[14]), .Y(n1135) );
  OAI21X1 U1344 ( .A(n1012), .B(n1137), .C(n1138), .Y(sram_rd_data[13]) );
  AOI22X1 U1345 ( .A(out_lo_rd[13]), .B(n1013), .C(in_lo_rd[13]), .D(n1014), 
        .Y(n1138) );
  INVX1 U1346 ( .A(wt_lo_rd[13]), .Y(n1137) );
  OAI21X1 U1347 ( .A(n1012), .B(n1139), .C(n1140), .Y(sram_rd_data[12]) );
  AOI22X1 U1348 ( .A(out_lo_rd[12]), .B(n1013), .C(in_lo_rd[12]), .D(n1014), 
        .Y(n1140) );
  INVX1 U1349 ( .A(wt_lo_rd[12]), .Y(n1139) );
  OAI21X1 U1350 ( .A(n1012), .B(n1141), .C(n1142), .Y(sram_rd_data[11]) );
  AOI22X1 U1351 ( .A(out_lo_rd[11]), .B(n1013), .C(in_lo_rd[11]), .D(n1014), 
        .Y(n1142) );
  INVX1 U1352 ( .A(wt_lo_rd[11]), .Y(n1141) );
  OAI21X1 U1353 ( .A(n1012), .B(n1143), .C(n1144), .Y(sram_rd_data[10]) );
  AOI22X1 U1354 ( .A(out_lo_rd[10]), .B(n1013), .C(in_lo_rd[10]), .D(n1014), 
        .Y(n1144) );
  INVX1 U1355 ( .A(wt_lo_rd[10]), .Y(n1143) );
  OAI21X1 U1356 ( .A(n1012), .B(n1145), .C(n1146), .Y(sram_rd_data[0]) );
  AOI22X1 U1357 ( .A(out_lo_rd[0]), .B(n1013), .C(in_lo_rd[0]), .D(n1014), .Y(
        n1146) );
  INVX1 U1358 ( .A(wt_lo_rd[0]), .Y(n1145) );
  OAI21X1 U1359 ( .A(n1149), .B(n1150), .C(n1151), .Y(next_wt_wr_ptr[5]) );
  OAI21X1 U1360 ( .A(n1152), .B(n1153), .C(wt_wr_ptr[5]), .Y(n1151) );
  MUX2X1 U1361 ( .B(n1154), .A(n1155), .S(wt_wr_ptr[4]), .Y(next_wt_wr_ptr[4])
         );
  INVX1 U1362 ( .A(n1153), .Y(n1155) );
  OAI21X1 U1363 ( .A(wt_wr_ptr[3]), .B(n1150), .C(n1156), .Y(n1153) );
  NAND3X1 U1364 ( .A(wt_wr_ptr[3]), .B(n1157), .C(n1152), .Y(n1154) );
  MUX2X1 U1365 ( .B(n1158), .A(n1156), .S(wt_wr_ptr[3]), .Y(next_wt_wr_ptr[3])
         );
  INVX1 U1366 ( .A(n1159), .Y(n1156) );
  OAI21X1 U1367 ( .A(n1157), .B(n1150), .C(n1160), .Y(n1159) );
  NAND2X1 U1368 ( .A(n1152), .B(n1157), .Y(n1158) );
  MUX2X1 U1369 ( .B(n1161), .A(n1162), .S(wt_wr_ptr[2]), .Y(next_wt_wr_ptr[2])
         );
  AOI21X1 U1370 ( .A(n1152), .B(n1163), .C(n1164), .Y(n1162) );
  NAND3X1 U1371 ( .A(wt_wr_ptr[1]), .B(wt_wr_ptr[0]), .C(n1152), .Y(n1161) );
  MUX2X1 U1372 ( .B(n1165), .A(n1166), .S(wt_wr_ptr[1]), .Y(next_wt_wr_ptr[1])
         );
  INVX1 U1373 ( .A(n1164), .Y(n1166) );
  OAI21X1 U1374 ( .A(wt_wr_ptr[0]), .B(n1150), .C(n1160), .Y(n1164) );
  NAND2X1 U1375 ( .A(n1152), .B(wt_wr_ptr[0]), .Y(n1165) );
  MUX2X1 U1376 ( .B(n1150), .A(n1160), .S(wt_wr_ptr[0]), .Y(next_wt_wr_ptr[0])
         );
  OAI21X1 U1377 ( .A(n1167), .B(n1168), .C(n1169), .Y(n1160) );
  INVX1 U1378 ( .A(ctrl_reg_clear[1]), .Y(n1169) );
  INVX1 U1379 ( .A(n1152), .Y(n1150) );
  NOR2X1 U1380 ( .A(n1168), .B(ctrl_reg_clear[1]), .Y(n1152) );
  AOI21X1 U1381 ( .A(n1170), .B(n1171), .C(n1172), .Y(next_overrun_err) );
  OAI21X1 U1382 ( .A(out_valid_cnt[3]), .B(n1173), .C(n1174), .Y(n1171) );
  INVX1 U1383 ( .A(overrun_err), .Y(n1170) );
  NAND2X1 U1384 ( .A(n1175), .B(n1176), .Y(next_out_valid_cnt[3]) );
  OAI21X1 U1385 ( .A(n1173), .B(n1177), .C(out_valid_cnt[3]), .Y(n1176) );
  OAI21X1 U1386 ( .A(n1173), .B(n1177), .C(n1178), .Y(next_out_valid_cnt[2])
         );
  NAND2X1 U1387 ( .A(out_valid_cnt[2]), .B(n1179), .Y(n1178) );
  OAI21X1 U1388 ( .A(n1177), .B(n1180), .C(n1181), .Y(n1179) );
  MUX2X1 U1389 ( .B(n1182), .A(n1181), .S(out_valid_cnt[1]), .Y(
        next_out_valid_cnt[1]) );
  MUX2X1 U1390 ( .B(n1175), .A(out_valid_cnt[0]), .S(n1183), .Y(n1181) );
  NAND2X1 U1391 ( .A(n1183), .B(n1184), .Y(n1182) );
  MUX2X1 U1392 ( .B(n1185), .A(out_valid_cnt[0]), .S(n1183), .Y(
        next_out_valid_cnt[0]) );
  INVX1 U1393 ( .A(n1177), .Y(n1183) );
  OAI21X1 U1394 ( .A(out_valid_cnt[3]), .B(n1173), .C(n1186), .Y(n1177) );
  NAND3X1 U1395 ( .A(n1180), .B(n1187), .C(n1184), .Y(n1173) );
  INVX1 U1396 ( .A(out_valid_cnt[0]), .Y(n1184) );
  INVX1 U1397 ( .A(out_valid_cnt[2]), .Y(n1187) );
  INVX1 U1398 ( .A(out_valid_cnt[1]), .Y(n1180) );
  NAND2X1 U1399 ( .A(out_valid_cnt[0]), .B(n1175), .Y(n1185) );
  INVX1 U1400 ( .A(n1174), .Y(n1175) );
  NOR2X1 U1401 ( .A(n1188), .B(n1189), .Y(n1174) );
  NAND3X1 U1402 ( .A(haddr[3]), .B(n1190), .C(haddr[6]), .Y(n1189) );
  NAND3X1 U1403 ( .A(n1191), .B(sram_wr_en), .C(n1192), .Y(n1188) );
  NOR2X1 U1404 ( .A(haddr[5]), .B(n1193), .Y(n1192) );
  MUX2X1 U1405 ( .B(n1194), .A(n1195), .S(N43), .Y(next_out_rd_ptr[2]) );
  INVX1 U1406 ( .A(n1196), .Y(n1195) );
  OAI21X1 U1407 ( .A(N42), .B(ctrl_reg_clear[0]), .C(n1197), .Y(n1196) );
  OR2X1 U1408 ( .A(n1198), .B(n1199), .Y(n1194) );
  MUX2X1 U1409 ( .B(n1199), .A(n1197), .S(N42), .Y(next_out_rd_ptr[1]) );
  NAND3X1 U1410 ( .A(n1186), .B(n1200), .C(N41), .Y(n1199) );
  INVX1 U1411 ( .A(n1201), .Y(n1186) );
  AOI21X1 U1412 ( .A(n1202), .B(n1201), .C(n1197), .Y(next_out_rd_ptr[0]) );
  OAI21X1 U1413 ( .A(n1201), .B(n1202), .C(n1200), .Y(n1197) );
  INVX1 U1414 ( .A(ctrl_reg_clear[0]), .Y(n1200) );
  NAND3X1 U1415 ( .A(ahb_req), .B(n1193), .C(n1203), .Y(n1201) );
  AND2X1 U1416 ( .A(n1191), .B(n1204), .Y(n1203) );
  NOR2X1 U1417 ( .A(n1205), .B(n1172), .Y(next_occ_err) );
  NOR2X1 U1418 ( .A(n1206), .B(n1207), .Y(n1172) );
  NAND3X1 U1419 ( .A(n1190), .B(ahb_req), .C(haddr[5]), .Y(n1207) );
  NOR2X1 U1420 ( .A(n1208), .B(haddr[4]), .Y(n1190) );
  NAND3X1 U1421 ( .A(n1209), .B(n1193), .C(n1210), .Y(n1206) );
  INVX1 U1422 ( .A(haddr[6]), .Y(n1209) );
  INVX1 U1423 ( .A(n1211), .Y(n1205) );
  OAI21X1 U1424 ( .A(n1168), .B(n1212), .C(n1213), .Y(n1211) );
  AOI21X1 U1425 ( .A(n1214), .B(n1215), .C(occ_err), .Y(n1213) );
  NOR2X1 U1426 ( .A(n1216), .B(n1217), .Y(n1214) );
  INVX1 U1427 ( .A(n1167), .Y(n1212) );
  NOR2X1 U1428 ( .A(n1218), .B(n1149), .Y(n1167) );
  NAND3X1 U1429 ( .A(wt_wr_ptr[3]), .B(n1157), .C(wt_wr_ptr[4]), .Y(n1149) );
  INVX1 U1430 ( .A(n1219), .Y(n1157) );
  NAND3X1 U1431 ( .A(wt_wr_ptr[1]), .B(wt_wr_ptr[0]), .C(wt_wr_ptr[2]), .Y(
        n1219) );
  OR2X1 U1432 ( .A(n1220), .B(n1216), .Y(n1168) );
  MUX2X1 U1433 ( .B(n1148), .A(N207), .S(n1221), .Y(next_last_rd_region[1]) );
  INVX1 U1434 ( .A(last_rd_region[1]), .Y(n1148) );
  MUX2X1 U1435 ( .B(n1147), .A(n1222), .S(n1221), .Y(next_last_rd_region[0])
         );
  NOR2X1 U1436 ( .A(n1223), .B(n1224), .Y(n1221) );
  NAND2X1 U1437 ( .A(N207), .B(n1225), .Y(n1222) );
  INVX1 U1438 ( .A(last_rd_region[0]), .Y(n1147) );
  AND2X1 U1439 ( .A(n1226), .B(n1227), .Y(next_in_wr_ptr[2]) );
  OAI21X1 U1440 ( .A(n1228), .B(n1229), .C(n1230), .Y(n1226) );
  NOR2X1 U1441 ( .A(ctrl_reg_0), .B(n1231), .Y(next_in_wr_ptr[1]) );
  XOR2X1 U1442 ( .A(n1229), .B(N34), .Y(n1231) );
  AOI21X1 U1443 ( .A(n1232), .B(n1233), .C(n1234), .Y(next_in_wr_ptr[0]) );
  NAND2X1 U1444 ( .A(n1229), .B(n1227), .Y(n1234) );
  INVX1 U1445 ( .A(ctrl_reg_0), .Y(n1227) );
  NAND2X1 U1446 ( .A(n1235), .B(N33), .Y(n1229) );
  INVX1 U1447 ( .A(n1235), .Y(n1233) );
  NOR3X1 U1448 ( .A(n1216), .B(n1215), .C(n1217), .Y(n1235) );
  INVX1 U1449 ( .A(n1236), .Y(n1215) );
  NAND3X1 U1450 ( .A(N34), .B(N33), .C(N35), .Y(n1236) );
  NAND3X1 U1451 ( .A(hwrite), .B(ahb_req), .C(n1191), .Y(n1216) );
  NOR2X1 U1452 ( .A(n1237), .B(sram_state_out[0]), .Y(n1191) );
  INVX1 U1453 ( .A(n1238), .Y(n1662) );
  OAI22X1 U1454 ( .A(n1239), .B(n1240), .C(n1241), .D(n1242), .Y(n1731) );
  OAI22X1 U1455 ( .A(n1239), .B(n1243), .C(n1241), .D(n1244), .Y(n1732) );
  OAI22X1 U1456 ( .A(n1239), .B(n1245), .C(n1241), .D(n1246), .Y(n1733) );
  OAI22X1 U1457 ( .A(n1239), .B(n1247), .C(n1241), .D(n1248), .Y(n1734) );
  OAI22X1 U1458 ( .A(n1239), .B(n1249), .C(n1241), .D(n1250), .Y(n1735) );
  OAI22X1 U1459 ( .A(n1239), .B(n1251), .C(n1241), .D(n1252), .Y(n1736) );
  OAI22X1 U1460 ( .A(n1239), .B(n1253), .C(n1241), .D(n1254), .Y(n1737) );
  OAI22X1 U1461 ( .A(n1239), .B(n1255), .C(n1241), .D(n1256), .Y(n1738) );
  OAI22X1 U1462 ( .A(n1239), .B(n1257), .C(n1241), .D(n1258), .Y(n1739) );
  OAI22X1 U1463 ( .A(n1239), .B(n1259), .C(n1241), .D(n1260), .Y(n1740) );
  OAI22X1 U1464 ( .A(n1239), .B(n1261), .C(n1241), .D(n1262), .Y(n1741) );
  OAI22X1 U1465 ( .A(n1239), .B(n1263), .C(n1241), .D(n1264), .Y(n1742) );
  OAI22X1 U1466 ( .A(n1239), .B(n1265), .C(n1241), .D(n1266), .Y(n1743) );
  OAI22X1 U1467 ( .A(n1239), .B(n1267), .C(n1241), .D(n1268), .Y(n1744) );
  OAI22X1 U1468 ( .A(n1239), .B(n1269), .C(n1241), .D(n1270), .Y(n1745) );
  OAI22X1 U1469 ( .A(n1239), .B(n1271), .C(n1241), .D(n1272), .Y(n1746) );
  OAI22X1 U1470 ( .A(n1239), .B(n1273), .C(n1241), .D(n1274), .Y(n1747) );
  OAI22X1 U1471 ( .A(n1239), .B(n1275), .C(n1241), .D(n1276), .Y(n1748) );
  OAI22X1 U1472 ( .A(n1239), .B(n1277), .C(n1241), .D(n1278), .Y(n1749) );
  OAI22X1 U1473 ( .A(n1239), .B(n1279), .C(n1241), .D(n1280), .Y(n1750) );
  OAI22X1 U1474 ( .A(n1239), .B(n1281), .C(n1241), .D(n1282), .Y(n1751) );
  OAI22X1 U1475 ( .A(n1239), .B(n1283), .C(n1241), .D(n1284), .Y(n1752) );
  OAI22X1 U1476 ( .A(n1239), .B(n1285), .C(n1241), .D(n1286), .Y(n1753) );
  OAI22X1 U1477 ( .A(n1239), .B(n1287), .C(n1241), .D(n1288), .Y(n1754) );
  OAI22X1 U1478 ( .A(n1239), .B(n1289), .C(n1241), .D(n1290), .Y(n1755) );
  OAI22X1 U1479 ( .A(n1239), .B(n1291), .C(n1241), .D(n1292), .Y(n1756) );
  OAI22X1 U1480 ( .A(n1239), .B(n1293), .C(n1241), .D(n1294), .Y(n1757) );
  OAI22X1 U1481 ( .A(n1239), .B(n1295), .C(n1241), .D(n1296), .Y(n1758) );
  OAI22X1 U1482 ( .A(n1239), .B(n1297), .C(n1241), .D(n1298), .Y(n1759) );
  OAI22X1 U1483 ( .A(n1239), .B(n1299), .C(n1241), .D(n1300), .Y(n1760) );
  OAI22X1 U1484 ( .A(n1239), .B(n1301), .C(n1241), .D(n1302), .Y(n1761) );
  OAI22X1 U1485 ( .A(n1239), .B(n1303), .C(n1241), .D(n1304), .Y(n1762) );
  OAI22X1 U1486 ( .A(n1239), .B(n1305), .C(n1241), .D(n1306), .Y(n1763) );
  OAI22X1 U1487 ( .A(n1239), .B(n1307), .C(n1241), .D(n1308), .Y(n1764) );
  OAI22X1 U1488 ( .A(n1239), .B(n1309), .C(n1241), .D(n1310), .Y(n1765) );
  OAI22X1 U1489 ( .A(n1239), .B(n1311), .C(n1241), .D(n1312), .Y(n1766) );
  OAI22X1 U1490 ( .A(n1239), .B(n1313), .C(n1241), .D(n1314), .Y(n1767) );
  OAI22X1 U1491 ( .A(n1239), .B(n1315), .C(n1241), .D(n1316), .Y(n1768) );
  OAI22X1 U1492 ( .A(n1239), .B(n1317), .C(n1241), .D(n1318), .Y(n1769) );
  OAI22X1 U1493 ( .A(n1239), .B(n1319), .C(n1241), .D(n1320), .Y(n1770) );
  OAI22X1 U1494 ( .A(n1239), .B(n1321), .C(n1241), .D(n1322), .Y(n1771) );
  OAI22X1 U1495 ( .A(n1239), .B(n1323), .C(n1241), .D(n1324), .Y(n1772) );
  OAI22X1 U1496 ( .A(n1239), .B(n1325), .C(n1241), .D(n1326), .Y(n1773) );
  OAI22X1 U1497 ( .A(n1239), .B(n1327), .C(n1241), .D(n1328), .Y(n1774) );
  OAI22X1 U1498 ( .A(n1239), .B(n1329), .C(n1241), .D(n1330), .Y(n1775) );
  OAI22X1 U1499 ( .A(n1239), .B(n1331), .C(n1241), .D(n1332), .Y(n1776) );
  OAI22X1 U1500 ( .A(n1239), .B(n1333), .C(n1241), .D(n1334), .Y(n1777) );
  OAI22X1 U1501 ( .A(n1239), .B(n1335), .C(n1241), .D(n1336), .Y(n1778) );
  OAI22X1 U1502 ( .A(n1239), .B(n1337), .C(n1241), .D(n1338), .Y(n1779) );
  OAI22X1 U1503 ( .A(n1239), .B(n1339), .C(n1241), .D(n1340), .Y(n1780) );
  OAI22X1 U1504 ( .A(n1239), .B(n1341), .C(n1241), .D(n1342), .Y(n1781) );
  OAI22X1 U1505 ( .A(n1239), .B(n1343), .C(n1241), .D(n1344), .Y(n1782) );
  OAI22X1 U1506 ( .A(n1239), .B(n1345), .C(n1241), .D(n1346), .Y(n1783) );
  OAI22X1 U1507 ( .A(n1239), .B(n1347), .C(n1241), .D(n1348), .Y(n1784) );
  OAI22X1 U1508 ( .A(n1239), .B(n1349), .C(n1241), .D(n1350), .Y(n1785) );
  OAI22X1 U1509 ( .A(n1239), .B(n1351), .C(n1241), .D(n1352), .Y(n1786) );
  OAI22X1 U1510 ( .A(n1239), .B(n1353), .C(n1241), .D(n1354), .Y(n1787) );
  OAI22X1 U1511 ( .A(n1239), .B(n1355), .C(n1241), .D(n1356), .Y(n1788) );
  OAI22X1 U1512 ( .A(n1239), .B(n1357), .C(n1241), .D(n1358), .Y(n1789) );
  OAI22X1 U1513 ( .A(n1239), .B(n1359), .C(n1241), .D(n1360), .Y(n1790) );
  OAI22X1 U1514 ( .A(n1239), .B(n1361), .C(n1241), .D(n1362), .Y(n1791) );
  OAI22X1 U1515 ( .A(n1239), .B(n1363), .C(n1241), .D(n1364), .Y(n1792) );
  OAI22X1 U1516 ( .A(n1239), .B(n1365), .C(n1241), .D(n1366), .Y(n1793) );
  OAI22X1 U1517 ( .A(n1239), .B(n1367), .C(n1241), .D(n1368), .Y(n1794) );
  INVX1 U1518 ( .A(n1369), .Y(n1795) );
  INVX1 U1519 ( .A(n1370), .Y(n1796) );
  INVX1 U1520 ( .A(sram_addr[9]), .Y(n1798) );
  INVX1 U1521 ( .A(sram_addr[8]), .Y(n1799) );
  OAI21X1 U1522 ( .A(n1371), .B(n1016), .C(n1372), .Y(n999) );
  MUX2X1 U1523 ( .B(hold_addr[0]), .A(n1730), .S(n1018), .Y(n1372) );
  INVX1 U1524 ( .A(n1373), .Y(n1730) );
  OAI21X1 U1525 ( .A(sram_addr[0]), .B(n1224), .C(n1374), .Y(n1373) );
  AOI21X1 U1526 ( .A(n1017), .B(n1375), .C(n1015), .Y(n1374) );
  OAI21X1 U1527 ( .A(n1376), .B(n1016), .C(n1377), .Y(n997) );
  MUX2X1 U1528 ( .B(hold_addr[1]), .A(n1729), .S(n1018), .Y(n1377) );
  INVX1 U1529 ( .A(n1378), .Y(n1729) );
  OAI21X1 U1530 ( .A(sram_addr[1]), .B(n1224), .C(n1379), .Y(n1378) );
  AOI21X1 U1531 ( .A(n1017), .B(n1380), .C(n1015), .Y(n1379) );
  OAI21X1 U1532 ( .A(n1381), .B(n1016), .C(n1382), .Y(n995) );
  MUX2X1 U1533 ( .B(hold_addr[2]), .A(n1728), .S(n1018), .Y(n1382) );
  INVX1 U1534 ( .A(n1383), .Y(n1728) );
  OAI21X1 U1535 ( .A(sram_addr[2]), .B(n1224), .C(n1384), .Y(n1383) );
  AOI21X1 U1536 ( .A(n1017), .B(n1385), .C(n1015), .Y(n1384) );
  OAI21X1 U1537 ( .A(n1386), .B(n1016), .C(n1387), .Y(n993) );
  MUX2X1 U1538 ( .B(hold_addr[3]), .A(n1727), .S(n1018), .Y(n1387) );
  INVX1 U1539 ( .A(n1388), .Y(n1727) );
  OAI21X1 U1540 ( .A(sram_addr[3]), .B(n1224), .C(n1389), .Y(n1388) );
  AOI21X1 U1541 ( .A(n1017), .B(n1390), .C(n1015), .Y(n1389) );
  INVX1 U1542 ( .A(n1391), .Y(n1386) );
  OAI21X1 U1543 ( .A(n1368), .B(n1016), .C(n1392), .Y(n991) );
  MUX2X1 U1544 ( .B(hold_wdata[63]), .A(n1726), .S(n1018), .Y(n1392) );
  INVX1 U1545 ( .A(n1393), .Y(n1726) );
  OAI21X1 U1546 ( .A(sram_wr_data[63]), .B(n1224), .C(n1394), .Y(n1393) );
  AOI21X1 U1547 ( .A(n1017), .B(n1367), .C(n1015), .Y(n1394) );
  INVX1 U1548 ( .A(hold_wdata[63]), .Y(n1367) );
  INVX1 U1549 ( .A(hwdata[63]), .Y(n1368) );
  OAI21X1 U1550 ( .A(n1366), .B(n1016), .C(n1395), .Y(n989) );
  MUX2X1 U1551 ( .B(hold_wdata[62]), .A(n1725), .S(n1018), .Y(n1395) );
  INVX1 U1552 ( .A(n1396), .Y(n1725) );
  OAI21X1 U1553 ( .A(sram_wr_data[62]), .B(n1224), .C(n1397), .Y(n1396) );
  AOI21X1 U1554 ( .A(n1017), .B(n1365), .C(n1015), .Y(n1397) );
  INVX1 U1555 ( .A(hold_wdata[62]), .Y(n1365) );
  INVX1 U1556 ( .A(hwdata[62]), .Y(n1366) );
  OAI21X1 U1557 ( .A(n1364), .B(n1016), .C(n1398), .Y(n987) );
  MUX2X1 U1558 ( .B(hold_wdata[61]), .A(n1724), .S(n1018), .Y(n1398) );
  INVX1 U1559 ( .A(n1399), .Y(n1724) );
  OAI21X1 U1560 ( .A(sram_wr_data[61]), .B(n1224), .C(n1400), .Y(n1399) );
  AOI21X1 U1561 ( .A(n1017), .B(n1363), .C(n1015), .Y(n1400) );
  INVX1 U1562 ( .A(hold_wdata[61]), .Y(n1363) );
  INVX1 U1563 ( .A(hwdata[61]), .Y(n1364) );
  OAI21X1 U1564 ( .A(n1362), .B(n1016), .C(n1401), .Y(n985) );
  MUX2X1 U1565 ( .B(hold_wdata[60]), .A(n1723), .S(n1018), .Y(n1401) );
  INVX1 U1566 ( .A(n1402), .Y(n1723) );
  OAI21X1 U1567 ( .A(sram_wr_data[60]), .B(n1224), .C(n1403), .Y(n1402) );
  AOI21X1 U1568 ( .A(n1017), .B(n1361), .C(n1015), .Y(n1403) );
  INVX1 U1569 ( .A(hold_wdata[60]), .Y(n1361) );
  INVX1 U1570 ( .A(hwdata[60]), .Y(n1362) );
  OAI21X1 U1571 ( .A(n1360), .B(n1016), .C(n1404), .Y(n983) );
  MUX2X1 U1572 ( .B(hold_wdata[59]), .A(n1722), .S(n1018), .Y(n1404) );
  INVX1 U1573 ( .A(n1405), .Y(n1722) );
  OAI21X1 U1574 ( .A(sram_wr_data[59]), .B(n1224), .C(n1406), .Y(n1405) );
  AOI21X1 U1575 ( .A(n1017), .B(n1359), .C(n1015), .Y(n1406) );
  INVX1 U1576 ( .A(hold_wdata[59]), .Y(n1359) );
  INVX1 U1577 ( .A(hwdata[59]), .Y(n1360) );
  OAI21X1 U1578 ( .A(n1358), .B(n1016), .C(n1407), .Y(n981) );
  MUX2X1 U1579 ( .B(hold_wdata[58]), .A(n1721), .S(n1018), .Y(n1407) );
  INVX1 U1580 ( .A(n1408), .Y(n1721) );
  OAI21X1 U1581 ( .A(sram_wr_data[58]), .B(n1224), .C(n1409), .Y(n1408) );
  AOI21X1 U1582 ( .A(n1017), .B(n1357), .C(n1015), .Y(n1409) );
  INVX1 U1583 ( .A(hold_wdata[58]), .Y(n1357) );
  INVX1 U1584 ( .A(hwdata[58]), .Y(n1358) );
  OAI21X1 U1585 ( .A(n1356), .B(n1016), .C(n1410), .Y(n979) );
  MUX2X1 U1586 ( .B(hold_wdata[57]), .A(n1720), .S(n1018), .Y(n1410) );
  INVX1 U1587 ( .A(n1411), .Y(n1720) );
  OAI21X1 U1588 ( .A(sram_wr_data[57]), .B(n1224), .C(n1412), .Y(n1411) );
  AOI21X1 U1589 ( .A(n1017), .B(n1355), .C(n1015), .Y(n1412) );
  INVX1 U1590 ( .A(hold_wdata[57]), .Y(n1355) );
  INVX1 U1591 ( .A(hwdata[57]), .Y(n1356) );
  OAI21X1 U1592 ( .A(n1354), .B(n1016), .C(n1413), .Y(n977) );
  MUX2X1 U1593 ( .B(hold_wdata[56]), .A(n1719), .S(n1018), .Y(n1413) );
  INVX1 U1594 ( .A(n1414), .Y(n1719) );
  OAI21X1 U1595 ( .A(sram_wr_data[56]), .B(n1224), .C(n1415), .Y(n1414) );
  AOI21X1 U1596 ( .A(n1017), .B(n1353), .C(n1015), .Y(n1415) );
  INVX1 U1597 ( .A(hold_wdata[56]), .Y(n1353) );
  INVX1 U1598 ( .A(hwdata[56]), .Y(n1354) );
  OAI21X1 U1599 ( .A(n1352), .B(n1016), .C(n1416), .Y(n975) );
  MUX2X1 U1600 ( .B(hold_wdata[55]), .A(n1718), .S(n1018), .Y(n1416) );
  INVX1 U1601 ( .A(n1417), .Y(n1718) );
  OAI21X1 U1602 ( .A(sram_wr_data[55]), .B(n1224), .C(n1418), .Y(n1417) );
  AOI21X1 U1603 ( .A(n1017), .B(n1351), .C(n1015), .Y(n1418) );
  INVX1 U1604 ( .A(hold_wdata[55]), .Y(n1351) );
  INVX1 U1605 ( .A(hwdata[55]), .Y(n1352) );
  OAI21X1 U1606 ( .A(n1350), .B(n1016), .C(n1419), .Y(n973) );
  MUX2X1 U1607 ( .B(hold_wdata[54]), .A(n1717), .S(n1018), .Y(n1419) );
  INVX1 U1608 ( .A(n1420), .Y(n1717) );
  OAI21X1 U1609 ( .A(sram_wr_data[54]), .B(n1224), .C(n1421), .Y(n1420) );
  AOI21X1 U1610 ( .A(n1017), .B(n1349), .C(n1015), .Y(n1421) );
  INVX1 U1611 ( .A(hold_wdata[54]), .Y(n1349) );
  INVX1 U1612 ( .A(hwdata[54]), .Y(n1350) );
  OAI21X1 U1613 ( .A(n1348), .B(n1016), .C(n1422), .Y(n971) );
  MUX2X1 U1614 ( .B(hold_wdata[53]), .A(n1716), .S(n1018), .Y(n1422) );
  INVX1 U1615 ( .A(n1423), .Y(n1716) );
  OAI21X1 U1616 ( .A(sram_wr_data[53]), .B(n1224), .C(n1424), .Y(n1423) );
  AOI21X1 U1617 ( .A(n1017), .B(n1347), .C(n1015), .Y(n1424) );
  INVX1 U1618 ( .A(hold_wdata[53]), .Y(n1347) );
  INVX1 U1619 ( .A(hwdata[53]), .Y(n1348) );
  OAI21X1 U1620 ( .A(n1346), .B(n1016), .C(n1425), .Y(n969) );
  MUX2X1 U1621 ( .B(hold_wdata[52]), .A(n1715), .S(n1018), .Y(n1425) );
  INVX1 U1622 ( .A(n1426), .Y(n1715) );
  OAI21X1 U1623 ( .A(sram_wr_data[52]), .B(n1224), .C(n1427), .Y(n1426) );
  AOI21X1 U1624 ( .A(n1017), .B(n1345), .C(n1015), .Y(n1427) );
  INVX1 U1625 ( .A(hold_wdata[52]), .Y(n1345) );
  INVX1 U1626 ( .A(hwdata[52]), .Y(n1346) );
  OAI21X1 U1627 ( .A(n1344), .B(n1016), .C(n1428), .Y(n967) );
  MUX2X1 U1628 ( .B(hold_wdata[51]), .A(n1714), .S(n1018), .Y(n1428) );
  INVX1 U1629 ( .A(n1429), .Y(n1714) );
  OAI21X1 U1630 ( .A(sram_wr_data[51]), .B(n1224), .C(n1430), .Y(n1429) );
  AOI21X1 U1631 ( .A(n1017), .B(n1343), .C(n1015), .Y(n1430) );
  INVX1 U1632 ( .A(hold_wdata[51]), .Y(n1343) );
  INVX1 U1633 ( .A(hwdata[51]), .Y(n1344) );
  OAI21X1 U1634 ( .A(n1342), .B(n1016), .C(n1431), .Y(n965) );
  MUX2X1 U1635 ( .B(hold_wdata[50]), .A(n1713), .S(n1018), .Y(n1431) );
  INVX1 U1636 ( .A(n1432), .Y(n1713) );
  OAI21X1 U1637 ( .A(sram_wr_data[50]), .B(n1224), .C(n1433), .Y(n1432) );
  AOI21X1 U1638 ( .A(n1017), .B(n1341), .C(n1015), .Y(n1433) );
  INVX1 U1639 ( .A(hold_wdata[50]), .Y(n1341) );
  INVX1 U1640 ( .A(hwdata[50]), .Y(n1342) );
  OAI21X1 U1641 ( .A(n1340), .B(n1016), .C(n1434), .Y(n963) );
  MUX2X1 U1642 ( .B(hold_wdata[49]), .A(n1712), .S(n1018), .Y(n1434) );
  INVX1 U1643 ( .A(n1435), .Y(n1712) );
  OAI21X1 U1644 ( .A(sram_wr_data[49]), .B(n1224), .C(n1436), .Y(n1435) );
  AOI21X1 U1645 ( .A(n1017), .B(n1339), .C(n1015), .Y(n1436) );
  INVX1 U1646 ( .A(hold_wdata[49]), .Y(n1339) );
  INVX1 U1647 ( .A(hwdata[49]), .Y(n1340) );
  OAI21X1 U1648 ( .A(n1338), .B(n1016), .C(n1437), .Y(n961) );
  MUX2X1 U1649 ( .B(hold_wdata[48]), .A(n1711), .S(n1018), .Y(n1437) );
  INVX1 U1650 ( .A(n1438), .Y(n1711) );
  OAI21X1 U1651 ( .A(sram_wr_data[48]), .B(n1224), .C(n1439), .Y(n1438) );
  AOI21X1 U1652 ( .A(n1017), .B(n1337), .C(n1015), .Y(n1439) );
  INVX1 U1653 ( .A(hold_wdata[48]), .Y(n1337) );
  INVX1 U1654 ( .A(hwdata[48]), .Y(n1338) );
  OAI21X1 U1655 ( .A(n1336), .B(n1016), .C(n1440), .Y(n959) );
  MUX2X1 U1656 ( .B(hold_wdata[47]), .A(n1710), .S(n1018), .Y(n1440) );
  INVX1 U1657 ( .A(n1441), .Y(n1710) );
  OAI21X1 U1658 ( .A(sram_wr_data[47]), .B(n1224), .C(n1442), .Y(n1441) );
  AOI21X1 U1659 ( .A(n1017), .B(n1335), .C(n1015), .Y(n1442) );
  INVX1 U1660 ( .A(hold_wdata[47]), .Y(n1335) );
  INVX1 U1661 ( .A(hwdata[47]), .Y(n1336) );
  OAI21X1 U1662 ( .A(n1334), .B(n1016), .C(n1443), .Y(n957) );
  MUX2X1 U1663 ( .B(hold_wdata[46]), .A(n1709), .S(n1018), .Y(n1443) );
  INVX1 U1664 ( .A(n1444), .Y(n1709) );
  OAI21X1 U1665 ( .A(sram_wr_data[46]), .B(n1224), .C(n1445), .Y(n1444) );
  AOI21X1 U1666 ( .A(n1017), .B(n1333), .C(n1015), .Y(n1445) );
  INVX1 U1667 ( .A(hold_wdata[46]), .Y(n1333) );
  INVX1 U1668 ( .A(hwdata[46]), .Y(n1334) );
  OAI21X1 U1669 ( .A(n1332), .B(n1016), .C(n1446), .Y(n955) );
  MUX2X1 U1670 ( .B(hold_wdata[45]), .A(n1708), .S(n1018), .Y(n1446) );
  INVX1 U1671 ( .A(n1447), .Y(n1708) );
  OAI21X1 U1672 ( .A(sram_wr_data[45]), .B(n1224), .C(n1448), .Y(n1447) );
  AOI21X1 U1673 ( .A(n1017), .B(n1331), .C(n1015), .Y(n1448) );
  INVX1 U1674 ( .A(hold_wdata[45]), .Y(n1331) );
  INVX1 U1675 ( .A(hwdata[45]), .Y(n1332) );
  OAI21X1 U1676 ( .A(n1330), .B(n1016), .C(n1449), .Y(n953) );
  MUX2X1 U1677 ( .B(hold_wdata[44]), .A(n1707), .S(n1018), .Y(n1449) );
  INVX1 U1678 ( .A(n1450), .Y(n1707) );
  OAI21X1 U1679 ( .A(sram_wr_data[44]), .B(n1224), .C(n1451), .Y(n1450) );
  AOI21X1 U1680 ( .A(n1017), .B(n1329), .C(n1015), .Y(n1451) );
  INVX1 U1681 ( .A(hold_wdata[44]), .Y(n1329) );
  INVX1 U1682 ( .A(hwdata[44]), .Y(n1330) );
  OAI21X1 U1683 ( .A(n1328), .B(n1016), .C(n1452), .Y(n951) );
  MUX2X1 U1684 ( .B(hold_wdata[43]), .A(n1706), .S(n1018), .Y(n1452) );
  INVX1 U1685 ( .A(n1453), .Y(n1706) );
  OAI21X1 U1686 ( .A(sram_wr_data[43]), .B(n1224), .C(n1454), .Y(n1453) );
  AOI21X1 U1687 ( .A(n1017), .B(n1327), .C(n1015), .Y(n1454) );
  INVX1 U1688 ( .A(hold_wdata[43]), .Y(n1327) );
  INVX1 U1689 ( .A(hwdata[43]), .Y(n1328) );
  OAI21X1 U1690 ( .A(n1326), .B(n1016), .C(n1455), .Y(n949) );
  MUX2X1 U1691 ( .B(hold_wdata[42]), .A(n1705), .S(n1018), .Y(n1455) );
  INVX1 U1692 ( .A(n1456), .Y(n1705) );
  OAI21X1 U1693 ( .A(sram_wr_data[42]), .B(n1224), .C(n1457), .Y(n1456) );
  AOI21X1 U1694 ( .A(n1017), .B(n1325), .C(n1015), .Y(n1457) );
  INVX1 U1695 ( .A(hold_wdata[42]), .Y(n1325) );
  INVX1 U1696 ( .A(hwdata[42]), .Y(n1326) );
  OAI21X1 U1697 ( .A(n1324), .B(n1016), .C(n1458), .Y(n947) );
  MUX2X1 U1698 ( .B(hold_wdata[41]), .A(n1704), .S(n1018), .Y(n1458) );
  INVX1 U1699 ( .A(n1459), .Y(n1704) );
  OAI21X1 U1700 ( .A(sram_wr_data[41]), .B(n1224), .C(n1460), .Y(n1459) );
  AOI21X1 U1701 ( .A(n1017), .B(n1323), .C(n1015), .Y(n1460) );
  INVX1 U1702 ( .A(hold_wdata[41]), .Y(n1323) );
  INVX1 U1703 ( .A(hwdata[41]), .Y(n1324) );
  OAI21X1 U1704 ( .A(n1322), .B(n1016), .C(n1461), .Y(n945) );
  MUX2X1 U1705 ( .B(hold_wdata[40]), .A(n1703), .S(n1018), .Y(n1461) );
  INVX1 U1706 ( .A(n1462), .Y(n1703) );
  OAI21X1 U1707 ( .A(sram_wr_data[40]), .B(n1224), .C(n1463), .Y(n1462) );
  AOI21X1 U1708 ( .A(n1017), .B(n1321), .C(n1015), .Y(n1463) );
  INVX1 U1709 ( .A(hold_wdata[40]), .Y(n1321) );
  INVX1 U1710 ( .A(hwdata[40]), .Y(n1322) );
  OAI21X1 U1711 ( .A(n1320), .B(n1016), .C(n1464), .Y(n943) );
  MUX2X1 U1712 ( .B(hold_wdata[39]), .A(n1702), .S(n1018), .Y(n1464) );
  INVX1 U1713 ( .A(n1465), .Y(n1702) );
  OAI21X1 U1714 ( .A(sram_wr_data[39]), .B(n1224), .C(n1466), .Y(n1465) );
  AOI21X1 U1715 ( .A(n1017), .B(n1319), .C(n1015), .Y(n1466) );
  INVX1 U1716 ( .A(hold_wdata[39]), .Y(n1319) );
  INVX1 U1717 ( .A(hwdata[39]), .Y(n1320) );
  OAI21X1 U1718 ( .A(n1318), .B(n1016), .C(n1467), .Y(n941) );
  MUX2X1 U1719 ( .B(hold_wdata[38]), .A(n1701), .S(n1018), .Y(n1467) );
  INVX1 U1720 ( .A(n1468), .Y(n1701) );
  OAI21X1 U1721 ( .A(sram_wr_data[38]), .B(n1224), .C(n1469), .Y(n1468) );
  AOI21X1 U1722 ( .A(n1017), .B(n1317), .C(n1015), .Y(n1469) );
  INVX1 U1723 ( .A(hold_wdata[38]), .Y(n1317) );
  INVX1 U1724 ( .A(hwdata[38]), .Y(n1318) );
  OAI21X1 U1725 ( .A(n1316), .B(n1016), .C(n1470), .Y(n939) );
  MUX2X1 U1726 ( .B(hold_wdata[37]), .A(n1700), .S(n1018), .Y(n1470) );
  INVX1 U1727 ( .A(n1471), .Y(n1700) );
  OAI21X1 U1728 ( .A(sram_wr_data[37]), .B(n1224), .C(n1472), .Y(n1471) );
  AOI21X1 U1729 ( .A(n1017), .B(n1315), .C(n1015), .Y(n1472) );
  INVX1 U1730 ( .A(hold_wdata[37]), .Y(n1315) );
  INVX1 U1731 ( .A(hwdata[37]), .Y(n1316) );
  OAI21X1 U1732 ( .A(n1314), .B(n1016), .C(n1473), .Y(n937) );
  MUX2X1 U1733 ( .B(hold_wdata[36]), .A(n1699), .S(n1018), .Y(n1473) );
  INVX1 U1734 ( .A(n1474), .Y(n1699) );
  OAI21X1 U1735 ( .A(sram_wr_data[36]), .B(n1224), .C(n1475), .Y(n1474) );
  AOI21X1 U1736 ( .A(n1017), .B(n1313), .C(n1015), .Y(n1475) );
  INVX1 U1737 ( .A(hold_wdata[36]), .Y(n1313) );
  INVX1 U1738 ( .A(hwdata[36]), .Y(n1314) );
  OAI21X1 U1739 ( .A(n1312), .B(n1016), .C(n1476), .Y(n935) );
  MUX2X1 U1740 ( .B(hold_wdata[35]), .A(n1698), .S(n1018), .Y(n1476) );
  INVX1 U1741 ( .A(n1477), .Y(n1698) );
  OAI21X1 U1742 ( .A(sram_wr_data[35]), .B(n1224), .C(n1478), .Y(n1477) );
  AOI21X1 U1743 ( .A(n1017), .B(n1311), .C(n1015), .Y(n1478) );
  INVX1 U1744 ( .A(hold_wdata[35]), .Y(n1311) );
  INVX1 U1745 ( .A(hwdata[35]), .Y(n1312) );
  OAI21X1 U1746 ( .A(n1310), .B(n1016), .C(n1479), .Y(n933) );
  MUX2X1 U1747 ( .B(hold_wdata[34]), .A(n1697), .S(n1018), .Y(n1479) );
  INVX1 U1748 ( .A(n1480), .Y(n1697) );
  OAI21X1 U1749 ( .A(sram_wr_data[34]), .B(n1224), .C(n1481), .Y(n1480) );
  AOI21X1 U1750 ( .A(n1017), .B(n1309), .C(n1015), .Y(n1481) );
  INVX1 U1751 ( .A(hold_wdata[34]), .Y(n1309) );
  INVX1 U1752 ( .A(hwdata[34]), .Y(n1310) );
  OAI21X1 U1753 ( .A(n1308), .B(n1016), .C(n1482), .Y(n931) );
  MUX2X1 U1754 ( .B(hold_wdata[33]), .A(n1696), .S(n1018), .Y(n1482) );
  INVX1 U1755 ( .A(n1483), .Y(n1696) );
  OAI21X1 U1756 ( .A(sram_wr_data[33]), .B(n1224), .C(n1484), .Y(n1483) );
  AOI21X1 U1757 ( .A(n1017), .B(n1307), .C(n1015), .Y(n1484) );
  INVX1 U1758 ( .A(hold_wdata[33]), .Y(n1307) );
  INVX1 U1759 ( .A(hwdata[33]), .Y(n1308) );
  OAI21X1 U1760 ( .A(n1306), .B(n1016), .C(n1485), .Y(n929) );
  MUX2X1 U1761 ( .B(hold_wdata[32]), .A(n1695), .S(n1018), .Y(n1485) );
  INVX1 U1762 ( .A(n1486), .Y(n1695) );
  OAI21X1 U1763 ( .A(sram_wr_data[32]), .B(n1224), .C(n1487), .Y(n1486) );
  AOI21X1 U1764 ( .A(n1017), .B(n1305), .C(n1015), .Y(n1487) );
  INVX1 U1765 ( .A(hold_wdata[32]), .Y(n1305) );
  INVX1 U1766 ( .A(hwdata[32]), .Y(n1306) );
  OAI21X1 U1767 ( .A(n1304), .B(n1016), .C(n1488), .Y(n927) );
  MUX2X1 U1768 ( .B(hold_wdata[31]), .A(n1694), .S(n1018), .Y(n1488) );
  INVX1 U1769 ( .A(n1489), .Y(n1694) );
  OAI21X1 U1770 ( .A(sram_wr_data[31]), .B(n1224), .C(n1490), .Y(n1489) );
  AOI21X1 U1771 ( .A(n1017), .B(n1303), .C(n1015), .Y(n1490) );
  INVX1 U1772 ( .A(hold_wdata[31]), .Y(n1303) );
  INVX1 U1773 ( .A(hwdata[31]), .Y(n1304) );
  OAI21X1 U1774 ( .A(n1302), .B(n1016), .C(n1491), .Y(n925) );
  MUX2X1 U1775 ( .B(hold_wdata[30]), .A(n1693), .S(n1018), .Y(n1491) );
  INVX1 U1776 ( .A(n1492), .Y(n1693) );
  OAI21X1 U1777 ( .A(sram_wr_data[30]), .B(n1224), .C(n1493), .Y(n1492) );
  AOI21X1 U1778 ( .A(n1017), .B(n1301), .C(n1015), .Y(n1493) );
  INVX1 U1779 ( .A(hold_wdata[30]), .Y(n1301) );
  INVX1 U1780 ( .A(hwdata[30]), .Y(n1302) );
  OAI21X1 U1781 ( .A(n1300), .B(n1016), .C(n1494), .Y(n923) );
  MUX2X1 U1782 ( .B(hold_wdata[29]), .A(n1692), .S(n1018), .Y(n1494) );
  INVX1 U1783 ( .A(n1495), .Y(n1692) );
  OAI21X1 U1784 ( .A(sram_wr_data[29]), .B(n1224), .C(n1496), .Y(n1495) );
  AOI21X1 U1785 ( .A(n1017), .B(n1299), .C(n1015), .Y(n1496) );
  INVX1 U1786 ( .A(hold_wdata[29]), .Y(n1299) );
  INVX1 U1787 ( .A(hwdata[29]), .Y(n1300) );
  OAI21X1 U1788 ( .A(n1298), .B(n1016), .C(n1497), .Y(n921) );
  MUX2X1 U1789 ( .B(hold_wdata[28]), .A(n1691), .S(n1018), .Y(n1497) );
  INVX1 U1790 ( .A(n1498), .Y(n1691) );
  OAI21X1 U1791 ( .A(sram_wr_data[28]), .B(n1224), .C(n1499), .Y(n1498) );
  AOI21X1 U1792 ( .A(n1017), .B(n1297), .C(n1015), .Y(n1499) );
  INVX1 U1793 ( .A(hold_wdata[28]), .Y(n1297) );
  INVX1 U1794 ( .A(hwdata[28]), .Y(n1298) );
  OAI21X1 U1795 ( .A(n1296), .B(n1016), .C(n1500), .Y(n919) );
  MUX2X1 U1796 ( .B(hold_wdata[27]), .A(n1690), .S(n1018), .Y(n1500) );
  INVX1 U1797 ( .A(n1501), .Y(n1690) );
  OAI21X1 U1798 ( .A(sram_wr_data[27]), .B(n1224), .C(n1502), .Y(n1501) );
  AOI21X1 U1799 ( .A(n1017), .B(n1295), .C(n1015), .Y(n1502) );
  INVX1 U1800 ( .A(hold_wdata[27]), .Y(n1295) );
  INVX1 U1801 ( .A(hwdata[27]), .Y(n1296) );
  OAI21X1 U1802 ( .A(n1294), .B(n1016), .C(n1503), .Y(n917) );
  MUX2X1 U1803 ( .B(hold_wdata[26]), .A(n1689), .S(n1018), .Y(n1503) );
  INVX1 U1804 ( .A(n1504), .Y(n1689) );
  OAI21X1 U1805 ( .A(sram_wr_data[26]), .B(n1224), .C(n1505), .Y(n1504) );
  AOI21X1 U1806 ( .A(n1017), .B(n1293), .C(n1015), .Y(n1505) );
  INVX1 U1807 ( .A(hold_wdata[26]), .Y(n1293) );
  INVX1 U1808 ( .A(hwdata[26]), .Y(n1294) );
  OAI21X1 U1809 ( .A(n1292), .B(n1016), .C(n1506), .Y(n915) );
  MUX2X1 U1810 ( .B(hold_wdata[25]), .A(n1688), .S(n1018), .Y(n1506) );
  INVX1 U1811 ( .A(n1507), .Y(n1688) );
  OAI21X1 U1812 ( .A(sram_wr_data[25]), .B(n1224), .C(n1508), .Y(n1507) );
  AOI21X1 U1813 ( .A(n1017), .B(n1291), .C(n1015), .Y(n1508) );
  INVX1 U1814 ( .A(hold_wdata[25]), .Y(n1291) );
  INVX1 U1815 ( .A(hwdata[25]), .Y(n1292) );
  OAI21X1 U1816 ( .A(n1290), .B(n1016), .C(n1509), .Y(n913) );
  MUX2X1 U1817 ( .B(hold_wdata[24]), .A(n1687), .S(n1018), .Y(n1509) );
  INVX1 U1818 ( .A(n1510), .Y(n1687) );
  OAI21X1 U1819 ( .A(sram_wr_data[24]), .B(n1224), .C(n1511), .Y(n1510) );
  AOI21X1 U1820 ( .A(n1017), .B(n1289), .C(n1015), .Y(n1511) );
  INVX1 U1821 ( .A(hold_wdata[24]), .Y(n1289) );
  INVX1 U1822 ( .A(hwdata[24]), .Y(n1290) );
  OAI21X1 U1823 ( .A(n1288), .B(n1016), .C(n1512), .Y(n911) );
  MUX2X1 U1824 ( .B(hold_wdata[23]), .A(n1686), .S(n1018), .Y(n1512) );
  INVX1 U1825 ( .A(n1513), .Y(n1686) );
  OAI21X1 U1826 ( .A(sram_wr_data[23]), .B(n1224), .C(n1514), .Y(n1513) );
  AOI21X1 U1827 ( .A(n1017), .B(n1287), .C(n1015), .Y(n1514) );
  INVX1 U1828 ( .A(hold_wdata[23]), .Y(n1287) );
  INVX1 U1829 ( .A(hwdata[23]), .Y(n1288) );
  OAI21X1 U1830 ( .A(n1286), .B(n1016), .C(n1515), .Y(n909) );
  MUX2X1 U1831 ( .B(hold_wdata[22]), .A(n1685), .S(n1018), .Y(n1515) );
  INVX1 U1832 ( .A(n1516), .Y(n1685) );
  OAI21X1 U1833 ( .A(sram_wr_data[22]), .B(n1224), .C(n1517), .Y(n1516) );
  AOI21X1 U1834 ( .A(n1017), .B(n1285), .C(n1015), .Y(n1517) );
  INVX1 U1835 ( .A(hold_wdata[22]), .Y(n1285) );
  INVX1 U1836 ( .A(hwdata[22]), .Y(n1286) );
  OAI21X1 U1837 ( .A(n1284), .B(n1016), .C(n1518), .Y(n907) );
  MUX2X1 U1838 ( .B(hold_wdata[21]), .A(n1684), .S(n1018), .Y(n1518) );
  INVX1 U1839 ( .A(n1519), .Y(n1684) );
  OAI21X1 U1840 ( .A(sram_wr_data[21]), .B(n1224), .C(n1520), .Y(n1519) );
  AOI21X1 U1841 ( .A(n1017), .B(n1283), .C(n1015), .Y(n1520) );
  INVX1 U1842 ( .A(hold_wdata[21]), .Y(n1283) );
  INVX1 U1843 ( .A(hwdata[21]), .Y(n1284) );
  OAI21X1 U1844 ( .A(n1282), .B(n1016), .C(n1521), .Y(n905) );
  MUX2X1 U1845 ( .B(hold_wdata[20]), .A(n1683), .S(n1018), .Y(n1521) );
  INVX1 U1846 ( .A(n1522), .Y(n1683) );
  OAI21X1 U1847 ( .A(sram_wr_data[20]), .B(n1224), .C(n1523), .Y(n1522) );
  AOI21X1 U1848 ( .A(n1017), .B(n1281), .C(n1015), .Y(n1523) );
  INVX1 U1849 ( .A(hold_wdata[20]), .Y(n1281) );
  INVX1 U1850 ( .A(hwdata[20]), .Y(n1282) );
  OAI21X1 U1851 ( .A(n1280), .B(n1016), .C(n1524), .Y(n903) );
  MUX2X1 U1852 ( .B(hold_wdata[19]), .A(n1682), .S(n1018), .Y(n1524) );
  INVX1 U1853 ( .A(n1525), .Y(n1682) );
  OAI21X1 U1854 ( .A(sram_wr_data[19]), .B(n1224), .C(n1526), .Y(n1525) );
  AOI21X1 U1855 ( .A(n1017), .B(n1279), .C(n1015), .Y(n1526) );
  INVX1 U1856 ( .A(hold_wdata[19]), .Y(n1279) );
  INVX1 U1857 ( .A(hwdata[19]), .Y(n1280) );
  OAI21X1 U1858 ( .A(n1278), .B(n1016), .C(n1527), .Y(n901) );
  MUX2X1 U1859 ( .B(hold_wdata[18]), .A(n1681), .S(n1018), .Y(n1527) );
  INVX1 U1860 ( .A(n1528), .Y(n1681) );
  OAI21X1 U1861 ( .A(sram_wr_data[18]), .B(n1224), .C(n1529), .Y(n1528) );
  AOI21X1 U1862 ( .A(n1017), .B(n1277), .C(n1015), .Y(n1529) );
  INVX1 U1863 ( .A(hold_wdata[18]), .Y(n1277) );
  INVX1 U1864 ( .A(hwdata[18]), .Y(n1278) );
  OAI21X1 U1865 ( .A(n1276), .B(n1016), .C(n1530), .Y(n899) );
  MUX2X1 U1866 ( .B(hold_wdata[17]), .A(n1680), .S(n1018), .Y(n1530) );
  INVX1 U1867 ( .A(n1531), .Y(n1680) );
  OAI21X1 U1868 ( .A(sram_wr_data[17]), .B(n1224), .C(n1532), .Y(n1531) );
  AOI21X1 U1869 ( .A(n1017), .B(n1275), .C(n1015), .Y(n1532) );
  INVX1 U1870 ( .A(hold_wdata[17]), .Y(n1275) );
  INVX1 U1871 ( .A(hwdata[17]), .Y(n1276) );
  OAI21X1 U1872 ( .A(n1274), .B(n1016), .C(n1533), .Y(n897) );
  MUX2X1 U1873 ( .B(hold_wdata[16]), .A(n1679), .S(n1018), .Y(n1533) );
  INVX1 U1874 ( .A(n1534), .Y(n1679) );
  OAI21X1 U1875 ( .A(sram_wr_data[16]), .B(n1224), .C(n1535), .Y(n1534) );
  AOI21X1 U1876 ( .A(n1017), .B(n1273), .C(n1015), .Y(n1535) );
  INVX1 U1877 ( .A(hold_wdata[16]), .Y(n1273) );
  INVX1 U1878 ( .A(hwdata[16]), .Y(n1274) );
  OAI21X1 U1879 ( .A(n1272), .B(n1016), .C(n1536), .Y(n895) );
  MUX2X1 U1880 ( .B(hold_wdata[15]), .A(n1678), .S(n1018), .Y(n1536) );
  INVX1 U1881 ( .A(n1537), .Y(n1678) );
  OAI21X1 U1882 ( .A(sram_wr_data[15]), .B(n1224), .C(n1538), .Y(n1537) );
  AOI21X1 U1883 ( .A(n1017), .B(n1271), .C(n1015), .Y(n1538) );
  INVX1 U1884 ( .A(hold_wdata[15]), .Y(n1271) );
  INVX1 U1885 ( .A(hwdata[15]), .Y(n1272) );
  OAI21X1 U1886 ( .A(n1270), .B(n1016), .C(n1539), .Y(n893) );
  MUX2X1 U1887 ( .B(hold_wdata[14]), .A(n1677), .S(n1018), .Y(n1539) );
  INVX1 U1888 ( .A(n1540), .Y(n1677) );
  OAI21X1 U1889 ( .A(sram_wr_data[14]), .B(n1224), .C(n1541), .Y(n1540) );
  AOI21X1 U1890 ( .A(n1017), .B(n1269), .C(n1015), .Y(n1541) );
  INVX1 U1891 ( .A(hold_wdata[14]), .Y(n1269) );
  INVX1 U1892 ( .A(hwdata[14]), .Y(n1270) );
  OAI21X1 U1893 ( .A(n1268), .B(n1016), .C(n1542), .Y(n891) );
  MUX2X1 U1894 ( .B(hold_wdata[13]), .A(n1676), .S(n1018), .Y(n1542) );
  INVX1 U1895 ( .A(n1543), .Y(n1676) );
  OAI21X1 U1896 ( .A(sram_wr_data[13]), .B(n1224), .C(n1544), .Y(n1543) );
  AOI21X1 U1897 ( .A(n1017), .B(n1267), .C(n1015), .Y(n1544) );
  INVX1 U1898 ( .A(hold_wdata[13]), .Y(n1267) );
  INVX1 U1899 ( .A(hwdata[13]), .Y(n1268) );
  OAI21X1 U1900 ( .A(n1266), .B(n1016), .C(n1545), .Y(n889) );
  MUX2X1 U1901 ( .B(hold_wdata[12]), .A(n1675), .S(n1018), .Y(n1545) );
  INVX1 U1902 ( .A(n1546), .Y(n1675) );
  OAI21X1 U1903 ( .A(sram_wr_data[12]), .B(n1224), .C(n1547), .Y(n1546) );
  AOI21X1 U1904 ( .A(n1017), .B(n1265), .C(n1015), .Y(n1547) );
  INVX1 U1905 ( .A(hold_wdata[12]), .Y(n1265) );
  INVX1 U1906 ( .A(hwdata[12]), .Y(n1266) );
  OAI21X1 U1907 ( .A(n1264), .B(n1016), .C(n1548), .Y(n887) );
  MUX2X1 U1908 ( .B(hold_wdata[11]), .A(n1674), .S(n1018), .Y(n1548) );
  INVX1 U1909 ( .A(n1549), .Y(n1674) );
  OAI21X1 U1910 ( .A(sram_wr_data[11]), .B(n1224), .C(n1550), .Y(n1549) );
  AOI21X1 U1911 ( .A(n1017), .B(n1263), .C(n1015), .Y(n1550) );
  INVX1 U1912 ( .A(hold_wdata[11]), .Y(n1263) );
  INVX1 U1913 ( .A(hwdata[11]), .Y(n1264) );
  OAI21X1 U1914 ( .A(n1262), .B(n1016), .C(n1551), .Y(n885) );
  MUX2X1 U1915 ( .B(hold_wdata[10]), .A(n1673), .S(n1018), .Y(n1551) );
  INVX1 U1916 ( .A(n1552), .Y(n1673) );
  OAI21X1 U1917 ( .A(sram_wr_data[10]), .B(n1224), .C(n1553), .Y(n1552) );
  AOI21X1 U1918 ( .A(n1017), .B(n1261), .C(n1015), .Y(n1553) );
  INVX1 U1919 ( .A(hold_wdata[10]), .Y(n1261) );
  INVX1 U1920 ( .A(hwdata[10]), .Y(n1262) );
  OAI21X1 U1921 ( .A(n1260), .B(n1016), .C(n1554), .Y(n883) );
  MUX2X1 U1922 ( .B(hold_wdata[9]), .A(n1672), .S(n1018), .Y(n1554) );
  INVX1 U1923 ( .A(n1555), .Y(n1672) );
  OAI21X1 U1924 ( .A(sram_wr_data[9]), .B(n1224), .C(n1556), .Y(n1555) );
  AOI21X1 U1925 ( .A(n1017), .B(n1259), .C(n1015), .Y(n1556) );
  INVX1 U1926 ( .A(hold_wdata[9]), .Y(n1259) );
  INVX1 U1927 ( .A(hwdata[9]), .Y(n1260) );
  OAI21X1 U1928 ( .A(n1258), .B(n1016), .C(n1557), .Y(n881) );
  MUX2X1 U1929 ( .B(hold_wdata[8]), .A(n1671), .S(n1018), .Y(n1557) );
  INVX1 U1930 ( .A(n1558), .Y(n1671) );
  OAI21X1 U1931 ( .A(sram_wr_data[8]), .B(n1224), .C(n1559), .Y(n1558) );
  AOI21X1 U1932 ( .A(n1017), .B(n1257), .C(n1015), .Y(n1559) );
  INVX1 U1933 ( .A(hold_wdata[8]), .Y(n1257) );
  INVX1 U1934 ( .A(hwdata[8]), .Y(n1258) );
  OAI21X1 U1935 ( .A(n1256), .B(n1016), .C(n1560), .Y(n879) );
  MUX2X1 U1936 ( .B(hold_wdata[7]), .A(n1670), .S(n1018), .Y(n1560) );
  INVX1 U1937 ( .A(n1561), .Y(n1670) );
  OAI21X1 U1938 ( .A(sram_wr_data[7]), .B(n1224), .C(n1562), .Y(n1561) );
  AOI21X1 U1939 ( .A(n1017), .B(n1255), .C(n1015), .Y(n1562) );
  INVX1 U1940 ( .A(hold_wdata[7]), .Y(n1255) );
  INVX1 U1941 ( .A(hwdata[7]), .Y(n1256) );
  OAI21X1 U1942 ( .A(n1254), .B(n1016), .C(n1563), .Y(n877) );
  MUX2X1 U1943 ( .B(hold_wdata[6]), .A(n1669), .S(n1018), .Y(n1563) );
  INVX1 U1944 ( .A(n1564), .Y(n1669) );
  OAI21X1 U1945 ( .A(sram_wr_data[6]), .B(n1224), .C(n1565), .Y(n1564) );
  AOI21X1 U1946 ( .A(n1017), .B(n1253), .C(n1015), .Y(n1565) );
  INVX1 U1947 ( .A(hold_wdata[6]), .Y(n1253) );
  INVX1 U1948 ( .A(hwdata[6]), .Y(n1254) );
  OAI21X1 U1949 ( .A(n1252), .B(n1016), .C(n1566), .Y(n875) );
  MUX2X1 U1950 ( .B(hold_wdata[5]), .A(n1668), .S(n1018), .Y(n1566) );
  INVX1 U1951 ( .A(n1567), .Y(n1668) );
  OAI21X1 U1952 ( .A(sram_wr_data[5]), .B(n1224), .C(n1568), .Y(n1567) );
  AOI21X1 U1953 ( .A(n1017), .B(n1251), .C(n1015), .Y(n1568) );
  INVX1 U1954 ( .A(hold_wdata[5]), .Y(n1251) );
  INVX1 U1955 ( .A(hwdata[5]), .Y(n1252) );
  OAI21X1 U1956 ( .A(n1250), .B(n1016), .C(n1569), .Y(n873) );
  MUX2X1 U1957 ( .B(hold_wdata[4]), .A(n1667), .S(n1018), .Y(n1569) );
  INVX1 U1958 ( .A(n1570), .Y(n1667) );
  OAI21X1 U1959 ( .A(sram_wr_data[4]), .B(n1224), .C(n1571), .Y(n1570) );
  AOI21X1 U1960 ( .A(n1017), .B(n1249), .C(n1015), .Y(n1571) );
  INVX1 U1961 ( .A(hold_wdata[4]), .Y(n1249) );
  INVX1 U1962 ( .A(hwdata[4]), .Y(n1250) );
  OAI21X1 U1963 ( .A(n1248), .B(n1016), .C(n1572), .Y(n871) );
  MUX2X1 U1964 ( .B(hold_wdata[3]), .A(n1666), .S(n1018), .Y(n1572) );
  INVX1 U1965 ( .A(n1573), .Y(n1666) );
  OAI21X1 U1966 ( .A(sram_wr_data[3]), .B(n1224), .C(n1574), .Y(n1573) );
  AOI21X1 U1967 ( .A(n1017), .B(n1247), .C(n1015), .Y(n1574) );
  INVX1 U1968 ( .A(hold_wdata[3]), .Y(n1247) );
  INVX1 U1969 ( .A(hwdata[3]), .Y(n1248) );
  OAI21X1 U1970 ( .A(n1246), .B(n1016), .C(n1575), .Y(n869) );
  MUX2X1 U1971 ( .B(hold_wdata[2]), .A(n1665), .S(n1018), .Y(n1575) );
  INVX1 U1972 ( .A(n1576), .Y(n1665) );
  OAI21X1 U1973 ( .A(sram_wr_data[2]), .B(n1224), .C(n1577), .Y(n1576) );
  AOI21X1 U1974 ( .A(n1017), .B(n1245), .C(n1015), .Y(n1577) );
  INVX1 U1975 ( .A(hold_wdata[2]), .Y(n1245) );
  INVX1 U1976 ( .A(hwdata[2]), .Y(n1246) );
  OAI21X1 U1977 ( .A(n1244), .B(n1016), .C(n1578), .Y(n867) );
  MUX2X1 U1978 ( .B(hold_wdata[1]), .A(n1664), .S(n1018), .Y(n1578) );
  INVX1 U1979 ( .A(n1579), .Y(n1664) );
  OAI21X1 U1980 ( .A(sram_wr_data[1]), .B(n1224), .C(n1580), .Y(n1579) );
  AOI21X1 U1981 ( .A(n1017), .B(n1243), .C(n1015), .Y(n1580) );
  INVX1 U1982 ( .A(hold_wdata[1]), .Y(n1243) );
  INVX1 U1983 ( .A(hwdata[1]), .Y(n1244) );
  OAI21X1 U1984 ( .A(n1242), .B(n1016), .C(n1581), .Y(n865) );
  MUX2X1 U1985 ( .B(hold_wdata[0]), .A(n1663), .S(n1018), .Y(n1581) );
  INVX1 U1986 ( .A(n1582), .Y(n1663) );
  OAI21X1 U1987 ( .A(sram_wr_data[0]), .B(n1224), .C(n1583), .Y(n1582) );
  AOI21X1 U1988 ( .A(n1017), .B(n1240), .C(n1015), .Y(n1583) );
  INVX1 U1989 ( .A(hold_wdata[0]), .Y(n1240) );
  INVX1 U1990 ( .A(hwdata[0]), .Y(n1242) );
  MUX2X1 U1991 ( .B(n1584), .A(n1585), .S(n1018), .Y(n845) );
  NAND2X1 U1992 ( .A(sram_addr[9]), .B(n1369), .Y(n1585) );
  MUX2X1 U1993 ( .B(n1586), .A(n1587), .S(n1018), .Y(n843) );
  NAND2X1 U1994 ( .A(sram_addr[8]), .B(n1370), .Y(n1587) );
  MUX2X1 U1995 ( .B(n1588), .A(n1238), .S(n1018), .Y(n841) );
  OAI21X1 U1996 ( .A(sram_addr[7]), .B(n1224), .C(n1589), .Y(n1238) );
  AOI21X1 U1997 ( .A(n1017), .B(n1588), .C(n1015), .Y(n1589) );
  OAI21X1 U1998 ( .A(n1590), .B(n1016), .C(n1591), .Y(n839) );
  MUX2X1 U1999 ( .B(hold_addr[6]), .A(n1661), .S(n1018), .Y(n1591) );
  INVX1 U2000 ( .A(n1592), .Y(n1661) );
  OAI21X1 U2001 ( .A(sram_addr[6]), .B(n1224), .C(n1593), .Y(n1592) );
  AOI21X1 U2002 ( .A(n1017), .B(n1594), .C(n1015), .Y(n1593) );
  INVX1 U2003 ( .A(n1595), .Y(n1590) );
  OAI21X1 U2004 ( .A(n1596), .B(n1016), .C(n1597), .Y(n837) );
  MUX2X1 U2005 ( .B(hold_addr[5]), .A(n1660), .S(n1018), .Y(n1597) );
  INVX1 U2006 ( .A(n1598), .Y(n1660) );
  OAI21X1 U2007 ( .A(sram_addr[5]), .B(n1224), .C(n1599), .Y(n1598) );
  AOI21X1 U2008 ( .A(n1017), .B(n1600), .C(n1015), .Y(n1599) );
  INVX1 U2009 ( .A(n1601), .Y(n1596) );
  OAI21X1 U2010 ( .A(n1602), .B(n1016), .C(n1603), .Y(n835) );
  MUX2X1 U2011 ( .B(hold_addr[4]), .A(n1659), .S(n1018), .Y(n1603) );
  INVX1 U2012 ( .A(n1604), .Y(n1659) );
  OAI21X1 U2013 ( .A(sram_addr[4]), .B(n1224), .C(n1605), .Y(n1604) );
  AOI21X1 U2014 ( .A(n1017), .B(n1606), .C(n1015), .Y(n1605) );
  INVX1 U2015 ( .A(n1607), .Y(n1602) );
  NOR2X1 U2016 ( .A(n1608), .B(n1371), .Y(n831) );
  NOR2X1 U2017 ( .A(n1609), .B(n1610), .Y(n1371) );
  OAI22X1 U2018 ( .A(n1220), .B(n1611), .C(n1232), .D(n1217), .Y(n1610) );
  INVX1 U2019 ( .A(N33), .Y(n1232) );
  INVX1 U2020 ( .A(wt_wr_ptr[0]), .Y(n1611) );
  OAI21X1 U2021 ( .A(n1612), .B(n1202), .C(n1613), .Y(n1609) );
  INVX1 U2022 ( .A(N41), .Y(n1202) );
  INVX1 U2023 ( .A(n1614), .Y(n1608) );
  OAI21X1 U2024 ( .A(n1615), .B(n1375), .C(n1241), .Y(n1614) );
  INVX1 U2025 ( .A(hold_addr[0]), .Y(n1375) );
  NOR2X1 U2026 ( .A(n1616), .B(n1376), .Y(n829) );
  NOR2X1 U2027 ( .A(n1617), .B(n1618), .Y(n1376) );
  OAI22X1 U2028 ( .A(n1220), .B(n1163), .C(n1228), .D(n1217), .Y(n1618) );
  INVX1 U2029 ( .A(N34), .Y(n1228) );
  INVX1 U2030 ( .A(wt_wr_ptr[1]), .Y(n1163) );
  OAI21X1 U2031 ( .A(n1612), .B(n1198), .C(n1613), .Y(n1617) );
  INVX1 U2032 ( .A(N42), .Y(n1198) );
  INVX1 U2033 ( .A(n1619), .Y(n1616) );
  OAI21X1 U2034 ( .A(n1615), .B(n1380), .C(n1241), .Y(n1619) );
  INVX1 U2035 ( .A(hold_addr[1]), .Y(n1380) );
  NOR2X1 U2036 ( .A(n1620), .B(n1381), .Y(n827) );
  NOR2X1 U2037 ( .A(n1621), .B(n1622), .Y(n1381) );
  OAI22X1 U2038 ( .A(n1220), .B(n1623), .C(n1230), .D(n1217), .Y(n1622) );
  INVX1 U2039 ( .A(N35), .Y(n1230) );
  INVX1 U2040 ( .A(wt_wr_ptr[2]), .Y(n1623) );
  OAI21X1 U2041 ( .A(n1612), .B(n1624), .C(n1613), .Y(n1621) );
  INVX1 U2042 ( .A(N43), .Y(n1624) );
  INVX1 U2043 ( .A(n1625), .Y(n1620) );
  OAI21X1 U2044 ( .A(n1615), .B(n1385), .C(n1241), .Y(n1625) );
  INVX1 U2045 ( .A(hold_addr[2]), .Y(n1385) );
  AND2X1 U2046 ( .A(n1626), .B(n1391), .Y(n825) );
  OAI21X1 U2047 ( .A(n1220), .B(n1627), .C(n1628), .Y(n1391) );
  NOR2X1 U2048 ( .A(n1224), .B(n1204), .Y(n1628) );
  INVX1 U2049 ( .A(n1612), .Y(n1204) );
  INVX1 U2050 ( .A(wt_wr_ptr[3]), .Y(n1627) );
  OAI21X1 U2051 ( .A(n1615), .B(n1390), .C(n1241), .Y(n1626) );
  INVX1 U2052 ( .A(hold_addr[3]), .Y(n1390) );
  AOI22X1 U2053 ( .A(n1224), .B(n1369), .C(hold_addr[9]), .D(hready_stall), 
        .Y(n693) );
  OAI21X1 U2054 ( .A(n1015), .B(n1584), .C(n1017), .Y(n1369) );
  INVX1 U2055 ( .A(hold_addr[9]), .Y(n1584) );
  AOI22X1 U2056 ( .A(n1224), .B(n1370), .C(hold_addr[8]), .D(hready_stall), 
        .Y(n690) );
  OAI21X1 U2057 ( .A(n1015), .B(n1586), .C(n1017), .Y(n1370) );
  INVX1 U2058 ( .A(hold_addr[8]), .Y(n1586) );
  NOR2X1 U2059 ( .A(n1239), .B(n1588), .Y(n689) );
  INVX1 U2060 ( .A(hold_addr[7]), .Y(n1588) );
  AND2X1 U2061 ( .A(n1629), .B(n1595), .Y(n687) );
  NAND3X1 U2062 ( .A(n1612), .B(n1613), .C(n1217), .Y(n1595) );
  NAND3X1 U2063 ( .A(n1630), .B(n1631), .C(haddr[3]), .Y(n1217) );
  NAND3X1 U2064 ( .A(haddr[3]), .B(n1630), .C(haddr[4]), .Y(n1612) );
  OAI21X1 U2065 ( .A(n1615), .B(n1594), .C(n1241), .Y(n1629) );
  INVX1 U2066 ( .A(hold_addr[6]), .Y(n1594) );
  AND2X1 U2067 ( .A(n1632), .B(n1601), .Y(n685) );
  OAI21X1 U2068 ( .A(n1220), .B(n1218), .C(n1613), .Y(n1601) );
  INVX1 U2069 ( .A(wt_wr_ptr[5]), .Y(n1218) );
  OAI21X1 U2070 ( .A(n1615), .B(n1600), .C(n1241), .Y(n1632) );
  INVX1 U2071 ( .A(hold_addr[5]), .Y(n1600) );
  AND2X1 U2072 ( .A(n1633), .B(n1607), .Y(n683) );
  OAI21X1 U2073 ( .A(n1220), .B(n1634), .C(n1613), .Y(n1607) );
  INVX1 U2074 ( .A(wt_wr_ptr[4]), .Y(n1634) );
  NAND3X1 U2075 ( .A(n1210), .B(n1631), .C(n1630), .Y(n1220) );
  NOR3X1 U2076 ( .A(haddr[5]), .B(haddr[6]), .C(n1208), .Y(n1630) );
  NAND3X1 U2077 ( .A(n1635), .B(n1636), .C(n1637), .Y(n1208) );
  NOR2X1 U2078 ( .A(haddr[7]), .B(n1638), .Y(n1637) );
  OR2X1 U2079 ( .A(haddr[9]), .B(haddr[8]), .Y(n1638) );
  INVX1 U2080 ( .A(haddr[0]), .Y(n1636) );
  NOR2X1 U2081 ( .A(haddr[2]), .B(haddr[1]), .Y(n1635) );
  INVX1 U2082 ( .A(haddr[4]), .Y(n1631) );
  INVX1 U2083 ( .A(haddr[3]), .Y(n1210) );
  OAI21X1 U2084 ( .A(n1615), .B(n1606), .C(n1241), .Y(n1633) );
  INVX1 U2085 ( .A(hold_addr[4]), .Y(n1606) );
  OAI21X1 U2086 ( .A(n1193), .B(n1016), .C(n1640), .Y(n1003) );
  MUX2X1 U2087 ( .B(hold_we), .A(sram_wr_en), .S(n1018), .Y(n1640) );
  OAI21X1 U2088 ( .A(hwrite), .B(n1016), .C(n1641), .Y(n1001) );
  MUX2X1 U2089 ( .B(hold_re), .A(sram_rd_en), .S(n1018), .Y(n1641) );
  AND2X1 U2090 ( .A(sram_we), .B(n1225), .Y(N388) );
  OAI21X1 U2091 ( .A(n1224), .B(n1642), .C(n1643), .Y(sram_we) );
  AOI22X1 U2092 ( .A(hold_we), .B(n1644), .C(hwrite), .D(n1639), .Y(n1643) );
  OAI21X1 U2093 ( .A(n1613), .B(n1645), .C(n1646), .Y(n1644) );
  NOR2X1 U2094 ( .A(sram_wr_en), .B(hready_stall), .Y(n1646) );
  NOR2X1 U2095 ( .A(n1223), .B(n1797), .Y(N380) );
  INVX1 U2096 ( .A(n1225), .Y(n1797) );
  NAND2X1 U2097 ( .A(n1647), .B(n1648), .Y(n1225) );
  INVX1 U2098 ( .A(sram_re), .Y(n1223) );
  OAI21X1 U2099 ( .A(n1224), .B(n1645), .C(n1649), .Y(sram_re) );
  AOI22X1 U2100 ( .A(hold_re), .B(n1650), .C(n1639), .D(n1193), .Y(n1649) );
  INVX1 U2101 ( .A(hwrite), .Y(n1193) );
  NOR2X1 U2102 ( .A(n1615), .B(n1224), .Y(n1639) );
  OAI21X1 U2103 ( .A(n1613), .B(n1642), .C(n1651), .Y(n1650) );
  NOR2X1 U2104 ( .A(sram_rd_en), .B(hready_stall), .Y(n1651) );
  NOR2X1 U2105 ( .A(n1615), .B(n1613), .Y(hready_stall) );
  NAND2X1 U2106 ( .A(ahb_req), .B(n1015), .Y(n1615) );
  INVX1 U2107 ( .A(sram_wr_en), .Y(n1642) );
  INVX1 U2108 ( .A(sram_rd_en), .Y(n1645) );
  NAND2X1 U2109 ( .A(sram_state_out[0]), .B(n1237), .Y(n1613) );
  INVX1 U2110 ( .A(sram_state_out[1]), .Y(n1237) );
  INVX1 U2111 ( .A(N290), .Y(N207) );
  OAI21X1 U2112 ( .A(n1652), .B(n1648), .C(n1647), .Y(N290) );
  NOR2X1 U2113 ( .A(sram_address[7]), .B(n1653), .Y(n1647) );
  OR2X1 U2114 ( .A(sram_address[9]), .B(sram_address[8]), .Y(n1653) );
  INVX1 U2115 ( .A(sram_address[6]), .Y(n1648) );
  NOR2X1 U2116 ( .A(sram_address[3]), .B(n1654), .Y(n1652) );
  OR2X1 U2117 ( .A(sram_address[5]), .B(sram_address[4]), .Y(n1654) );
endmodule

