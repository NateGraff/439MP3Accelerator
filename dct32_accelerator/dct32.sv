`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nathaniel Graff
// 
// Create Date: 10/26/2017 09:24:26 AM
// Module Name: dct32
// Project Name: Hardware-Accelerated MP3 Player
//////////////////////////////////////////////////////////////////////////////////

typedef int mad_fixed_t;

`define costab1 'h0ffb10f2
`define costab2 'h0fec46d2
`define costab3 'h0fd3aac0
`define costab4 'h0fb14be8
`define costab5 'h0f853f7e
`define costab6 'h0f4fa0ab
`define costab7 'h0f109082
`define costab8 'h0ec835e8
`define costab9 'h0e76bd7a
`define costab10 'h0e1c5979
`define costab11 'h0db941a3
`define costab12 'h0d4db315
`define costab13 'h0cd9f024
`define costab14 'h0c5e4036
`define costab15 'h0bdaef91
`define costab16 'h0b504f33
`define costab17 'h0abeb49a
`define costab18 'h0a267993
`define costab19 'h0987fbfe
`define costab20 'h08e39d9d
`define costab21 'h0839c3cd
`define costab22 'h078ad74e
`define costab23 'h06d74402
`define costab24 'h061f78aa
`define costab25 'h0563e69d
`define costab26 'h04a5018c
`define costab27 'h03e33f2f
`define costab28 'h031f1708
`define costab29 'h0259020e
`define costab30 'h01917a6c
`define costab31 'h00c8fb30

`define SHIFT(x)  (((``x``) + (1 << 11)) >> 12)

module dct32(clk, in, lo, hi);
    input clk;
    input mad_fixed_t in[31:0];
    output mad_fixed_t lo[15:0];
    output mad_fixed_t hi[15:0];
    
    mad_fixed_t t[176:0];
    
    always @(posedge clk) begin
        t[0]  = in[0] + in[31];
        t[16] = (in[0] - in[31]) * `costab1;
        t[1]  = in[15] + in[16];
        t[17] = (in[15] - in[16]) * `costab31;

        t[41]  = t[16] + t[17];
        t[59]  = (t[16] - t[17]) * `costab2;
        t[33]  = t[0]  + t[1];
        t[50]  = (t[0]  - t[1]) * `costab2;

        t[2]   = in[7]  + in[24];
        t[18]  = (in[7]  - in[24]) * `costab15;
        t[3]   = in[8]  + in[23];
        t[19]  = (in[8]  - in[23]) * `costab17;

        t[42]  = t[18] + t[19];
        t[60]  = (t[18] - t[19]) * `costab30;
        t[34]  = t[2]  + t[3];
        t[51]  = (t[2]  - t[3]) *  `costab30;

        t[4]   = in[3]  + in[28];
        t[20]  = (in[3]  - in[28]) * `costab7;
        t[5]   = in[12] + in[19];
        t[21]  = (in[12] - in[19]) * `costab25;

        t[43]  = t[20] + t[21];
        t[61]  = (t[20] - t[21]) * `costab14;
        t[35]  = t[4]  + t[5];
        t[52]  = (t[4]  - t[5]) *  `costab14;

        t[6]   = in[4]  + in[27];
        t[22]  = (in[4]  - in[27]) * `costab9;
        t[7]   = in[11] + in[20];
        t[23]  = (in[11] - in[20]) * `costab23;

        t[44]  = t[22] + t[23];
        t[62]  = (t[22] - t[23]) * `costab18;
        t[36]  = t[6]  + t[7];
        t[53]  = (t[6]  - t[7]) *  `costab18;

        t[8]   = in[1]  + in[30];
        t[24]  = (in[1]  - in[30]) * `costab3;
        t[9]   = in[14] + in[17];
        t[25]  = (in[14] - in[17]) * `costab29;

        t[45]  = t[24] + t[25];
        t[63]  = (t[24] - t[25]) * `costab6;
        t[37]  = t[8]  + t[9];
        t[54]  = (t[8]  - t[9]) *  `costab6;

        t[10]  = in[6]  + in[25];
        t[26]  = (in[6]  - in[25]) * `costab13;
        t[11]  = in[9]  + in[22];
        t[27]  = (in[9]  - in[22]) * `costab19;

        t[46]  = t[26] + t[27];
        t[64]  = (t[26] - t[27]) * `costab26;
        t[38]  = t[10] + t[11];
        t[55]  = (t[10] - t[11]) * `costab26;

        t[12]  = in[2]  + in[29];
        t[28]  = (in[2]  - in[29]) * `costab5;
        t[13]  = in[13] + in[18];
        t[29]  = (in[13] - in[18]) * `costab27;

        t[47]  = t[28] + t[29];
        t[65]  = (t[28] - t[29]) * `costab10;
        t[39]  = t[12] + t[13];
        t[56]  = (t[12] - t[13]) * `costab10;

        t[14]  = in[5]  + in[26];
        t[30]  = (in[5]  - in[26]) * `costab11;
        t[15]  = in[10] + in[21];
        t[31]  = (in[10] - in[21]) * `costab21;

        t[48]  = t[30] + t[31];
        t[66]  = (t[30] - t[31]) * `costab22;
        t[40]  = t[14] + t[15];
        t[57]  = (t[14] - t[15]) * `costab22;

        t[69]  = t[33] + t[34];
        t[89]  = (t[33] - t[34]) * `costab4;
        t[70]  = t[35] + t[36];
        t[90]  = (t[35] - t[36]) * `costab28;
        t[71]  = t[37] + t[38];
        t[91]  = (t[37] - t[38]) * `costab12;
        t[72]  = t[39] + t[40];
        t[92]  = (t[39] - t[40]) * `costab20;
        t[73]  = t[41] + t[42];
        t[94]  = (t[41] - t[42]) * `costab4;
        t[74]  = t[43] + t[44];
        t[95]  = (t[43] - t[44]) * `costab28;
        t[75]  = t[45] + t[46];
        t[96]  = (t[45] - t[46]) * `costab12;
        t[76]  = t[47] + t[48];
        t[97]  = (t[47] - t[48]) * `costab20;

        t[78]  = t[50] + t[51];
        t[100] = (t[50] - t[51]) * `costab4;
        t[79]  = t[52] + t[53];
        t[101] = (t[52] - t[53]) * `costab28;
        t[80]  = t[54] + t[55];
        t[102] = (t[54] - t[55]) * `costab12;
        t[81]  = t[56] + t[57];
        t[103] = (t[56] - t[57]) * `costab20;

        t[83]  = t[59] + t[60];
        t[106] = (t[59] - t[60]) * `costab4;
        t[84]  = t[61] + t[62];
        t[107] = (t[61] - t[62]) * `costab28;
        t[85]  = t[63] + t[64];
        t[108] = (t[63] - t[64]) * `costab12;
        t[86]  = t[65] + t[66];
        t[109] = (t[65] - t[66]) * `costab20;

        t[113] = t[69]  + t[70];
        t[114] = t[71]  + t[72];

        /*  0 */ hi[15] = `SHIFT(t[113] + t[114]);
        /* 16 */ lo[ 0] = `SHIFT((t[113] - t[114]) * `costab16);

        t[115] = t[73]  + t[74];
        t[116] = t[75]  + t[76];

        t[32]  = t[115] + t[116];

        /*  1 */ hi[14] = `SHIFT(t[32]);

        t[118] = t[78]  + t[79];
        t[119] = t[80]  + t[81];

        t[58]  = t[118] + t[119];

        /*  2 */ hi[13] = `SHIFT(t[58]);

        t[121] = t[83]  + t[84];
        t[122] = t[85]  + t[86];

        t[67]  = t[121] + t[122];

        t[49]  = (t[67] * 2) - t[32];

        /*  3 */ hi[12] = `SHIFT(t[49]);

        t[125] = t[89]  + t[90];
        t[126] = t[91]  + t[92];

        t[93]  = t[125] + t[126];

        /*  4 */ hi[11] = `SHIFT(t[93]);

        t[128] = t[94]  + t[95];
        t[129] = t[96]  + t[97];

        t[98]  = t[128] + t[129];

        t[68]  = (t[98] * 2) - t[49];

        /*  5 */ hi[10] = `SHIFT(t[68]);

        t[132] = t[100] + t[101];
        t[133] = t[102] + t[103];

        t[104] = t[132] + t[133];

        t[82]  = (t[104] * 2) - t[58];

        /*  6 */ hi[ 9] = `SHIFT(t[82]);

        t[136] = t[106] + t[107];
        t[137] = t[108] + t[109];

        t[110] = t[136] + t[137];

        t[87]  = (t[110] * 2) - t[67];

        t[77]  = (t[87] * 2) - t[68];

        /*  7 */ hi[ 8] = `SHIFT(t[77]);

        t[141] = (t[69] - t[70]) * `costab8;
        t[142] = (t[71] - t[72]) * `costab24;
        t[143] = t[141] + t[142];

        /*  8 */ hi[ 7] = `SHIFT(t[143]);
        /* 24 */ lo[ 8] = `SHIFT(((t[141] - t[142]) * `costab16 * 2) - t[143]);

        t[144] = (t[73] - t[74]) * `costab8;
        t[145] = (t[75] - t[76]) * `costab24;
        t[146] = t[144] + t[145];

        t[88]  = (t[146] * 2) - t[77];

        /*  9 */ hi[ 6] = `SHIFT(t[88]);

        t[148] = (t[78] - t[79]) * `costab8;
        t[149] = (t[80] - t[81]) * `costab24;
        t[150] = t[148] + t[149];

        t[105] = (t[150] * 2) - t[82];

        /* 10 */ hi[ 5] = `SHIFT(t[105]);

        t[152] = (t[83] - t[84]) * `costab8;
        t[153] = (t[85] - t[86]) * `costab24;
        t[154] = t[152] + t[153];

        t[111] = (t[154] * 2) - t[87];

        t[99]  = (t[111] * 2) - t[88];

        /* 11 */ hi[ 4] = `SHIFT(t[99]);

        t[157] = (t[89] - t[90]) * `costab8;
        t[158] = (t[91] - t[92]) * `costab24;
        t[159] = t[157] + t[158];

        t[127] = (t[159] * 2) - t[93];

        /* 12 */ hi[ 3] = `SHIFT(t[127]);

        t[160] = ((t[125] - t[126]) * `costab16 * 2) - t[127];

        /* 20 */ lo[ 4] = `SHIFT(t[160]);
        /* 28 */ lo[12] = `SHIFT(((((t[157] - t[158]) * `costab16 * 2) - t[159]) * 2) - t[160]);

        t[161] = (t[94] - t[95]) * `costab8;
        t[162] = (t[96] - t[97]) * `costab24;
        t[163] = t[161] + t[162];

        t[130] = (t[163] * 2) - t[98];

        t[112] = (t[130] * 2) - t[99];

        /* 13 */ hi[ 2] = `SHIFT(t[112]);

        t[164] = ((t[128] - t[129]) * `costab16 * 2) - t[130];

        t[166] = (t[100] - t[101]) * `costab8;
        t[167] = (t[102] - t[103]) * `costab24;
        t[168] = t[166] + t[167];

        t[134] = (t[168] * 2) - t[104];

        t[120] = (t[134] * 2) - t[105];

        /* 14 */ hi[ 1] = `SHIFT(t[120]);

        t[135] = ((t[118] - t[119]) * `costab16 * 2) - t[120];

        /* 18 */ lo[ 2] = `SHIFT(t[135]);

        t[169] = ((t[132] - t[133]) * `costab16 * 2) - t[134];

        t[151] = (t[169] * 2) - t[135];

        /* 22 */ lo[ 6] = `SHIFT(t[151]);

        t[170] = ((((t[148] - t[149]) * `costab16 * 2) - t[150]) * 2) - t[151];

        /* 26 */ lo[10] = `SHIFT(t[170]);
        /* 30 */ lo[14] = `SHIFT(((((((t[166] - t[167]) * `costab16 * 2) - t[168]) * 2) - t[169]) * 2) - t[170]);

        t[171] = (t[106] - t[107]) * `costab8;
        t[172] = (t[108] - t[109]) * `costab24;
        t[173] = t[171] + t[172];

        t[138] = (t[173] * 2) - t[110];

        t[123] = (t[138] * 2) - t[111];

        t[139] = ((t[121] - t[122]) * `costab16 * 2) - t[123];

        t[117] = (t[123] * 2) - t[112];

        /* 15 */ hi[ 0] = `SHIFT(t[117]);

        t[124] = ((t[115] - t[116]) * `costab16 * 2) - t[117];

        /* 17 */ lo[ 1] = `SHIFT(t[124]);

        t[131] = (t[139] * 2) - t[124];

        /* 19 */ lo[ 3] = `SHIFT(t[131]);

        t[140] = (t[164] * 2) - t[131];

        /* 21 */ lo[ 5] = `SHIFT(t[140]);

        t[174] = ((t[136] - t[137]) * `costab16 * 2) - t[138];

        t[155] = (t[174] * 2) - t[139];

        t[147] = (t[155] * 2) - t[140];

        /* 23 */ lo[ 7] = `SHIFT(t[147]);

        t[156] = ((((t[144] - t[145]) * `costab16 * 2) - t[146]) * 2) - t[147];

        /* 25 */ lo[ 9] = `SHIFT(t[156]);

        t[175] = ((((t[152] - t[153]) * `costab16 * 2) - t[154]) * 2) - t[155];

        t[165] = (t[175] * 2) - t[156];

        /* 27 */ lo[11] = `SHIFT(t[165]);

        t[176] = ((((((t[161] - t[162]) * `costab16 * 2) - t[163]) * 2) - t[164]) * 2) - t[165];

        /* 29 */ lo[13] = `SHIFT(t[176]);
        /* 31 */ lo[15] = `SHIFT(((((((((t[171] - t[172]) * `costab16 * 2) - t[173]) * 2) - t[174]) * 2) - t[175]) * 2) - t[176]);
    end
    
endmodule
