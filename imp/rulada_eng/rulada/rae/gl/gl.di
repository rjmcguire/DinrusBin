module rae.gl.gl;

/*
 * Mesa 3-D graphics library
 * Version:  6.3
 *
 * Copyright (C) 1999-2005  Brian Paul   All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * BRIAN PAUL BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//import c.gl.glext;

version(gtk)
{
	public import gtkD.gtkglc.gl;
}
else version(derelict)
{
	public import derelict.opengl.gl;
}
else
{

version(Rulada)
{
	import tango.util.log.Trace;//Thread safe console output.
	import stringz = tango.stdc.stringz;
	import tango.sys.SharedLib;
}
else //Phobos
{
	private import std.loader;
}


/*
 * Constants
 */
// Boolean values
const ubyte GL_FALSE				= 0x0;
const ubyte GL_TRUE				= 0x1;

// Data types
const GLuint GL_BYTE				= 0x1400;
const GLuint GL_UNSIGNED_BYTE			= 0x1401;
const GLuint GL_SHORT				= 0x1402;
const GLuint GL_UNSIGNED_SHORT			= 0x1403;
const GLuint GL_INT				= 0x1404;
const GLuint GL_UNSIGNED_INT			= 0x1405;
const GLuint GL_FLOAT				= 0x1406;
const GLuint GL_DOUBLE				= 0x140A;
const GLuint GL_2_BYTES				= 0x1407;
const GLuint GL_3_BYTES				= 0x1408;
const GLuint GL_4_BYTES				= 0x1409;

// Primitives
const GLuint GL_POINTS				= 0x0000;
const GLuint GL_LINES				= 0x0001;
const GLuint GL_LINE_LOOP			= 0x0002;
const GLuint GL_LINE_STRIP			= 0x0003;
const GLuint GL_TRIANGLES			= 0x0004;
const GLuint GL_TRIANGLE_STRIP			= 0x0005;
const GLuint GL_TRIANGLE_FAN			= 0x0006;
const GLuint GL_QUADS				= 0x0007;
const GLuint GL_QUAD_STRIP			= 0x0008;
const GLuint GL_POLYGON				= 0x0009;

// Vertex Arrays
const GLuint GL_VERTEX_ARRAY			= 0x8074;
const GLuint GL_NORMAL_ARRAY			= 0x8075;
const GLuint GL_COLOR_ARRAY			= 0x8076;
const GLuint GL_INDEX_ARRAY			= 0x8077;
const GLuint GL_TEXTURE_COORD_ARRAY		= 0x8078;
const GLuint GL_EDGE_FLAG_ARRAY			= 0x8079;
const GLuint GL_VERTEX_ARRAY_SIZE		= 0x807A;
const GLuint GL_VERTEX_ARRAY_TYPE		= 0x807B;
const GLuint GL_VERTEX_ARRAY_STRIDE		= 0x807C;
const GLuint GL_NORMAL_ARRAY_TYPE		= 0x807E;
const GLuint GL_NORMAL_ARRAY_STRIDE		= 0x807F;
const GLuint GL_COLOR_ARRAY_SIZE		= 0x8081;
const GLuint GL_COLOR_ARRAY_TYPE		= 0x8082;
const GLuint GL_COLOR_ARRAY_STRIDE		= 0x8083;
const GLuint GL_INDEX_ARRAY_TYPE		= 0x8085;
const GLuint GL_INDEX_ARRAY_STRIDE		= 0x8086;
const GLuint GL_TEXTURE_COORD_ARRAY_SIZE	= 0x8088;
const GLuint GL_TEXTURE_COORD_ARRAY_TYPE	= 0x8089;
const GLuint GL_TEXTURE_COORD_ARRAY_STRIDE	= 0x808A;
const GLuint GL_EDGE_FLAG_ARRAY_STRIDE		= 0x808C;
const GLuint GL_VERTEX_ARRAY_POINTER		= 0x808E;
const GLuint GL_NORMAL_ARRAY_POINTER		= 0x808F;
const GLuint GL_COLOR_ARRAY_POINTER		= 0x8090;
const GLuint GL_INDEX_ARRAY_POINTER		= 0x8091;
const GLuint GL_TEXTURE_COORD_ARRAY_POINTER	= 0x8092;
const GLuint GL_EDGE_FLAG_ARRAY_POINTER		= 0x8093;
const GLuint GL_V2F				= 0x2A20;
const GLuint GL_V3F				= 0x2A21;
const GLuint GL_C4UB_V2F			= 0x2A22;
const GLuint GL_C4UB_V3F			= 0x2A23;
const GLuint GL_C3F_V3F				= 0x2A24;
const GLuint GL_N3F_V3F				= 0x2A25;
const GLuint GL_C4F_N3F_V3F			= 0x2A26;
const GLuint GL_T2F_V3F				= 0x2A27;
const GLuint GL_T4F_V4F				= 0x2A28;
const GLuint GL_T2F_C4UB_V3F			= 0x2A29;
const GLuint GL_T2F_C3F_V3F			= 0x2A2A;
const GLuint GL_T2F_N3F_V3F			= 0x2A2B;
const GLuint GL_T2F_C4F_N3F_V3F			= 0x2A2C;
const GLuint GL_T4F_C4F_N3F_V4F			= 0x2A2D;

// Matrix Mode
const GLuint GL_MATRIX_MODE			= 0x0BA0;
const GLuint GL_MODELVIEW			= 0x1700;
const GLuint GL_PROJECTION			= 0x1701;
const GLuint GL_TEXTURE				= 0x1702;

// Points
const GLuint GL_POINT_SMOOTH			= 0x0B10;
const GLuint GL_POINT_SIZE			= 0x0B11;
const GLuint GL_POINT_SIZE_GRANULARITY		= 0x0B13;
const GLuint GL_POINT_SIZE_RANGE		= 0x0B12;

// Lines
const GLuint GL_LINE_SMOOTH			= 0x0B20;
const GLuint GL_LINE_STIPPLE			= 0x0B24;
const GLuint GL_LINE_STIPPLE_PATTERN		= 0x0B25;
const GLuint GL_LINE_STIPPLE_REPEAT		= 0x0B26;
const GLuint GL_LINE_WIDTH			= 0x0B21;
const GLuint GL_LINE_WIDTH_GRANULARITY		= 0x0B23;
const GLuint GL_LINE_WIDTH_RANGE		= 0x0B22;

// Polygons
const GLuint GL_POINT				= 0x1B00;
const GLuint GL_LINE				= 0x1B01;
const GLuint GL_FILL				= 0x1B02;
const GLuint GL_CW				= 0x0900;
const GLuint GL_CCW				= 0x0901;
const GLuint GL_FRONT				= 0x0404;
const GLuint GL_BACK				= 0x0405;
const GLuint GL_POLYGON_MODE			= 0x0B40;
const GLuint GL_POLYGON_SMOOTH			= 0x0B41;
const GLuint GL_POLYGON_STIPPLE			= 0x0B42;
const GLuint GL_EDGE_FLAG			= 0x0B43;
const GLuint GL_CULL_FACE			= 0x0B44;
const GLuint GL_CULL_FACE_MODE			= 0x0B45;
const GLuint GL_FRONT_FACE			= 0x0B46;
const GLuint GL_POLYGON_OFFSET_FACTOR		= 0x8038;
const GLuint GL_POLYGON_OFFSET_UNITS		= 0x2A00;
const GLuint GL_POLYGON_OFFSET_POINT		= 0x2A01;
const GLuint GL_POLYGON_OFFSET_LINE		= 0x2A02;
const GLuint GL_POLYGON_OFFSET_FILL		= 0x8037;

// Display Lists
const GLuint GL_COMPILE				= 0x1300;
const GLuint GL_COMPILE_AND_EXECUTE		= 0x1301;
const GLuint GL_LIST_BASE			= 0x0B32;
const GLuint GL_LIST_INDEX			= 0x0B33;
const GLuint GL_LIST_MODE			= 0x0B30;

// Depth buffer
const GLuint GL_NEVER				= 0x0200;
const GLuint GL_LESS				= 0x0201;
const GLuint GL_EQUAL				= 0x0202;
const GLuint GL_LEQUAL				= 0x0203;
const GLuint GL_GREATER				= 0x0204;
const GLuint GL_NOTEQUAL			= 0x0205;
const GLuint GL_GEQUAL				= 0x0206;
const GLuint GL_ALWAYS				= 0x0207;
const GLuint GL_DEPTH_TEST			= 0x0B71;
const GLuint GL_DEPTH_BITS			= 0x0D56;
const GLuint GL_DEPTH_CLEAR_VALUE		= 0x0B73;
const GLuint GL_DEPTH_FUNC			= 0x0B74;
const GLuint GL_DEPTH_RANGE			= 0x0B70;
const GLuint GL_DEPTH_WRITEMASK			= 0x0B72;
const GLuint GL_DEPTH_COMPONENT			= 0x1902;

// Lighting
const GLuint GL_LIGHTING			= 0x0B50;
const GLuint GL_LIGHT0				= 0x4000;
const GLuint GL_LIGHT1				= 0x4001;
const GLuint GL_LIGHT2				= 0x4002;
const GLuint GL_LIGHT3				= 0x4003;
const GLuint GL_LIGHT4				= 0x4004;
const GLuint GL_LIGHT5				= 0x4005;
const GLuint GL_LIGHT6				= 0x4006;
const GLuint GL_LIGHT7				= 0x4007;
const GLuint GL_SPOT_EXPONENT			= 0x1205;
const GLuint GL_SPOT_CUTOFF			= 0x1206;
const GLuint GL_CONSTANT_ATTENUATION		= 0x1207;
const GLuint GL_LINEAR_ATTENUATION		= 0x1208;
const GLuint GL_QUADRATIC_ATTENUATION		= 0x1209;
const GLuint GL_AMBIENT				= 0x1200;
const GLuint GL_DIFFUSE				= 0x1201;
const GLuint GL_SPECULAR			= 0x1202;
const GLuint GL_SHININESS			= 0x1601;
const GLuint GL_EMISSION			= 0x1600;
const GLuint GL_POSITION			= 0x1203;
const GLuint GL_SPOT_DIRECTION			= 0x1204;
const GLuint GL_AMBIENT_AND_DIFFUSE		= 0x1602;
const GLuint GL_COLOR_INDEXES			= 0x1603;
const GLuint GL_LIGHT_MODEL_TWO_SIDE		= 0x0B52;
const GLuint GL_LIGHT_MODEL_LOCAL_VIEWER	= 0x0B51;
const GLuint GL_LIGHT_MODEL_AMBIENT		= 0x0B53;
const GLuint GL_FRONT_AND_BACK			= 0x0408;
const GLuint GL_SHADE_MODEL			= 0x0B54;
const GLuint GL_FLAT				= 0x1D00;
const GLuint GL_SMOOTH				= 0x1D01;
const GLuint GL_COLOR_MATERIAL			= 0x0B57;
const GLuint GL_COLOR_MATERIAL_FACE		= 0x0B55;
const GLuint GL_COLOR_MATERIAL_PARAMETER	= 0x0B56;
const GLuint GL_NORMALIZE			= 0x0BA1;

// User clipping planes
const GLuint GL_CLIP_PLANE0			= 0x3000;
const GLuint GL_CLIP_PLANE1			= 0x3001;
const GLuint GL_CLIP_PLANE2			= 0x3002;
const GLuint GL_CLIP_PLANE3			= 0x3003;
const GLuint GL_CLIP_PLANE4			= 0x3004;
const GLuint GL_CLIP_PLANE5			= 0x3005;

// Accumulation buffer
const GLuint GL_ACCUM_RED_BITS			= 0x0D58;
const GLuint GL_ACCUM_GREEN_BITS		= 0x0D59;
const GLuint GL_ACCUM_BLUE_BITS			= 0x0D5A;
const GLuint GL_ACCUM_ALPHA_BITS		= 0x0D5B;
const GLuint GL_ACCUM_CLEAR_VALUE		= 0x0B80;
const GLuint GL_ACCUM				= 0x0100;
const GLuint GL_ADD				= 0x0104;
const GLuint GL_LOAD				= 0x0101;
const GLuint GL_MULT				= 0x0103;
const GLuint GL_RETURN				= 0x0102;

// Alpha testing
const GLuint GL_ALPHA_TEST			= 0x0BC0;
const GLuint GL_ALPHA_TEST_REF			= 0x0BC2;
const GLuint GL_ALPHA_TEST_FUNC			= 0x0BC1;

// Blending
const GLuint GL_BLEND				= 0x0BE2;
const GLuint GL_BLEND_SRC			= 0x0BE1;
const GLuint GL_BLEND_DST			= 0x0BE0;
const GLuint GL_ZERO				= 0x0;
const GLuint GL_ONE				= 0x1;
const GLuint GL_SRC_COLOR			= 0x0300;
const GLuint GL_ONE_MINUS_SRC_COLOR		= 0x0301;
const GLuint GL_SRC_ALPHA			= 0x0302;
const GLuint GL_ONE_MINUS_SRC_ALPHA		= 0x0303;
const GLuint GL_DST_ALPHA			= 0x0304;
const GLuint GL_ONE_MINUS_DST_ALPHA		= 0x0305;
const GLuint GL_DST_COLOR			= 0x0306;
const GLuint GL_ONE_MINUS_DST_COLOR		= 0x0307;
const GLuint GL_SRC_ALPHA_SATURATE		= 0x0308;

// Render Mode
const GLuint GL_FEEDBACK			= 0x1C01;
const GLuint GL_RENDER				= 0x1C00;
const GLuint GL_SELECT				= 0x1C02;

// Feedback
const GLuint GL_2D				= 0x0600;
const GLuint GL_3D				= 0x0601;
const GLuint GL_3D_COLOR			= 0x0602;
const GLuint GL_3D_COLOR_TEXTURE		= 0x0603;
const GLuint GL_4D_COLOR_TEXTURE		= 0x0604;
const GLuint GL_POINT_TOKEN			= 0x0701;
const GLuint GL_LINE_TOKEN			= 0x0702;
const GLuint GL_LINE_RESET_TOKEN		= 0x0707;
const GLuint GL_POLYGON_TOKEN			= 0x0703;
const GLuint GL_BITMAP_TOKEN			= 0x0704;
const GLuint GL_DRAW_PIXEL_TOKEN		= 0x0705;
const GLuint GL_COPY_PIXEL_TOKEN		= 0x0706;
const GLuint GL_PASS_THROUGH_TOKEN		= 0x0700;
const GLuint GL_FEEDBACK_BUFFER_POINTER		= 0x0DF0;
const GLuint GL_FEEDBACK_BUFFER_SIZE		= 0x0DF1;
const GLuint GL_FEEDBACK_BUFFER_TYPE		= 0x0DF2;

// Selection
const GLuint GL_SELECTION_BUFFER_POINTER	= 0x0DF3;
const GLuint GL_SELECTION_BUFFER_SIZE		= 0x0DF4;

// Fog
const GLuint GL_FOG				= 0x0B60;
const GLuint GL_FOG_MODE			= 0x0B65;
const GLuint GL_FOG_DENSITY			= 0x0B62;
const GLuint GL_FOG_COLOR			= 0x0B66;
const GLuint GL_FOG_INDEX			= 0x0B61;
const GLuint GL_FOG_START			= 0x0B63;
const GLuint GL_FOG_END				= 0x0B64;
const GLuint GL_LINEAR				= 0x2601;
const GLuint GL_EXP				= 0x0800;
const GLuint GL_EXP2				= 0x0801;

// Logic Ops
const GLuint GL_LOGIC_OP			= 0x0BF1;
const GLuint GL_INDEX_LOGIC_OP			= 0x0BF1;
const GLuint GL_COLOR_LOGIC_OP			= 0x0BF2;
const GLuint GL_LOGIC_OP_MODE			= 0x0BF0;
const GLuint GL_CLEAR				= 0x1500;
const GLuint GL_SET				= 0x150F;
const GLuint GL_COPY				= 0x1503;
const GLuint GL_COPY_INVERTED			= 0x150C;
const GLuint GL_NOOP				= 0x1505;
const GLuint GL_INVERT				= 0x150A;
const GLuint GL_AND				= 0x1501;
const GLuint GL_NAND				= 0x150E;
const GLuint GL_OR				= 0x1507;
const GLuint GL_NOR				= 0x1508;
const GLuint GL_XOR				= 0x1506;
const GLuint GL_EQUIV				= 0x1509;
const GLuint GL_AND_REVERSE			= 0x1502;
const GLuint GL_AND_INVERTED			= 0x1504;
const GLuint GL_OR_REVERSE			= 0x150B;
const GLuint GL_OR_INVERTED			= 0x150D;

// Stencil
const GLuint GL_STENCIL_TEST			= 0x0B90;
const GLuint GL_STENCIL_WRITEMASK		= 0x0B98;
const GLuint GL_STENCIL_BITS			= 0x0D57;
const GLuint GL_STENCIL_FUNC			= 0x0B92;
const GLuint GL_STENCIL_VALUE_MASK		= 0x0B93;
const GLuint GL_STENCIL_REF			= 0x0B97;
const GLuint GL_STENCIL_FAIL			= 0x0B94;
const GLuint GL_STENCIL_PASS_DEPTH_PASS		= 0x0B96;
const GLuint GL_STENCIL_PASS_DEPTH_FAIL		= 0x0B95;
const GLuint GL_STENCIL_CLEAR_VALUE		= 0x0B91;
const GLuint GL_STENCIL_INDEX			= 0x1901;
const GLuint GL_KEEP				= 0x1E00;
const GLuint GL_REPLACE				= 0x1E01;
const GLuint GL_INCR				= 0x1E02;
const GLuint GL_DECR				= 0x1E03;

// Buffers, Pixel Drawing/Reading
const GLuint GL_NONE				= 0x0;
const GLuint GL_LEFT				= 0x0406; 
const GLuint GL_RIGHT				= 0x0407;
//const GLuint GL_FRONT				= 0x0404;
//const GLuint GL_BACK				= 0x0405;
//const GLuint GL_FRONT_AND_BACK		= 0x0408;
const GLuint GL_FRONT_LEFT			= 0x0400;
const GLuint GL_FRONT_RIGHT			= 0x0401;
const GLuint GL_BACK_LEFT			= 0x0402;
const GLuint GL_BACK_RIGHT			= 0x0403;
const GLuint GL_AUX0				= 0x0409;
const GLuint GL_AUX1				= 0x040A;
const GLuint GL_AUX2				= 0x040B;
const GLuint GL_AUX3				= 0x040C;
const GLuint GL_COLOR_INDEX			= 0x1900;
const GLuint GL_RED				= 0x1903;
const GLuint GL_GREEN				= 0x1904;
const GLuint GL_BLUE				= 0x1905;
const GLuint GL_ALPHA				= 0x1906;
const GLuint GL_LUMINANCE			= 0x1909;
const GLuint GL_LUMINANCE_ALPHA			= 0x190A;
const GLuint GL_ALPHA_BITS			= 0x0D55;
const GLuint GL_RED_BITS			= 0x0D52;
const GLuint GL_GREEN_BITS			= 0x0D53;
const GLuint GL_BLUE_BITS			= 0x0D54;
const GLuint GL_INDEX_BITS			= 0x0D51;
const GLuint GL_SUBPIXEL_BITS			= 0x0D50;
const GLuint GL_AUX_BUFFERS			= 0x0C00;
const GLuint GL_READ_BUFFER			= 0x0C02;
const GLuint GL_DRAW_BUFFER			= 0x0C01;
const GLuint GL_DOUBLEBUFFER			= 0x0C32;
const GLuint GL_STEREO				= 0x0C33;
const GLuint GL_BITMAP				= 0x1A00;
const GLuint GL_COLOR				= 0x1800;
const GLuint GL_DEPTH				= 0x1801;
const GLuint GL_STENCIL				= 0x1802;
const GLuint GL_DITHER				= 0x0BD0;
const GLuint GL_RGB				= 0x1907;
const GLuint GL_RGBA				= 0x1908;

// Implementation limits
const GLuint GL_MAX_LIST_NESTING		= 0x0B31;
const GLuint GL_MAX_ATTRIB_STACK_DEPTH		= 0x0D35;
const GLuint GL_MAX_MODELVIEW_STACK_DEPTH	= 0x0D36;
const GLuint GL_MAX_NAME_STACK_DEPTH		= 0x0D37;
const GLuint GL_MAX_PROJECTION_STACK_DEPTH	= 0x0D38;
const GLuint GL_MAX_TEXTURE_STACK_DEPTH		= 0x0D39;
const GLuint GL_MAX_EVAL_ORDER			= 0x0D30;
const GLuint GL_MAX_LIGHTS			= 0x0D31;
const GLuint GL_MAX_CLIP_PLANES			= 0x0D32;
const GLuint GL_MAX_TEXTURE_SIZE		= 0x0D33;
const GLuint GL_MAX_PIXEL_MAP_TABLE		= 0x0D34;
const GLuint GL_MAX_VIEWPORT_DIMS		= 0x0D3A;
const GLuint GL_MAX_CLIENT_ATTRIB_STACK_DEPTH	= 0x0D3B;

// Gets
const GLuint GL_ATTRIB_STACK_DEPTH		= 0x0BB0;
const GLuint GL_CLIENT_ATTRIB_STACK_DEPTH	= 0x0BB1;
const GLuint GL_COLOR_CLEAR_VALUE		= 0x0C22;
const GLuint GL_COLOR_WRITEMASK			= 0x0C23;
const GLuint GL_CURRENT_INDEX			= 0x0B01;
const GLuint GL_CURRENT_COLOR			= 0x0B00;
const GLuint GL_CURRENT_NORMAL			= 0x0B02;
const GLuint GL_CURRENT_RASTER_COLOR		= 0x0B04;
const GLuint GL_CURRENT_RASTER_DISTANCE		= 0x0B09;
const GLuint GL_CURRENT_RASTER_INDEX		= 0x0B05;
const GLuint GL_CURRENT_RASTER_POSITION		= 0x0B07;
const GLuint GL_CURRENT_RASTER_TEXTURE_COORDS	= 0x0B06;
const GLuint GL_CURRENT_RASTER_POSITION_VALID	= 0x0B08;
const GLuint GL_CURRENT_TEXTURE_COORDS		= 0x0B03;
const GLuint GL_INDEX_CLEAR_VALUE		= 0x0C20;
const GLuint GL_INDEX_MODE			= 0x0C30;
const GLuint GL_INDEX_WRITEMASK			= 0x0C21;
const GLuint GL_MODELVIEW_MATRIX		= 0x0BA6;
const GLuint GL_MODELVIEW_STACK_DEPTH		= 0x0BA3;
const GLuint GL_NAME_STACK_DEPTH		= 0x0D70;
const GLuint GL_PROJECTION_MATRIX		= 0x0BA7;
const GLuint GL_PROJECTION_STACK_DEPTH		= 0x0BA4;
const GLuint GL_RENDER_MODE			= 0x0C40;
const GLuint GL_RGBA_MODE			= 0x0C31;
const GLuint GL_TEXTURE_MATRIX			= 0x0BA8;
const GLuint GL_TEXTURE_STACK_DEPTH		= 0x0BA5;
const GLuint GL_VIEWPORT			= 0x0BA2;

// Evaluators
const GLuint GL_AUTO_NORMAL			= 0x0D80;
const GLuint GL_MAP1_COLOR_4			= 0x0D90;
const GLuint GL_MAP1_GRID_DOMAIN		= 0x0DD0;
const GLuint GL_MAP1_GRID_SEGMENTS		= 0x0DD1;
const GLuint GL_MAP1_INDEX			= 0x0D91;
const GLuint GL_MAP1_NORMAL			= 0x0D92;
const GLuint GL_MAP1_TEXTURE_COORD_1		= 0x0D93;
const GLuint GL_MAP1_TEXTURE_COORD_2		= 0x0D94;
const GLuint GL_MAP1_TEXTURE_COORD_3		= 0x0D95;
const GLuint GL_MAP1_TEXTURE_COORD_4		= 0x0D96;
const GLuint GL_MAP1_VERTEX_3			= 0x0D97;
const GLuint GL_MAP1_VERTEX_4			= 0x0D98;
const GLuint GL_MAP2_COLOR_4			= 0x0DB0;
const GLuint GL_MAP2_GRID_DOMAIN		= 0x0DD2;
const GLuint GL_MAP2_GRID_SEGMENTS		= 0x0DD3;
const GLuint GL_MAP2_INDEX			= 0x0DB1;
const GLuint GL_MAP2_NORMAL			= 0x0DB2;
const GLuint GL_MAP2_TEXTURE_COORD_1		= 0x0DB3;
const GLuint GL_MAP2_TEXTURE_COORD_2		= 0x0DB4;
const GLuint GL_MAP2_TEXTURE_COORD_3		= 0x0DB5;
const GLuint GL_MAP2_TEXTURE_COORD_4		= 0x0DB6;
const GLuint GL_MAP2_VERTEX_3			= 0x0DB7;
const GLuint GL_MAP2_VERTEX_4			= 0x0DB8;
const GLuint GL_COEFF				= 0x0A00;
const GLuint GL_DOMAIN				= 0x0A02;
const GLuint GL_ORDER				= 0x0A01;

// Hints
const GLuint GL_FOG_HINT			= 0x0C54;
const GLuint GL_LINE_SMOOTH_HINT		= 0x0C52;
const GLuint GL_PERSPECTIVE_CORRECTION_HINT	= 0x0C50;
const GLuint GL_POINT_SMOOTH_HINT		= 0x0C51;
const GLuint GL_POLYGON_SMOOTH_HINT		= 0x0C53;
const GLuint GL_DONT_CARE			= 0x1100;
const GLuint GL_FASTEST				= 0x1101;
const GLuint GL_NICEST				= 0x1102;

// Scissor box
const GLuint GL_SCISSOR_TEST			= 0x0C11;
const GLuint GL_SCISSOR_BOX			= 0x0C10;

// Pixel Mode / Transfer
const GLuint GL_MAP_COLOR			= 0x0D10;
const GLuint GL_MAP_STENCIL			= 0x0D11;
const GLuint GL_INDEX_SHIFT			= 0x0D12;
const GLuint GL_INDEX_OFFSET			= 0x0D13;
const GLuint GL_RED_SCALE			= 0x0D14;
const GLuint GL_RED_BIAS			= 0x0D15;
const GLuint GL_GREEN_SCALE			= 0x0D18;
const GLuint GL_GREEN_BIAS			= 0x0D19;
const GLuint GL_BLUE_SCALE			= 0x0D1A;
const GLuint GL_BLUE_BIAS			= 0x0D1B;
const GLuint GL_ALPHA_SCALE			= 0x0D1C;
const GLuint GL_ALPHA_BIAS			= 0x0D1D;
const GLuint GL_DEPTH_SCALE			= 0x0D1E;
const GLuint GL_DEPTH_BIAS			= 0x0D1F;
const GLuint GL_PIXEL_MAP_S_TO_S_SIZE		= 0x0CB1;
const GLuint GL_PIXEL_MAP_I_TO_I_SIZE		= 0x0CB0;
const GLuint GL_PIXEL_MAP_I_TO_R_SIZE		= 0x0CB2;
const GLuint GL_PIXEL_MAP_I_TO_G_SIZE		= 0x0CB3;
const GLuint GL_PIXEL_MAP_I_TO_B_SIZE		= 0x0CB4;
const GLuint GL_PIXEL_MAP_I_TO_A_SIZE		= 0x0CB5;
const GLuint GL_PIXEL_MAP_R_TO_R_SIZE		= 0x0CB6;
const GLuint GL_PIXEL_MAP_G_TO_G_SIZE		= 0x0CB7;
const GLuint GL_PIXEL_MAP_B_TO_B_SIZE		= 0x0CB8;
const GLuint GL_PIXEL_MAP_A_TO_A_SIZE		= 0x0CB9;
const GLuint GL_PIXEL_MAP_S_TO_S		= 0x0C71;
const GLuint GL_PIXEL_MAP_I_TO_I		= 0x0C70;
const GLuint GL_PIXEL_MAP_I_TO_R		= 0x0C72;
const GLuint GL_PIXEL_MAP_I_TO_G		= 0x0C73;
const GLuint GL_PIXEL_MAP_I_TO_B		= 0x0C74;
const GLuint GL_PIXEL_MAP_I_TO_A		= 0x0C75;
const GLuint GL_PIXEL_MAP_R_TO_R		= 0x0C76;
const GLuint GL_PIXEL_MAP_G_TO_G		= 0x0C77;
const GLuint GL_PIXEL_MAP_B_TO_B		= 0x0C78;
const GLuint GL_PIXEL_MAP_A_TO_A		= 0x0C79;
const GLuint GL_PACK_ALIGNMENT			= 0x0D05;
const GLuint GL_PACK_LSB_FIRST			= 0x0D01;
const GLuint GL_PACK_ROW_LENGTH			= 0x0D02;
const GLuint GL_PACK_SKIP_PIXELS		= 0x0D04;
const GLuint GL_PACK_SKIP_ROWS			= 0x0D03;
const GLuint GL_PACK_SWAP_BYTES			= 0x0D00;
const GLuint GL_UNPACK_ALIGNMENT		= 0x0CF5;
const GLuint GL_UNPACK_LSB_FIRST		= 0x0CF1;
const GLuint GL_UNPACK_ROW_LENGTH		= 0x0CF2;
const GLuint GL_UNPACK_SKIP_PIXELS		= 0x0CF4;
const GLuint GL_UNPACK_SKIP_ROWS		= 0x0CF3;
const GLuint GL_UNPACK_SWAP_BYTES		= 0x0CF0;
const GLuint GL_ZOOM_X				= 0x0D16;
const GLuint GL_ZOOM_Y				= 0x0D17;

// Texture mapping
const GLuint GL_TEXTURE_ENV			= 0x2300;
const GLuint GL_TEXTURE_ENV_MODE		= 0x2200;
const GLuint GL_TEXTURE_1D			= 0x0DE0;
const GLuint GL_TEXTURE_2D			= 0x0DE1;
const GLuint GL_TEXTURE_WRAP_S			= 0x2802;
const GLuint GL_TEXTURE_WRAP_T			= 0x2803;
const GLuint GL_TEXTURE_MAG_FILTER		= 0x2800;
const GLuint GL_TEXTURE_MIN_FILTER		= 0x2801;
const GLuint GL_TEXTURE_ENV_COLOR		= 0x2201;
const GLuint GL_TEXTURE_GEN_S			= 0x0C60;
const GLuint GL_TEXTURE_GEN_T			= 0x0C61;
const GLuint GL_TEXTURE_GEN_MODE		= 0x2500;
const GLuint GL_TEXTURE_BORDER_COLOR		= 0x1004;
const GLuint GL_TEXTURE_WIDTH			= 0x1000;
const GLuint GL_TEXTURE_HEIGHT			= 0x1001;
const GLuint GL_TEXTURE_BORDER			= 0x1005;
const GLuint GL_TEXTURE_COMPONENTS		= 0x1003;
const GLuint GL_TEXTURE_RED_SIZE		= 0x805C;
const GLuint GL_TEXTURE_GREEN_SIZE		= 0x805D;
const GLuint GL_TEXTURE_BLUE_SIZE		= 0x805E;
const GLuint GL_TEXTURE_ALPHA_SIZE		= 0x805F;
const GLuint GL_TEXTURE_LUMINANCE_SIZE		= 0x8060;
const GLuint GL_TEXTURE_INTENSITY_SIZE		= 0x8061;
const GLuint GL_NEAREST_MIPMAP_NEAREST		= 0x2700;
const GLuint GL_NEAREST_MIPMAP_LINEAR		= 0x2702;
const GLuint GL_LINEAR_MIPMAP_NEAREST		= 0x2701;
const GLuint GL_LINEAR_MIPMAP_LINEAR		= 0x2703;
const GLuint GL_OBJECT_LINEAR			= 0x2401;
const GLuint GL_OBJECT_PLANE			= 0x2501;
const GLuint GL_EYE_LINEAR			= 0x2400;
const GLuint GL_EYE_PLANE			= 0x2502;
const GLuint GL_SPHERE_MAP			= 0x2402;
const GLuint GL_DECAL				= 0x2101;
const GLuint GL_MODULATE			= 0x2100;
const GLuint GL_NEAREST				= 0x2600;
const GLuint GL_REPEAT				= 0x2901;
const GLuint GL_CLAMP				= 0x2900;
const GLuint GL_S				= 0x2000;
const GLuint GL_T				= 0x2001;
const GLuint GL_R				= 0x2002;
const GLuint GL_Q				= 0x2003;
const GLuint GL_TEXTURE_GEN_R			= 0x0C62;
const GLuint GL_TEXTURE_GEN_Q			= 0x0C63;

// Utility
const GLuint GL_VENDOR				= 0x1F00;
const GLuint GL_RENDERER			= 0x1F01;
const GLuint GL_VERSION				= 0x1F02;
const GLuint GL_EXTENSIONS			= 0x1F03;

// Errors
const GLuint GL_NO_ERROR			= 0x0;
const GLuint GL_INVALID_VALUE			= 0x0501;
const GLuint GL_INVALID_ENUM			= 0x0500;
const GLuint GL_INVALID_OPERATION		= 0x0502;
const GLuint GL_STACK_OVERFLOW			= 0x0503;
const GLuint GL_STACK_UNDERFLOW			= 0x0504;
const GLuint GL_OUT_OF_MEMORY			= 0x0505;

// glPush/PopAttrib bits
const GLuint GL_CURRENT_BIT			= 0x00000001;
const GLuint GL_POINT_BIT			= 0x00000002;
const GLuint GL_LINE_BIT			= 0x00000004;
const GLuint GL_POLYGON_BIT			= 0x00000008;
const GLuint GL_POLYGON_STIPPLE_BIT		= 0x00000010;
const GLuint GL_PIXEL_MODE_BIT			= 0x00000020;
const GLuint GL_LIGHTING_BIT			= 0x00000040;
const GLuint GL_FOG_BIT				= 0x00000080;
const GLuint GL_DEPTH_BUFFER_BIT		= 0x00000100;
const GLuint GL_ACCUM_BUFFER_BIT		= 0x00000200;
const GLuint GL_STENCIL_BUFFER_BIT		= 0x00000400;
const GLuint GL_VIEWPORT_BIT			= 0x00000800;
const GLuint GL_TRANSFORM_BIT			= 0x00001000;
const GLuint GL_ENABLE_BIT			= 0x00002000;
const GLuint GL_COLOR_BUFFER_BIT		= 0x00004000;
const GLuint GL_HINT_BIT			= 0x00008000;
const GLuint GL_EVAL_BIT			= 0x00010000;
const GLuint GL_LIST_BIT			= 0x00020000;
const GLuint GL_TEXTURE_BIT			= 0x00040000;
const GLuint GL_SCISSOR_BIT			= 0x00080000;
const GLuint GL_ALL_ATTRIB_BITS			= 0x000FFFFF;

// OpenGL 1.1
const GLuint GL_PROXY_TEXTURE_1D		= 0x8063;
const GLuint GL_PROXY_TEXTURE_2D		= 0x8064;
const GLuint GL_TEXTURE_PRIORITY		= 0x8066;
const GLuint GL_TEXTURE_RESIDENT		= 0x8067;
const GLuint GL_TEXTURE_BINDING_1D		= 0x8068;
const GLuint GL_TEXTURE_BINDING_2D		= 0x8069;
const GLuint GL_TEXTURE_INTERNAL_FORMAT		= 0x1003;
const GLuint GL_ALPHA4				= 0x803B;
const GLuint GL_ALPHA8				= 0x803C;
const GLuint GL_ALPHA12				= 0x803D;
const GLuint GL_ALPHA16				= 0x803E;
const GLuint GL_LUMINANCE4			= 0x803F;
const GLuint GL_LUMINANCE8			= 0x8040;
const GLuint GL_LUMINANCE12			= 0x8041;
const GLuint GL_LUMINANCE16			= 0x8042;
const GLuint GL_LUMINANCE4_ALPHA4		= 0x8043;
const GLuint GL_LUMINANCE6_ALPHA2		= 0x8044;
const GLuint GL_LUMINANCE8_ALPHA8		= 0x8045;
const GLuint GL_LUMINANCE12_ALPHA4		= 0x8046;
const GLuint GL_LUMINANCE12_ALPHA12		= 0x8047;
const GLuint GL_LUMINANCE16_ALPHA16		= 0x8048;
const GLuint GL_INTENSITY			= 0x8049;
const GLuint GL_INTENSITY4			= 0x804A;
const GLuint GL_INTENSITY8			= 0x804B;
const GLuint GL_INTENSITY12			= 0x804C;
const GLuint GL_INTENSITY16			= 0x804D;
const GLuint GL_R3_G3_B2			= 0x2A10;
const GLuint GL_RGB4				= 0x804F;
const GLuint GL_RGB5				= 0x8050;
const GLuint GL_RGB8				= 0x8051;
const GLuint GL_RGB10				= 0x8052;
const GLuint GL_RGB12				= 0x8053;
const GLuint GL_RGB16				= 0x8054;
const GLuint GL_RGBA2				= 0x8055;
const GLuint GL_RGBA4				= 0x8056;
const GLuint GL_RGB5_A1				= 0x8057;
const GLuint GL_RGBA8				= 0x8058;
const GLuint GL_RGB10_A2			= 0x8059;
const GLuint GL_RGBA12				= 0x805A;
const GLuint GL_RGBA16				= 0x805B;
const GLuint GL_CLIENT_PIXEL_STORE_BIT		= 0x00000001;
const GLuint GL_CLIENT_VERTEX_ARRAY_BIT		= 0x00000002;
const GLuint GL_ALL_CLIENT_ATTRIB_BITS		= 0xFFFFFFFF;
const GLuint GL_CLIENT_ALL_ATTRIB_BITS		= 0xFFFFFFFF;

// OpenGL 1.2
const GLuint GL_RESCALE_NORMAL			= 0x803A;
const GLuint GL_CLAMP_TO_EDGE			= 0x812F;
const GLuint GL_MAX_ELEMENTS_VERTICES		= 0x80E8;
const GLuint GL_MAX_ELEMENTS_INDICES		= 0x80E9;
const GLuint GL_BGR				= 0x80E0;
const GLuint GL_BGRA				= 0x80E1;
const GLuint GL_UNSIGNED_BYTE_3_3_2		= 0x8032;
const GLuint GL_UNSIGNED_BYTE_2_3_3_REV		= 0x8362;
const GLuint GL_UNSIGNED_SHORT_5_6_5		= 0x8363;
const GLuint GL_UNSIGNED_SHORT_5_6_5_REV	= 0x8364;
const GLuint GL_UNSIGNED_SHORT_4_4_4_4		= 0x8033;
const GLuint GL_UNSIGNED_SHORT_4_4_4_4_REV	= 0x8365;
const GLuint GL_UNSIGNED_SHORT_5_5_5_1		= 0x8034;
const GLuint GL_UNSIGNED_SHORT_1_5_5_5_REV	= 0x8366;
const GLuint GL_UNSIGNED_INT_8_8_8_8		= 0x8035;
const GLuint GL_UNSIGNED_INT_8_8_8_8_REV	= 0x8367;
const GLuint GL_UNSIGNED_INT_10_10_10_2		= 0x8036;
const GLuint GL_UNSIGNED_INT_2_10_10_10_REV	= 0x8368;
const GLuint GL_LIGHT_MODEL_COLOR_CONTROL	= 0x81F8;
const GLuint GL_SINGLE_COLOR			= 0x81F9;
const GLuint GL_SEPARATE_SPECULAR_COLOR		= 0x81FA;
const GLuint GL_TEXTURE_MIN_LOD			= 0x813A;
const GLuint GL_TEXTURE_MAX_LOD			= 0x813B;
const GLuint GL_TEXTURE_BASE_LEVEL		= 0x813C;
const GLuint GL_TEXTURE_MAX_LEVEL		= 0x813D;
const GLuint GL_SMOOTH_POINT_SIZE_RANGE		= 0x0B12;
const GLuint GL_SMOOTH_POINT_SIZE_GRANULARITY	= 0x0B13;
const GLuint GL_SMOOTH_LINE_WIDTH_RANGE		= 0x0B22;
const GLuint GL_SMOOTH_LINE_WIDTH_GRANULARITY	= 0x0B23;
const GLuint GL_ALIASED_POINT_SIZE_RANGE	= 0x846D;
const GLuint GL_ALIASED_LINE_WIDTH_RANGE	= 0x846E;
const GLuint GL_PACK_SKIP_IMAGES		= 0x806B;
const GLuint GL_PACK_IMAGE_HEIGHT		= 0x806C;
const GLuint GL_UNPACK_SKIP_IMAGES		= 0x806D;
const GLuint GL_UNPACK_IMAGE_HEIGHT		= 0x806E;
const GLuint GL_TEXTURE_3D			= 0x806F;
const GLuint GL_PROXY_TEXTURE_3D		= 0x8070;
const GLuint GL_TEXTURE_DEPTH			= 0x8071;
const GLuint GL_TEXTURE_WRAP_R			= 0x8072;
const GLuint GL_MAX_3D_TEXTURE_SIZE		= 0x8073;
const GLuint GL_TEXTURE_BINDING_3D		= 0x806A;

// OpenGL 1.3
const GLuint GL_TEXTURE0			= 0x84C0;
const GLuint GL_TEXTURE1			= 0x84C1;
const GLuint GL_TEXTURE2			= 0x84C2;
const GLuint GL_TEXTURE3			= 0x84C3;
const GLuint GL_TEXTURE4			= 0x84C4;
const GLuint GL_TEXTURE5			= 0x84C5;
const GLuint GL_TEXTURE6			= 0x84C6;
const GLuint GL_TEXTURE7			= 0x84C7;
const GLuint GL_TEXTURE8			= 0x84C8;
const GLuint GL_TEXTURE9			= 0x84C9;
const GLuint GL_TEXTURE10			= 0x84CA;
const GLuint GL_TEXTURE11			= 0x84CB;
const GLuint GL_TEXTURE12			= 0x84CC;
const GLuint GL_TEXTURE13			= 0x84CD;
const GLuint GL_TEXTURE14			= 0x84CE;
const GLuint GL_TEXTURE15			= 0x84CF;
const GLuint GL_TEXTURE16			= 0x84D0;
const GLuint GL_TEXTURE17			= 0x84D1;
const GLuint GL_TEXTURE18			= 0x84D2;
const GLuint GL_TEXTURE19			= 0x84D3;
const GLuint GL_TEXTURE20			= 0x84D4;
const GLuint GL_TEXTURE21			= 0x84D5;
const GLuint GL_TEXTURE22			= 0x84D6;
const GLuint GL_TEXTURE23			= 0x84D7;
const GLuint GL_TEXTURE24			= 0x84D8;
const GLuint GL_TEXTURE25			= 0x84D9;
const GLuint GL_TEXTURE26			= 0x84DA;
const GLuint GL_TEXTURE27			= 0x84DB;
const GLuint GL_TEXTURE28			= 0x84DC;
const GLuint GL_TEXTURE29			= 0x84DD;
const GLuint GL_TEXTURE30			= 0x84DE;
const GLuint GL_TEXTURE31			= 0x84DF;
const GLuint GL_ACTIVE_TEXTURE			= 0x84E0;
const GLuint GL_CLIENT_ACTIVE_TEXTURE		= 0x84E1;
const GLuint GL_MAX_TEXTURE_UNITS		= 0x84E2;
const GLuint GL_NORMAL_MAP			= 0x8511;
const GLuint GL_REFLECTION_MAP			= 0x8512;
const GLuint GL_TEXTURE_CUBE_MAP		= 0x8513;
const GLuint GL_TEXTURE_BINDING_CUBE_MAP	= 0x8514;
const GLuint GL_TEXTURE_CUBE_MAP_POSITIVE_X	= 0x8515;
const GLuint GL_TEXTURE_CUBE_MAP_NEGATIVE_X	= 0x8516;
const GLuint GL_TEXTURE_CUBE_MAP_POSITIVE_Y	= 0x8517;
const GLuint GL_TEXTURE_CUBE_MAP_NEGATIVE_Y	= 0x8518;
const GLuint GL_TEXTURE_CUBE_MAP_POSITIVE_Z	= 0x8519;
const GLuint GL_TEXTURE_CUBE_MAP_NEGATIVE_Z	= 0x851A;
const GLuint GL_PROXY_TEXTURE_CUBE_MAP		= 0x851B;
const GLuint GL_MAX_CUBE_MAP_TEXTURE_SIZE	= 0x851C;
const GLuint GL_COMPRESSED_ALPHA		= 0x84E9;
const GLuint GL_COMPRESSED_LUMINANCE		= 0x84EA;
const GLuint GL_COMPRESSED_LUMINANCE_ALPHA	= 0x84EB;
const GLuint GL_COMPRESSED_INTENSITY		= 0x84EC;
const GLuint GL_COMPRESSED_RGB			= 0x84ED;
const GLuint GL_COMPRESSED_RGBA			= 0x84EE;
const GLuint GL_TEXTURE_COMPRESSION_HINT	= 0x84EF;
const GLuint GL_TEXTURE_COMPRESSED_IMAGE_SIZE	= 0x86A0;
const GLuint GL_TEXTURE_COMPRESSED		= 0x86A1;
const GLuint GL_NUM_COMPRESSED_TEXTURE_FORMATS	= 0x86A2;
const GLuint GL_COMPRESSED_TEXTURE_FORMATS	= 0x86A3;
const GLuint GL_MULTISAMPLE			= 0x809D;
const GLuint GL_SAMPLE_ALPHA_TO_COVERAGE	= 0x809E;
const GLuint GL_SAMPLE_ALPHA_TO_ONE		= 0x809F;
const GLuint GL_SAMPLE_COVERAGE			= 0x80A0;
const GLuint GL_SAMPLE_BUFFERS			= 0x80A8;
const GLuint GL_SAMPLES				= 0x80A9;
const GLuint GL_SAMPLE_COVERAGE_VALUE		= 0x80AA;
const GLuint GL_SAMPLE_COVERAGE_INVERT		= 0x80AB;
const GLuint GL_MULTISAMPLE_BIT			= 0x20000000;
const GLuint GL_TRANSPOSE_MODELVIEW_MATRIX	= 0x84E3;
const GLuint GL_TRANSPOSE_PROJECTION_MATRIX	= 0x84E4;
const GLuint GL_TRANSPOSE_TEXTURE_MATRIX	= 0x84E5;
const GLuint GL_TRANSPOSE_COLOR_MATRIX		= 0x84E6;
const GLuint GL_COMBINE				= 0x8570;
const GLuint GL_COMBINE_RGB			= 0x8571;
const GLuint GL_COMBINE_ALPHA			= 0x8572;
const GLuint GL_SOURCE0_RGB			= 0x8580;
const GLuint GL_SOURCE1_RGB			= 0x8581;
const GLuint GL_SOURCE2_RGB			= 0x8582;
const GLuint GL_SOURCE0_ALPHA			= 0x8588;
const GLuint GL_SOURCE1_ALPHA			= 0x8589;
const GLuint GL_SOURCE2_ALPHA			= 0x858A;
const GLuint GL_OPERAND0_RGB			= 0x8590;
const GLuint GL_OPERAND1_RGB			= 0x8591;
const GLuint GL_OPERAND2_RGB			= 0x8592;
const GLuint GL_OPERAND0_ALPHA			= 0x8598;
const GLuint GL_OPERAND1_ALPHA			= 0x8599;
const GLuint GL_OPERAND2_ALPHA			= 0x859A;
const GLuint GL_RGB_SCALE			= 0x8573;
const GLuint GL_ADD_SIGNED			= 0x8574;
const GLuint GL_INTERPOLATE			= 0x8575;
const GLuint GL_SUBTRACT			= 0x84E7;
const GLuint GL_CONSTANT			= 0x8576;
const GLuint GL_PRIMARY_COLOR			= 0x8577;
const GLuint GL_PREVIOUS			= 0x8578;
const GLuint GL_DOT3_RGB			= 0x86AE;
const GLuint GL_DOT3_RGBA			= 0x86AF;
const GLuint GL_CLAMP_TO_BORDER			= 0x812D;

// OpenGL 1.4
const GLuint GL_BLEND_DST_RGB			= 0x80C8;
const GLuint GL_BLEND_SRC_RGB			= 0x80C9;
const GLuint GL_BLEND_DST_ALPHA			= 0x80CA;
const GLuint GL_BLEND_SRC_ALPHA			= 0x80CB;
const GLuint GL_POINT_SIZE_MIN			= 0x8126;
const GLuint GL_POINT_SIZE_MAX			= 0x8127;
const GLuint GL_POINT_FADE_THRESHOLD_SIZE	= 0x8128;
const GLuint GL_POINT_DISTANCE_ATTENUATION	= 0x8129;
const GLuint GL_GENERATE_MIPMAP			= 0x8191;
const GLuint GL_GENERATE_MIPMAP_HINT		= 0x8192;
const GLuint GL_DEPTH_COMPONENT16		= 0x81A5;
const GLuint GL_DEPTH_COMPONENT24		= 0x81A6;
const GLuint GL_DEPTH_COMPONENT32		= 0x81A7;
const GLuint GL_MIRRORED_REPEAT			= 0x8370;
const GLuint GL_FOG_COORDINATE_SOURCE		= 0x8450;
const GLuint GL_FOG_COORDINATE			= 0x8451;
const GLuint GL_FRAGMENT_DEPTH			= 0x8452;
const GLuint GL_CURRENT_FOG_COORDINATE		= 0x8453;
const GLuint GL_FOG_COORDINATE_ARRAY_TYPE	= 0x8454;
const GLuint GL_FOG_COORDINATE_ARRAY_STRIDE	= 0x8455;
const GLuint GL_FOG_COORDINATE_ARRAY_POINTER	= 0x8456;
const GLuint GL_FOG_COORDINATE_ARRAY		= 0x8457;
const GLuint GL_COLOR_SUM			= 0x8458;
const GLuint GL_CURRENT_SECONDARY_COLOR		= 0x8459;
const GLuint GL_SECONDARY_COLOR_ARRAY_SIZE	= 0x845A;
const GLuint GL_SECONDARY_COLOR_ARRAY_TYPE	= 0x845B;
const GLuint GL_SECONDARY_COLOR_ARRAY_STRIDE	= 0x845C;
const GLuint GL_SECONDARY_COLOR_ARRAY_POINTER	= 0x845D;
const GLuint GL_SECONDARY_COLOR_ARRAY		= 0x845E;
const GLuint GL_MAX_TEXTURE_LOD_BIAS		= 0x84FD;
const GLuint GL_TEXTURE_FILTER_CONTROL		= 0x8500;
const GLuint GL_TEXTURE_LOD_BIAS		= 0x8501;
const GLuint GL_INCR_WRAP			= 0x8507;
const GLuint GL_DECR_WRAP			= 0x8508;
const GLuint GL_TEXTURE_DEPTH_SIZE		= 0x884A;
const GLuint GL_DEPTH_TEXTURE_MODE		= 0x884B;
const GLuint GL_TEXTURE_COMPARE_MODE		= 0x884C;
const GLuint GL_TEXTURE_COMPARE_FUNC		= 0x884D;
const GLuint GL_COMPARE_R_TO_TEXTURE		= 0x884E;

// OpenGL 1.5
const GLuint GL_BUFFER_SIZE			= 0x8764;
const GLuint GL_BUFFER_USAGE			= 0x8765;
const GLuint GL_QUERY_COUNTER_BITS		= 0x8864;
const GLuint GL_CURRENT_QUERY			= 0x8865;
const GLuint GL_QUERY_RESULT			= 0x8866;
const GLuint GL_QUERY_RESULT_AVAILABLE		= 0x8867;
const GLuint GL_ARRAY_BUFFER			= 0x8892;
const GLuint GL_ELEMENT_ARRAY_BUFFER		= 0x8893;
const GLuint GL_ARRAY_BUFFER_BINDING		= 0x8894;
const GLuint GL_ELEMENT_ARRAY_BUFFER_BINDING	= 0x8895;
const GLuint GL_VERTEX_ARRAY_BUFFER_BINDING	= 0x8896;
const GLuint GL_NORMAL_ARRAY_BUFFER_BINDING	= 0x8897;
const GLuint GL_COLOR_ARRAY_BUFFER_BINDING	= 0x8898;
const GLuint GL_INDEX_ARRAY_BUFFER_BINDING	= 0x8899;
const GLuint GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING= 0x889A;
const GLuint GL_EDGE_FLAG_ARRAY_BUFFER_BINDING	= 0x889B;
const GLuint GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING= 0x889C;
const GLuint GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING= 0x889D;
const GLuint GL_WEIGHT_ARRAY_BUFFER_BINDING	= 0x889E;
const GLuint GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING= 0x889F;
const GLuint GL_READ_ONLY			= 0x88B8;
const GLuint GL_WRITE_ONLY			= 0x88B9;
const GLuint GL_READ_WRITE			= 0x88BA;
const GLuint GL_BUFFER_ACCESS			= 0x88BB;
const GLuint GL_BUFFER_MAPPED			= 0x88BC;
const GLuint GL_BUFFER_MAP_POINTER		= 0x88BD;
const GLuint GL_STREAM_DRAW			= 0x88E0;
const GLuint GL_STREAM_READ			= 0x88E1;
const GLuint GL_STREAM_COPY			= 0x88E2;
const GLuint GL_STATIC_DRAW			= 0x88E4;
const GLuint GL_STATIC_READ			= 0x88E5;
const GLuint GL_STATIC_COPY			= 0x88E6;
const GLuint GL_DYNAMIC_DRAW			= 0x88E8;
const GLuint GL_DYNAMIC_READ			= 0x88E9;
const GLuint GL_DYNAMIC_COPY			= 0x88EA;
const GLuint GL_SAMPLES_PASSED			= 0x8914;
const GLuint GL_FOG_COORD_SRC			= GL_FOG_COORDINATE_SOURCE;
const GLuint GL_FOG_COORD			= GL_FOG_COORDINATE;
const GLuint GL_CURRENT_FOG_COORD		= GL_CURRENT_FOG_COORDINATE;
const GLuint GL_FOG_COORD_ARRAY_TYPE		= GL_FOG_COORDINATE_ARRAY_TYPE;
const GLuint GL_FOG_COORD_ARRAY_STRIDE		= GL_FOG_COORDINATE_ARRAY_STRIDE;
const GLuint GL_FOG_COORD_ARRAY_POINTER		= GL_FOG_COORDINATE_ARRAY_POINTER;
const GLuint GL_FOG_COORD_ARRAY			= GL_FOG_COORDINATE_ARRAY;
const GLuint GL_FOG_COORD_ARRAY_BUFFER_BINDING	= GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING;
const GLuint GL_SRC0_RGB			= GL_SOURCE0_RGB;
const GLuint GL_SRC1_RGB			= GL_SOURCE1_RGB;
const GLuint GL_SRC2_RGB			= GL_SOURCE2_RGB;
const GLuint GL_SRC0_ALPHA			= GL_SOURCE0_ALPHA;
const GLuint GL_SRC1_ALPHA			= GL_SOURCE1_ALPHA;
const GLuint GL_SRC2_ALPHA			= GL_SOURCE2_ALPHA;

// OpenGL 2.0
const GLuint GL_BLEND_EQUATION_RGB		= 0x8009;
const GLuint GL_VERTEX_ATTRIB_ARRAY_ENABLED	= 0x8622;
const GLuint GL_VERTEX_ATTRIB_ARRAY_SIZE	= 0x8623;
const GLuint GL_VERTEX_ATTRIB_ARRAY_STRIDE	= 0x8624;
const GLuint GL_VERTEX_ATTRIB_ARRAY_TYPE	= 0x8625;
const GLuint GL_CURRENT_VERTEX_ATTRIB		= 0x8626;
const GLuint GL_VERTEX_PROGRAM_POINT_SIZE	= 0x8642;
const GLuint GL_VERTEX_PROGRAM_TWO_SIDE		= 0x8643;
const GLuint GL_VERTEX_ATTRIB_ARRAY_POINTER	= 0x8645;
const GLuint GL_STENCIL_BACK_FUNC		= 0x8800;
const GLuint GL_STENCIL_BACK_FAIL		= 0x8801;
const GLuint GL_STENCIL_BACK_PASS_DEPTH_FAIL	= 0x8802;
const GLuint GL_STENCIL_BACK_PASS_DEPTH_PASS	= 0x8803;
const GLuint GL_MAX_DRAW_BUFFERS		= 0x8824;
const GLuint GL_DRAW_BUFFER0			= 0x8825;
const GLuint GL_DRAW_BUFFER1			= 0x8826;
const GLuint GL_DRAW_BUFFER2			= 0x8827;
const GLuint GL_DRAW_BUFFER3			= 0x8828;
const GLuint GL_DRAW_BUFFER4			= 0x8829;
const GLuint GL_DRAW_BUFFER5			= 0x882A;
const GLuint GL_DRAW_BUFFER6			= 0x882B;
const GLuint GL_DRAW_BUFFER7			= 0x882C;
const GLuint GL_DRAW_BUFFER8			= 0x882D;
const GLuint GL_DRAW_BUFFER9			= 0x882E;
const GLuint GL_DRAW_BUFFER10			= 0x882F;
const GLuint GL_DRAW_BUFFER11			= 0x8830;
const GLuint GL_DRAW_BUFFER12			= 0x8831;
const GLuint GL_DRAW_BUFFER13			= 0x8832;
const GLuint GL_DRAW_BUFFER14			= 0x8833;
const GLuint GL_DRAW_BUFFER15			= 0x8834;
const GLuint GL_BLEND_EQUATION_ALPHA		= 0x883D;
const GLuint GL_POINT_SPRITE			= 0x8861;
const GLuint GL_COORD_REPLACE			= 0x8862;
const GLuint GL_MAX_VERTEX_ATTRIBS		= 0x8869;
const GLuint GL_VERTEX_ATTRIB_ARRAY_NORMALIZED	= 0x886A;
const GLuint GL_MAX_TEXTURE_COORDS		= 0x8871;
const GLuint GL_MAX_TEXTURE_IMAGE_UNITS		= 0x8872;
const GLuint GL_FRAGMENT_SHADER			= 0x8B30;
const GLuint GL_VERTEX_SHADER			= 0x8B31;
const GLuint GL_MAX_FRAGMENT_UNIFORM_COMPONENTS	= 0x8B49;
const GLuint GL_MAX_VERTEX_UNIFORM_COMPONENTS	= 0x8B4A;
const GLuint GL_MAX_VARYING_FLOATS		= 0x8B4B;
const GLuint GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS	= 0x8B4C;
const GLuint GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS= 0x8B4D;
const GLuint GL_SHADER_TYPE			= 0x8B4F;
const GLuint GL_FLOAT_VEC2			= 0x8B50;
const GLuint GL_FLOAT_VEC3			= 0x8B51;
const GLuint GL_FLOAT_VEC4			= 0x8B52;
const GLuint GL_INT_VEC2			= 0x8B53;
const GLuint GL_INT_VEC3			= 0x8B54;
const GLuint GL_INT_VEC4			= 0x8B55;
const GLuint GL_BOOL				= 0x8B56;
const GLuint GL_BOOL_VEC2			= 0x8B57;
const GLuint GL_BOOL_VEC3			= 0x8B58;
const GLuint GL_BOOL_VEC4			= 0x8B59;
const GLuint GL_FLOAT_MAT2			= 0x8B5A;
const GLuint GL_FLOAT_MAT3			= 0x8B5B;
const GLuint GL_FLOAT_MAT4			= 0x8B5C;
const GLuint GL_SAMPLER_1D			= 0x8B5D;
const GLuint GL_SAMPLER_2D			= 0x8B5E;
const GLuint GL_SAMPLER_3D			= 0x8B5F;
const GLuint GL_SAMPLER_CUBE			= 0x8B60;
const GLuint GL_SAMPLER_1D_SHADOW		= 0x8B61;
const GLuint GL_SAMPLER_2D_SHADOW		= 0x8B62;
const GLuint GL_DELETE_STATUS			= 0x8B80;
const GLuint GL_COMPILE_STATUS			= 0x8B81;
const GLuint GL_LINK_STATUS			= 0x8B82;
const GLuint GL_VALIDATE_STATUS			= 0x8B83;
const GLuint GL_INFO_LOG_LENGTH			= 0x8B84;
const GLuint GL_ATTACHED_SHADERS		= 0x8B85;
const GLuint GL_ACTIVE_UNIFORMS			= 0x8B86;
const GLuint GL_ACTIVE_UNIFORM_MAX_LENGTH	= 0x8B87;
const GLuint GL_SHADER_SOURCE_LENGTH		= 0x8B88;
const GLuint GL_ACTIVE_ATTRIBUTES		= 0x8B89;
const GLuint GL_ACTIVE_ATTRIBUTE_MAX_LENGTH	= 0x8B8A;
const GLuint GL_FRAGMENT_SHADER_DERIVATIVE_HINT	= 0x8B8B;
const GLuint GL_SHADING_LANGUAGE_VERSION	= 0x8B8C;
const GLuint GL_CURRENT_PROGRAM			= 0x8B8D;
const GLuint GL_POINT_SPRITE_COORD_ORIGIN	= 0x8CA0;
const GLuint GL_LOWER_LEFT			= 0x8CA1;
const GLuint GL_UPPER_LEFT			= 0x8CA2;
const GLuint GL_STENCIL_BACK_REF		= 0x8CA3;
const GLuint GL_STENCIL_BACK_VALUE_MASK		= 0x8CA4;
const GLuint GL_STENCIL_BACK_WRITEMASK		= 0x8CA5;

// ARB_Imaging
const GLuint GL_CONSTANT_COLOR			= 0x8001;
const GLuint GL_ONE_MINUS_CONSTANT_COLOR	= 0x8002;
const GLuint GL_CONSTANT_ALPHA			= 0x8003;
const GLuint GL_ONE_MINUS_CONSTANT_ALPHA	= 0x8004;
const GLuint GL_BLEND_COLOR			= 0x8005;
const GLuint GL_FUNC_ADD			= 0x8006;
const GLuint GL_MIN				= 0x8007;
const GLuint GL_MAX				= 0x8008;
const GLuint GL_BLEND_EQUATION			= 0x8009;
const GLuint GL_FUNC_SUBTRACT			= 0x800A;
const GLuint GL_FUNC_REVERSE_SUBTRACT		= 0x800B;
const GLuint GL_CONVOLUTION_1D			= 0x8010;
const GLuint GL_CONVOLUTION_2D			= 0x8011;
const GLuint GL_SEPARABLE_2D			= 0x8012;
const GLuint GL_CONVOLUTION_BORDER_MODE		= 0x8013;
const GLuint GL_CONVOLUTION_FILTER_SCALE	= 0x8014;
const GLuint GL_CONVOLUTION_FILTER_BIAS		= 0x8015;
const GLuint GL_REDUCE				= 0x8016;
const GLuint GL_CONVOLUTION_FORMAT		= 0x8017;
const GLuint GL_CONVOLUTION_WIDTH		= 0x8018;
const GLuint GL_CONVOLUTION_HEIGHT		= 0x8019;
const GLuint GL_MAX_CONVOLUTION_WIDTH		= 0x801A;
const GLuint GL_MAX_CONVOLUTION_HEIGHT		= 0x801B;
const GLuint GL_POST_CONVOLUTION_RED_SCALE	= 0x801C;
const GLuint GL_POST_CONVOLUTION_GREEN_SCALE	= 0x801D;
const GLuint GL_POST_CONVOLUTION_BLUE_SCALE	= 0x801E;
const GLuint GL_POST_CONVOLUTION_ALPHA_SCALE	= 0x801F;
const GLuint GL_POST_CONVOLUTION_RED_BIAS	= 0x8020;
const GLuint GL_POST_CONVOLUTION_GREEN_BIAS	= 0x8021;
const GLuint GL_POST_CONVOLUTION_BLUE_BIAS	= 0x8022;
const GLuint GL_POST_CONVOLUTION_ALPHA_BIAS	= 0x8023;
const GLuint GL_HISTOGRAM			= 0x8024;
const GLuint GL_PROXY_HISTOGRAM			= 0x8025;
const GLuint GL_HISTOGRAM_WIDTH			= 0x8026;
const GLuint GL_HISTOGRAM_FORMAT		= 0x8027;
const GLuint GL_HISTOGRAM_RED_SIZE		= 0x8028;
const GLuint GL_HISTOGRAM_GREEN_SIZE		= 0x8029;
const GLuint GL_HISTOGRAM_BLUE_SIZE		= 0x802A;
const GLuint GL_HISTOGRAM_ALPHA_SIZE		= 0x802B;
const GLuint GL_HISTOGRAM_LUMINANCE_SIZE	= 0x802C;
const GLuint GL_HISTOGRAM_SINK			= 0x802D;
const GLuint GL_MINMAX				= 0x802E;
const GLuint GL_MINMAX_FORMAT			= 0x802F;
const GLuint GL_MINMAX_SINK			= 0x8030;
const GLuint GL_TABLE_TOO_LARGE			= 0x8031;
const GLuint GL_COLOR_MATRIX			= 0x80B1;
const GLuint GL_COLOR_MATRIX_STACK_DEPTH	= 0x80B2;
const GLuint GL_MAX_COLOR_MATRIX_STACK_DEPTH	= 0x80B3;
const GLuint GL_POST_COLOR_MATRIX_RED_SCALE	= 0x80B4;
const GLuint GL_POST_COLOR_MATRIX_GREEN_SCALE	= 0x80B5;
const GLuint GL_POST_COLOR_MATRIX_BLUE_SCALE	= 0x80B6;
const GLuint GL_POST_COLOR_MATRIX_ALPHA_SCALE	= 0x80B7;
const GLuint GL_POST_COLOR_MATRIX_RED_BIAS	= 0x80B8;
const GLuint GL_POST_COLOR_MATRIX_GREEN_BIAS	= 0x80B9;
const GLuint GL_POST_COLOR_MATRIX_BLUE_BIAS	= 0x80BA;
const GLuint GL_POST_COLOR_MATRIX_ALPHA_BIAS	= 0x80BB;
const GLuint GL_COLOR_TABLE			= 0x80D0;
const GLuint GL_POST_CONVOLUTION_COLOR_TABLE	= 0x80D1;
const GLuint GL_POST_COLOR_MATRIX_COLOR_TABLE	= 0x80D2;
const GLuint GL_PROXY_COLOR_TABLE		= 0x80D3;
const GLuint GL_PROXY_POST_CONVOLUTION_COLOR_TABLE= 0x80D4;
const GLuint GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE= 0x80D5;
const GLuint GL_COLOR_TABLE_SCALE		= 0x80D6;
const GLuint GL_COLOR_TABLE_BIAS		= 0x80D7;
const GLuint GL_COLOR_TABLE_FORMAT		= 0x80D8;
const GLuint GL_COLOR_TABLE_WIDTH		= 0x80D9;
const GLuint GL_COLOR_TABLE_RED_SIZE		= 0x80DA;
const GLuint GL_COLOR_TABLE_GREEN_SIZE		= 0x80DB;
const GLuint GL_COLOR_TABLE_BLUE_SIZE		= 0x80DC;
const GLuint GL_COLOR_TABLE_ALPHA_SIZE		= 0x80DD;
const GLuint GL_COLOR_TABLE_LUMINANCE_SIZE	= 0x80DE;
const GLuint GL_COLOR_TABLE_INTENSITY_SIZE	= 0x80DF;
const GLuint GL_CONSTANT_BORDER			= 0x8151;
const GLuint GL_REPLICATE_BORDER		= 0x8153;
const GLuint GL_CONVOLUTION_BORDER_COLOR	= 0x8154;

/*
 * Types
 */
alias uint	GLenum;
alias ubyte	GLboolean;
alias uint	GLbitfield;
alias void	GLvoid;
alias byte	GLbyte;
alias short	GLshort;
alias int	GLint;
alias ubyte	GLubyte;
alias ushort	GLushort;
alias uint	GLuint;
alias int	GLsizei;
alias float	GLfloat;
alias float	GLclampf;
alias double	GLdouble;
alias double	GLclampd;
alias char	GLchar;
alias ptrdiff_t	GLintptr;
alias ptrdiff_t	GLsizeiptr;

/*
 * Functions
 */
version(Rulada)
{
SharedLib gldrv;

private void* getProc (char[] procname)
{
	void* symbol;
	try
	{
		symbol = gldrv.getSymbol( stringz.toStringz(procname) );
	}
	catch(SharedLibException)
	{
		debug(OpenGLLoader) Trace.formatln("Failed to load OpenGL proc address " ~ procname ~ ".");
	}
	return symbol;
}

}
else //Phobos
{
private HXModule gldrv;

private void* getProc (char[] procname) {
	void* symbol = ExeModule_GetSymbol(gldrv, procname);
	if (symbol is null) {
		//printf (("Failed to load OpenGL proc address " ~ procname ~ ".\n\0").ptr);
	}
	return symbol;
}

}

static this () {

version(Rulada)
{
	version (Windows)
	{
		gldrv = SharedLib.load("OpenGL32.dll");
	}
	else version (linux)
	{
		gldrv = SharedLib.load("libGL.so");
	}
	else version (darwin)
	{
		try
		{
			//gldrv = SharedLib.load("/System/Library/Frameworks/OpenGL.framework/Libraries/libGL.dylib");
			gldrv = SharedLib.load("/System/Library/Frameworks/OpenGL.framework/OpenGL/");
		}
		catch(SharedLibException)
		{
			throw new Exception("Library load failed: /System/Library/Frameworks/OpenGL.framework/Libraries/libGL.dylib");
		}
	}
}
else //Phobos
{
	version (Windows) {
		gldrv = ExeModule_Load("OpenGL32.dll");
	} else version (linux) {
		gldrv = ExeModule_Load("libGL.so");
	} else version (darwin) {
		gldrv = ExeModule_Load("/System/Library/Frameworks/OpenGL.framework/Libraries/libGL.dylib");
	}
}
	glClearIndex = cast(pfglClearIndex)getProc("glClearIndex");
	glClearColor = cast(pfglClearColor)getProc("glClearColor");
	glClear = cast(pfglClear)getProc("glClear");
	glIndexMask = cast(pfglIndexMask)getProc("glIndexMask");
	glColorMask = cast(pfglColorMask)getProc("glColorMask");
	glAlphaFunc = cast(pfglAlphaFunc)getProc("glAlphaFunc");
	glBlendFunc = cast(pfglBlendFunc)getProc("glBlendFunc");
	glLogicOp = cast(pfglLogicOp)getProc("glLogicOp");
	glCullFace = cast(pfglCullFace)getProc("glCullFace");
	glFrontFace = cast(pfglFrontFace)getProc("glFrontFace");
	glPointSize = cast(pfglPointSize)getProc("glPointSize");
	glLineWidth = cast(pfglLineWidth)getProc("glLineWidth");
	glLineStipple = cast(pfglLineStipple)getProc("glLineStipple");
	glPolygonMode = cast(pfglPolygonMode)getProc("glPolygonMode");
	glPolygonOffset = cast(pfglPolygonOffset)getProc("glPolygonOffset");
	glPolygonStipple = cast(pfglPolygonStipple)getProc("glPolygonStipple");
	glGetPolygonStipple = cast(pfglGetPolygonStipple)getProc("glGetPolygonStipple");
	glEdgeFlag = cast(pfglEdgeFlag)getProc("glEdgeFlag");
	glEdgeFlagv = cast(pfglEdgeFlagv)getProc("glEdgeFlagv");
	glScissor = cast(pfglScissor)getProc("glScissor");
	glClipPlane = cast(pfglClipPlane)getProc("glClipPlane");
	glGetClipPlane = cast(pfglGetClipPlane)getProc("glGetClipPlane");
	glDrawBuffer = cast(pfglDrawBuffer)getProc("glDrawBuffer");
	glReadBuffer = cast(pfglReadBuffer)getProc("glReadBuffer");
	glEnable = cast(pfglEnable)getProc("glEnable");
	glDisable = cast(pfglDisable)getProc("glDisable");
	glIsEnabled = cast(pfglIsEnabled)getProc("glIsEnabled");
	glEnableClientState = cast(pfglEnableClientState)getProc("glEnableClientState");
	glDisableClientState = cast(pfglDisableClientState)getProc("glDisableClientState");
	glGetBooleanv = cast(pfglGetBooleanv)getProc("glGetBooleanv");
	glGetDoublev = cast(pfglGetDoublev)getProc("glGetDoublev");
	glGetFloatv = cast(pfglGetFloatv)getProc("glGetFloatv");
	glGetIntegerv = cast(pfglGetIntegerv)getProc("glGetIntegerv");
	glPushAttrib = cast(pfglPushAttrib)getProc("glPushAttrib");
	glPopAttrib = cast(pfglPopAttrib)getProc("glPopAttrib");
	glPushClientAttrib = cast(pfglPushClientAttrib)getProc("glPushClientAttrib");
	glPopClientAttrib = cast(pfglPopClientAttrib)getProc("glPopClientAttrib");
	glRenderMode = cast(pfglRenderMode)getProc("glRenderMode");
	glGetError = cast(pfglGetError)getProc("glGetError");
	glGetString = cast(pfglGetString)getProc("glGetString");
	glFinish = cast(pfglFinish)getProc("glFinish");
	glFlush = cast(pfglFlush)getProc("glFlush");
	glHint = cast(pfglHint)getProc("glHint");

	glClearDepth = cast(pfglClearDepth)getProc("glClearDepth");
	glDepthFunc = cast(pfglDepthFunc)getProc("glDepthFunc");
	glDepthMask = cast(pfglDepthMask)getProc("glDepthMask");
	glDepthRange = cast(pfglDepthRange)getProc("glDepthRange");

	glClearAccum = cast(pfglClearAccum)getProc("glClearAccum");
	glAccum = cast(pfglAccum)getProc("glAccum");

	glMatrixMode = cast(pfglMatrixMode)getProc("glMatrixMode");
	glOrtho = cast(pfglOrtho)getProc("glOrtho");
	glFrustum = cast(pfglFrustum)getProc("glFrustum");
	glViewport = cast(pfglViewport)getProc("glViewport");
	glPushMatrix = cast(pfglPushMatrix)getProc("glPushMatrix");
	glPopMatrix = cast(pfglPopMatrix)getProc("glPopMatrix");
	glLoadIdentity = cast(pfglLoadIdentity)getProc("glLoadIdentity");
	glLoadMatrixd = cast(pfglLoadMatrixd)getProc("glLoadMatrixd");
	glLoadMatrixf = cast(pfglLoadMatrixf)getProc("glLoadMatrixf");
	glMultMatrixd = cast(pfglMultMatrixd)getProc("glMultMatrixd");
	glMultMatrixf = cast(pfglMultMatrixf)getProc("glMultMatrixf");
	glRotated = cast(pfglRotated)getProc("glRotated");
	glRotatef = cast(pfglRotatef)getProc("glRotatef");
	glScaled = cast(pfglScaled)getProc("glScaled");
	glScalef = cast(pfglScalef)getProc("glScalef");
	glTranslated = cast(pfglTranslated)getProc("glTranslated");
	glTranslatef = cast(pfglTranslatef)getProc("glTranslatef");

	glIsList = cast(pfglIsList)getProc("glIsList");
	glDeleteLists = cast(pfglDeleteLists)getProc("glDeleteLists");
	glGenLists = cast(pfglGenLists)getProc("glGenLists");
	glNewList = cast(pfglNewList)getProc("glNewList");
	glEndList = cast(pfglEndList)getProc("glEndList");
	glCallList = cast(pfglCallList)getProc("glCallList");
	glCallLists = cast(pfglCallLists)getProc("glCallLists");
	glListBase = cast(pfglListBase)getProc("glListBase");

	glBegin = cast(pfglBegin)getProc("glBegin");
	glEnd = cast(pfglEnd)getProc("glEnd");
	glVertex2d = cast(pfglVertex2d)getProc("glVertex2d");
	glVertex2f = cast(pfglVertex2f)getProc("glVertex2f");
	glVertex2i = cast(pfglVertex2i)getProc("glVertex2i");
	glVertex2s = cast(pfglVertex2s)getProc("glVertex2s");
	glVertex3d = cast(pfglVertex3d)getProc("glVertex3d");
	glVertex3f = cast(pfglVertex3f)getProc("glVertex3f");
	glVertex3i = cast(pfglVertex3i)getProc("glVertex3i");
	glVertex3s = cast(pfglVertex3s)getProc("glVertex3s");
	glVertex4d = cast(pfglVertex4d)getProc("glVertex4d");
	glVertex4f = cast(pfglVertex4f)getProc("glVertex4f");
	glVertex4i = cast(pfglVertex4i)getProc("glVertex4i");
	glVertex4s = cast(pfglVertex4s)getProc("glVertex4s");
	glVertex2dv = cast(pfglVertex2dv)getProc("glVertex2dv");
	glVertex2fv = cast(pfglVertex2fv)getProc("glVertex2fv");
	glVertex2iv = cast(pfglVertex2iv)getProc("glVertex2iv");
	glVertex2sv = cast(pfglVertex2sv)getProc("glVertex2sv");
	glVertex3dv = cast(pfglVertex3dv)getProc("glVertex3dv");
	glVertex3fv = cast(pfglVertex3fv)getProc("glVertex3fv");
	glVertex3iv = cast(pfglVertex3iv)getProc("glVertex3iv");
	glVertex3sv = cast(pfglVertex3sv)getProc("glVertex3sv");
	glVertex4dv = cast(pfglVertex4dv)getProc("glVertex4dv");
	glVertex4fv = cast(pfglVertex4fv)getProc("glVertex4fv");
	glVertex4iv = cast(pfglVertex4iv)getProc("glVertex4iv");
	glVertex4sv = cast(pfglVertex4sv)getProc("glVertex4sv");
	glNormal3b = cast(pfglNormal3b)getProc("glNormal3b");
	glNormal3d = cast(pfglNormal3d)getProc("glNormal3d");
	glNormal3f = cast(pfglNormal3f)getProc("glNormal3f");
	glNormal3i = cast(pfglNormal3i)getProc("glNormal3i");
	glNormal3s = cast(pfglNormal3s)getProc("glNormal3s");
	glNormal3bv = cast(pfglNormal3bv)getProc("glNormal3bv");
	glNormal3dv = cast(pfglNormal3dv)getProc("glNormal3dv");
	glNormal3fv = cast(pfglNormal3fv)getProc("glNormal3fv");
	glNormal3iv = cast(pfglNormal3iv)getProc("glNormal3iv");
	glNormal3sv = cast(pfglNormal3sv)getProc("glNormal3sv");
	glIndexd = cast(pfglIndexd)getProc("glIndexd");
	glIndexf = cast(pfglIndexf)getProc("glIndexf");
	glIndexi = cast(pfglIndexi)getProc("glIndexi");
	glIndexs = cast(pfglIndexs)getProc("glIndexs");
	glIndexub = cast(pfglIndexub)getProc("glIndexub");
	glIndexdv = cast(pfglIndexdv)getProc("glIndexdv");
	glIndexfv = cast(pfglIndexfv)getProc("glIndexfv");
	glIndexiv = cast(pfglIndexiv)getProc("glIndexiv");
	glIndexsv = cast(pfglIndexsv)getProc("glIndexsv");
	glIndexubv = cast(pfglIndexubv)getProc("glIndexubv");
	glColor3b = cast(pfglColor3b)getProc("glColor3b");
	glColor3d = cast(pfglColor3d)getProc("glColor3d");
	glColor3f = cast(pfglColor3f)getProc("glColor3f");
	glColor3i = cast(pfglColor3i)getProc("glColor3i");
	glColor3s = cast(pfglColor3s)getProc("glColor3s");
	glColor3ub = cast(pfglColor3ub)getProc("glColor3ub");
	glColor3ui = cast(pfglColor3ui)getProc("glColor3ui");
	glColor3us = cast(pfglColor3us)getProc("glColor3us");
	glColor4b = cast(pfglColor4b)getProc("glColor4b");
	glColor4d = cast(pfglColor4d)getProc("glColor4d");
	glColor4f = cast(pfglColor4f)getProc("glColor4f");
	glColor4i = cast(pfglColor4i)getProc("glColor4i");
	glColor4s = cast(pfglColor4s)getProc("glColor4s");
	glColor4ub = cast(pfglColor4ub)getProc("glColor4ub");
	glColor4ui = cast(pfglColor4ui)getProc("glColor4ui");
	glColor4us = cast(pfglColor4us)getProc("glColor4us");
	glColor3bv = cast(pfglColor3bv)getProc("glColor3bv");
	glColor3dv = cast(pfglColor3dv)getProc("glColor3dv");
	glColor3fv = cast(pfglColor3fv)getProc("glColor3fv");
	glColor3iv = cast(pfglColor3iv)getProc("glColor3iv");
	glColor3sv = cast(pfglColor3sv)getProc("glColor3sv");
	glColor3ubv = cast(pfglColor3ubv)getProc("glColor3ubv");
	glColor3uiv = cast(pfglColor3uiv)getProc("glColor3uiv");
	glColor3usv = cast(pfglColor3usv)getProc("glColor3usv");
	glColor4bv = cast(pfglColor4bv)getProc("glColor4bv");
	glColor4dv = cast(pfglColor4dv)getProc("glColor4dv");
	glColor4fv = cast(pfglColor4fv)getProc("glColor4fv");
	glColor4iv = cast(pfglColor4iv)getProc("glColor4iv");
	glColor4sv = cast(pfglColor4sv)getProc("glColor4sv");
	glColor4ubv = cast(pfglColor4ubv)getProc("glColor4ubv");
	glColor4uiv = cast(pfglColor4uiv)getProc("glColor4uiv");
	glColor4usv = cast(pfglColor4usv)getProc("glColor4usv");
	glTexCoord1d = cast(pfglTexCoord1d)getProc("glTexCoord1d");
	glTexCoord1f = cast(pfglTexCoord1f)getProc("glTexCoord1f");
	glTexCoord1i = cast(pfglTexCoord1i)getProc("glTexCoord1i");
	glTexCoord1s = cast(pfglTexCoord1s)getProc("glTexCoord1s");
	glTexCoord2d = cast(pfglTexCoord2d)getProc("glTexCoord2d");
	glTexCoord2f = cast(pfglTexCoord2f)getProc("glTexCoord2f");
	glTexCoord2i = cast(pfglTexCoord2i)getProc("glTexCoord2i");
	glTexCoord2s = cast(pfglTexCoord2s)getProc("glTexCoord2s");
	glTexCoord3d = cast(pfglTexCoord3d)getProc("glTexCoord3d");
	glTexCoord3f = cast(pfglTexCoord3f)getProc("glTexCoord3f");
	glTexCoord3i = cast(pfglTexCoord3i)getProc("glTexCoord3i");
	glTexCoord3s = cast(pfglTexCoord3s)getProc("glTexCoord3s");
	glTexCoord4d = cast(pfglTexCoord4d)getProc("glTexCoord4d");
	glTexCoord4f = cast(pfglTexCoord4f)getProc("glTexCoord4f");
	glTexCoord4i = cast(pfglTexCoord4i)getProc("glTexCoord4i");
	glTexCoord4s = cast(pfglTexCoord4s)getProc("glTexCoord4s");
	glTexCoord1dv = cast(pfglTexCoord1dv)getProc("glTexCoord1dv");
	glTexCoord1fv = cast(pfglTexCoord1fv)getProc("glTexCoord1fv");
	glTexCoord1iv = cast(pfglTexCoord1iv)getProc("glTexCoord1iv");
	glTexCoord1sv = cast(pfglTexCoord1sv)getProc("glTexCoord1sv");
	glTexCoord2dv = cast(pfglTexCoord2dv)getProc("glTexCoord2dv");
	glTexCoord2fv = cast(pfglTexCoord2fv)getProc("glTexCoord2fv");
	glTexCoord2iv = cast(pfglTexCoord2iv)getProc("glTexCoord2iv");
	glTexCoord2sv = cast(pfglTexCoord2sv)getProc("glTexCoord2sv");
	glTexCoord3dv = cast(pfglTexCoord3dv)getProc("glTexCoord3dv");
	glTexCoord3fv = cast(pfglTexCoord3fv)getProc("glTexCoord3fv");
	glTexCoord3iv = cast(pfglTexCoord3iv)getProc("glTexCoord3iv");
	glTexCoord3sv = cast(pfglTexCoord3sv)getProc("glTexCoord3sv");
	glTexCoord4dv = cast(pfglTexCoord4dv)getProc("glTexCoord4dv");
	glTexCoord4fv = cast(pfglTexCoord4fv)getProc("glTexCoord4fv");
	glTexCoord4iv = cast(pfglTexCoord4iv)getProc("glTexCoord4iv");
	glTexCoord4sv = cast(pfglTexCoord4sv)getProc("glTexCoord4sv");
	glRasterPos2d = cast(pfglRasterPos2d)getProc("glRasterPos2d");
	glRasterPos2f = cast(pfglRasterPos2f)getProc("glRasterPos2f");
	glRasterPos2i = cast(pfglRasterPos2i)getProc("glRasterPos2i");
	glRasterPos2s = cast(pfglRasterPos2s)getProc("glRasterPos2s");
	glRasterPos3d = cast(pfglRasterPos3d)getProc("glRasterPos3d");
	glRasterPos3f = cast(pfglRasterPos3f)getProc("glRasterPos3f");
	glRasterPos3i = cast(pfglRasterPos3i)getProc("glRasterPos3i");
	glRasterPos3s = cast(pfglRasterPos3s)getProc("glRasterPos3s");
	glRasterPos4d = cast(pfglRasterPos4d)getProc("glRasterPos4d");
	glRasterPos4f = cast(pfglRasterPos4f)getProc("glRasterPos4f");
	glRasterPos4i = cast(pfglRasterPos4i)getProc("glRasterPos4i");
	glRasterPos4s = cast(pfglRasterPos4s)getProc("glRasterPos4s");
	glRasterPos2dv = cast(pfglRasterPos2dv)getProc("glRasterPos2dv");
	glRasterPos2fv = cast(pfglRasterPos2fv)getProc("glRasterPos2fv");
	glRasterPos2iv = cast(pfglRasterPos2iv)getProc("glRasterPos2iv");
	glRasterPos2sv = cast(pfglRasterPos2sv)getProc("glRasterPos2sv");
	glRasterPos3dv = cast(pfglRasterPos3dv)getProc("glRasterPos3dv");
	glRasterPos3fv = cast(pfglRasterPos3fv)getProc("glRasterPos3fv");
	glRasterPos3iv = cast(pfglRasterPos3iv)getProc("glRasterPos3iv");
	glRasterPos3sv = cast(pfglRasterPos3sv)getProc("glRasterPos3sv");
	glRasterPos4dv = cast(pfglRasterPos4dv)getProc("glRasterPos4dv");
	glRasterPos4fv = cast(pfglRasterPos4fv)getProc("glRasterPos4fv");
	glRasterPos4iv = cast(pfglRasterPos4iv)getProc("glRasterPos4iv");
	glRasterPos4sv = cast(pfglRasterPos4sv)getProc("glRasterPos4sv");
	glRectd = cast(pfglRectd)getProc("glRectd");
	glRectf = cast(pfglRectf)getProc("glRectf");
	glRecti = cast(pfglRecti)getProc("glRecti");
	glRects = cast(pfglRects)getProc("glRects");
	glRectdv = cast(pfglRectdv)getProc("glRectdv");
	glRectfv = cast(pfglRectfv)getProc("glRectfv");
	glRectiv = cast(pfglRectiv)getProc("glRectiv");
	glRectsv = cast(pfglRectsv)getProc("glRectsv");

	glVertexPointer = cast(pfglVertexPointer)getProc("glVertexPointer");
	glNormalPointer = cast(pfglNormalPointer)getProc("glNormalPointer");
	glColorPointer = cast(pfglColorPointer)getProc("glColorPointer");
	glIndexPointer = cast(pfglIndexPointer)getProc("glIndexPointer");
	glTexCoordPointer = cast(pfglTexCoordPointer)getProc("glTexCoordPointer");
	glEdgeFlagPointer = cast(pfglEdgeFlagPointer)getProc("glEdgeFlagPointer");
	glGetPointerv = cast(pfglGetPointerv)getProc("glGetPointerv");
	glArrayElement = cast(pfglArrayElement)getProc("glArrayElement");
	glDrawArrays = cast(pfglDrawArrays)getProc("glDrawArrays");
	glDrawElements = cast(pfglDrawElements)getProc("glDrawElements");
	glInterleavedArrays = cast(pfglInterleavedArrays)getProc("glInterleavedArrays");

	glShadeModel = cast(pfglShadeModel)getProc("glShadeModel");
	glLightf = cast(pfglLightf)getProc("glLightf");
	glLighti = cast(pfglLighti)getProc("glLighti");
	glLightfv = cast(pfglLightfv)getProc("glLightfv");
	glLightiv = cast(pfglLightiv)getProc("glLightiv");
	glGetLightfv = cast(pfglGetLightfv)getProc("glGetLightfv");
	glGetLightiv = cast(pfglGetLightiv)getProc("glGetLightiv");
	glLightModelf = cast(pfglLightModelf)getProc("glLightModelf");
	glLightModeli = cast(pfglLightModeli)getProc("glLightModeli");
	glLightModelfv = cast(pfglLightModelfv)getProc("glLightModelfv");
	glLightModeliv = cast(pfglLightModeliv)getProc("glLightModeliv");
	glMaterialf = cast(pfglMaterialf)getProc("glMaterialf");
	glMateriali = cast(pfglMateriali)getProc("glMateriali");
	glMaterialfv = cast(pfglMaterialfv)getProc("glMaterialfv");
	glMaterialiv = cast(pfglMaterialiv)getProc("glMaterialiv");
	glGetMaterialfv = cast(pfglGetMaterialfv)getProc("glGetMaterialfv");
	glGetMaterialiv = cast(pfglGetMaterialiv)getProc("glGetMaterialiv");
	glColorMaterial = cast(pfglColorMaterial)getProc("glColorMaterial");

	glPixelZoom = cast(pfglPixelZoom)getProc("glPixelZoom");
	glPixelStoref = cast(pfglPixelStoref)getProc("glPixelStoref");
	glPixelStorei = cast(pfglPixelStorei)getProc("glPixelStorei");
	glPixelTransferf = cast(pfglPixelTransferf)getProc("glPixelTransferf");
	glPixelTransferi = cast(pfglPixelTransferi)getProc("glPixelTransferi");
	glPixelMapfv = cast(pfglPixelMapfv)getProc("glPixelMapfv");
	glPixelMapuiv = cast(pfglPixelMapuiv)getProc("glPixelMapuiv");
	glPixelMapusv = cast(pfglPixelMapusv)getProc("glPixelMapusv");
	glGetPixelMapfv = cast(pfglGetPixelMapfv)getProc("glGetPixelMapfv");
	glGetPixelMapuiv = cast(pfglGetPixelMapuiv)getProc("glGetPixelMapuiv");
	glGetPixelMapusv = cast(pfglGetPixelMapusv)getProc("glGetPixelMapusv");
	glBitmap = cast(pfglBitmap)getProc("glBitmap");
	glReadPixels = cast(pfglReadPixels)getProc("glReadPixels");
	glDrawPixels = cast(pfglDrawPixels)getProc("glDrawPixels");
	glCopyPixels = cast(pfglCopyPixels)getProc("glCopyPixels");

	glStencilFunc = cast(pfglStencilFunc)getProc("glStencilFunc");
	glStencilMask = cast(pfglStencilMask)getProc("glStencilMask");
	glStencilOp = cast(pfglStencilOp)getProc("glStencilOp");
	glClearStencil = cast(pfglClearStencil)getProc("glClearStencil");

	glTexGend = cast(pfglTexGend)getProc("glTexGend");
	glTexGenf = cast(pfglTexGenf)getProc("glTexGenf");
	glTexGeni = cast(pfglTexGeni)getProc("glTexGeni");
	glTexGendv = cast(pfglTexGendv)getProc("glTexGendv");
	glTexGenfv = cast(pfglTexGenfv)getProc("glTexGenfv");
	glTexGeniv = cast(pfglTexGeniv)getProc("glTexGeniv");
	glGetTexGendv = cast(pfglGetTexGendv)getProc("glGetTexGendv");
	glGetTexGenfv = cast(pfglGetTexGenfv)getProc("glGetTexGenfv");
	glGetTexGeniv = cast(pfglGetTexGeniv)getProc("glGetTexGeniv");
	glTexEnvf = cast(pfglTexEnvf)getProc("glTexEnvf");
	glTexEnvi = cast(pfglTexEnvi)getProc("glTexEnvi");
	glTexEnvfv = cast(pfglTexEnvfv)getProc("glTexEnvfv");
	glTexEnviv = cast(pfglTexEnviv)getProc("glTexEnviv");
	glGetTexEnvfv = cast(pfglGetTexEnvfv)getProc("glGetTexEnvfv");
	glGetTexEnviv = cast(pfglGetTexEnviv)getProc("glGetTexEnviv");
	glTexParameterf = cast(pfglTexParameterf)getProc("glTexParameterf");
	glTexParameteri = cast(pfglTexParameteri)getProc("glTexParameteri");
	glTexParameterfv = cast(pfglTexParameterfv)getProc("glTexParameterfv");
	glTexParameteriv = cast(pfglTexParameteriv)getProc("glTexParameteriv");
	glGetTexParameterfv = cast(pfglGetTexParameterfv)getProc("glGetTexParameterfv");
	glGetTexParameteriv = cast(pfglGetTexParameteriv)getProc("glGetTexParameteriv");
	glGetTexLevelParameterfv = cast(pfglGetTexLevelParameterfv)getProc("glGetTexLevelParameterfv");
	glGetTexLevelParameteriv = cast(pfglGetTexLevelParameteriv)getProc("glGetTexLevelParameteriv");
	glTexImage1D = cast(pfglTexImage1D)getProc("glTexImage1D");
	glTexImage2D = cast(pfglTexImage2D)getProc("glTexImage2D");
	glGetTexImage = cast(pfglGetTexImage)getProc("glGetTexImage");

	glMap1d = cast(pfglMap1d)getProc("glMap1d");
	glMap1f = cast(pfglMap1f)getProc("glMap1f");
	glMap2d = cast(pfglMap2d)getProc("glMap2d");
	glMap2f = cast(pfglMap2f)getProc("glMap2f");
	glGetMapdv = cast(pfglGetMapdv)getProc("glGetMapdv");
	glGetMapfv = cast(pfglGetMapfv)getProc("glGetMapfv");
	glGetMapiv = cast(pfglGetMapiv)getProc("glGetMapiv");
	glEvalCoord1d = cast(pfglEvalCoord1d)getProc("glEvalCoord1d");
	glEvalCoord1f = cast(pfglEvalCoord1f)getProc("glEvalCoord1f");
	glEvalCoord1dv = cast(pfglEvalCoord1dv)getProc("glEvalCoord1dv");
	glEvalCoord1fv = cast(pfglEvalCoord1fv)getProc("glEvalCoord1fv");
	glEvalCoord2d = cast(pfglEvalCoord2d)getProc("glEvalCoord2d");
	glEvalCoord2f = cast(pfglEvalCoord2f)getProc("glEvalCoord2f");
	glEvalCoord2dv = cast(pfglEvalCoord2dv)getProc("glEvalCoord2dv");
	glEvalCoord2fv = cast(pfglEvalCoord2fv)getProc("glEvalCoord2fv");
	glMapGrid1d = cast(pfglMapGrid1d)getProc("glMapGrid1d");
	glMapGrid1f = cast(pfglMapGrid1f)getProc("glMapGrid1f");
	glMapGrid2d = cast(pfglMapGrid2d)getProc("glMapGrid2d");
	glMapGrid2f = cast(pfglMapGrid2f)getProc("glMapGrid2f");
	glEvalPoint1 = cast(pfglEvalPoint1)getProc("glEvalPoint1");
	glEvalPoint2 = cast(pfglEvalPoint2)getProc("glEvalPoint2");
	glEvalMesh1 = cast(pfglEvalMesh1)getProc("glEvalMesh1");
	glEvalMesh2 = cast(pfglEvalMesh2)getProc("glEvalMesh2");

	glFogf = cast(pfglFogf)getProc("glFogf");
	glFogi = cast(pfglFogi)getProc("glFogi");
	glFogfv = cast(pfglFogfv)getProc("glFogfv");
	glFogiv = cast(pfglFogiv)getProc("glFogiv");

	glFeedbackBuffer = cast(pfglFeedbackBuffer)getProc("glFeedbackBuffer");
	glPassThrough = cast(pfglPassThrough)getProc("glPassThrough");
	glSelectBuffer = cast(pfglSelectBuffer)getProc("glSelectBuffer");
	glInitNames = cast(pfglInitNames)getProc("glInitNames");
	glLoadName = cast(pfglLoadName)getProc("glLoadName");
	glPushName = cast(pfglPushName)getProc("glPushName");
	glPopName = cast(pfglPopName)getProc("glPopName");

	glGenTextures = cast(pfglGenTextures)getProc("glGenTextures");
	glDeleteTextures = cast(pfglDeleteTextures)getProc("glDeleteTextures");
	glBindTexture = cast(pfglBindTexture)getProc("glBindTexture");
	glPrioritizeTextures = cast(pfglPrioritizeTextures)getProc("glPrioritizeTextures");
	glAreTexturesResident = cast(pfglAreTexturesResident)getProc("glAreTexturesResident");
	glIsTexture = cast(pfglIsTexture)getProc("glIsTexture");
	glTexSubImage1D = cast(pfglTexSubImage1D)getProc("glTexSubImage1D");
	glTexSubImage2D = cast(pfglTexSubImage2D)getProc("glTexSubImage2D");
	glCopyTexImage1D = cast(pfglCopyTexImage1D)getProc("glCopyTexImage1D");
	glCopyTexImage2D = cast(pfglCopyTexImage2D)getProc("glCopyTexImage2D");
	glCopyTexSubImage1D = cast(pfglCopyTexSubImage1D)getProc("glCopyTexSubImage1D");
	glCopyTexSubImage2D = cast(pfglCopyTexSubImage2D)getProc("glCopyTexSubImage2D");

	glDrawRangeElements = cast(pfglDrawRangeElements)getProc("glDrawRangeElements");
	glTexImage3D = cast(pfglTexImage3D)getProc("glTexImage3D");
	glTexSubImage3D = cast(pfglTexSubImage3D)getProc("glTexSubImage3D");
	glCopyTexSubImage3D = cast(pfglCopyTexSubImage3D)getProc("glCopyTexSubImage3D");

	glActiveTexture = cast(pfglActiveTexture)getProc("glActiveTexture");
	glClientActiveTexture = cast(pfglClientActiveTexture)getProc("glClientActiveTexture");
	glMultiTexCoord1d = cast(pfglMultiTexCoord1d)getProc("glMultiTexCoord1d");
	glMultiTexCoord1dv = cast(pfglMultiTexCoord1dv)getProc("glMultiTexCoord1dv");
	glMultiTexCoord1f = cast(pfglMultiTexCoord1f)getProc("glMultiTexCoord1f");
	glMultiTexCoord1fv = cast(pfglMultiTexCoord1fv)getProc("glMultiTexCoord1fv");
	glMultiTexCoord1i = cast(pfglMultiTexCoord1i)getProc("glMultiTexCoord1i");
	glMultiTexCoord1iv = cast(pfglMultiTexCoord1iv)getProc("glMultiTexCoord1iv");
	glMultiTexCoord1s = cast(pfglMultiTexCoord1s)getProc("glMultiTexCoord1s");
	glMultiTexCoord1sv = cast(pfglMultiTexCoord1sv)getProc("glMultiTexCoord1sv");
	glMultiTexCoord2d = cast(pfglMultiTexCoord2d)getProc("glMultiTexCoord2d");
	glMultiTexCoord2dv = cast(pfglMultiTexCoord2dv)getProc("glMultiTexCoord2dv");
	glMultiTexCoord2f = cast(pfglMultiTexCoord2f)getProc("glMultiTexCoord2f");
	glMultiTexCoord2fv = cast(pfglMultiTexCoord2fv)getProc("glMultiTexCoord2fv");
	glMultiTexCoord2i = cast(pfglMultiTexCoord2i)getProc("glMultiTexCoord2i");
	glMultiTexCoord2iv = cast(pfglMultiTexCoord2iv)getProc("glMultiTexCoord2iv");
	glMultiTexCoord2s = cast(pfglMultiTexCoord2s)getProc("glMultiTexCoord2s");
	glMultiTexCoord2sv = cast(pfglMultiTexCoord2sv)getProc("glMultiTexCoord2sv");
	glMultiTexCoord3d = cast(pfglMultiTexCoord3d)getProc("glMultiTexCoord3d");
	glMultiTexCoord3dv = cast(pfglMultiTexCoord3dv)getProc("glMultiTexCoord3dv");
	glMultiTexCoord3f = cast(pfglMultiTexCoord3f)getProc("glMultiTexCoord3f");
	glMultiTexCoord3fv = cast(pfglMultiTexCoord3fv)getProc("glMultiTexCoord3fv");
	glMultiTexCoord3i = cast(pfglMultiTexCoord3i)getProc("glMultiTexCoord3i");
	glMultiTexCoord3iv = cast(pfglMultiTexCoord3iv)getProc("glMultiTexCoord3iv");
	glMultiTexCoord3s = cast(pfglMultiTexCoord3s)getProc("glMultiTexCoord3s");
	glMultiTexCoord3sv = cast(pfglMultiTexCoord3sv)getProc("glMultiTexCoord3sv");
	glMultiTexCoord4d = cast(pfglMultiTexCoord4d)getProc("glMultiTexCoord4d");
	glMultiTexCoord4dv = cast(pfglMultiTexCoord4dv)getProc("glMultiTexCoord4dv");
	glMultiTexCoord4f = cast(pfglMultiTexCoord4f)getProc("glMultiTexCoord4f");
	glMultiTexCoord4fv = cast(pfglMultiTexCoord4fv)getProc("glMultiTexCoord4fv");
	glMultiTexCoord4i = cast(pfglMultiTexCoord4i)getProc("glMultiTexCoord4i");
	glMultiTexCoord4iv = cast(pfglMultiTexCoord4iv)getProc("glMultiTexCoord4iv");
	glMultiTexCoord4s = cast(pfglMultiTexCoord4s)getProc("glMultiTexCoord4s");
	glMultiTexCoord4sv = cast(pfglMultiTexCoord4sv)getProc("glMultiTexCoord4sv");
	glLoadTransposeMatrixd = cast(pfglLoadTransposeMatrixd)getProc("glLoadTransposeMatrixd");
	glLoadTransposeMatrixf = cast(pfglLoadTransposeMatrixf)getProc("glLoadTransposeMatrixf");
	glMultTransposeMatrixd = cast(pfglMultTransposeMatrixd)getProc("glMultTransposeMatrixd");
	glMultTransposeMatrixf = cast(pfglMultTransposeMatrixf)getProc("glMultTransposeMatrixf");
	glSampleCoverage = cast(pfglSampleCoverage)getProc("glSampleCoverage");
	glCompressedTexImage1D = cast(pfglCompressedTexImage1D)getProc("glCompressedTexImage1D");
	glCompressedTexImage2D = cast(pfglCompressedTexImage2D)getProc("glCompressedTexImage2D");
	glCompressedTexImage3D = cast(pfglCompressedTexImage3D)getProc("glCompressedTexImage3D");
	glCompressedTexSubImage1D = cast(pfglCompressedTexSubImage1D)getProc("glCompressedTexSubImage1D");
	glCompressedTexSubImage2D = cast(pfglCompressedTexSubImage2D)getProc("glCompressedTexSubImage2D");
	glCompressedTexSubImage3D = cast(pfglCompressedTexSubImage3D)getProc("glCompressedTexSubImage3D");
	glGetCompressedTexImage = cast(pfglGetCompressedTexImage)getProc("glGetCompressedTexImage");

	glBlendFuncSeparate = cast(pfglBlendFuncSeparate)getProc("glBlendFuncSeparate");
	glFogCoordf = cast(pfglFogCoordf)getProc("glFogCoordf");
	glFogCoordfv = cast(pfglFogCoordfv)getProc("glFogCoordfv");
	glFogCoordd = cast(pfglFogCoordd)getProc("glFogCoordd");
	glFogCoorddv = cast(pfglFogCoorddv)getProc("glFogCoorddv");
	glFogCoordPointer = cast(pfglFogCoordPointer)getProc("glFogCoordPointer");
	glMultiDrawArrays = cast(pfglMultiDrawArrays)getProc("glMultiDrawArrays");
	glMultiDrawElements = cast(pfglMultiDrawElements)getProc("glMultiDrawElements");
	glPointParameterf = cast(pfglPointParameterf)getProc("glPointParameterf");
	glPointParameterfv = cast(pfglPointParameterfv)getProc("glPointParameterfv");
	glPointParameteri = cast(pfglPointParameteri)getProc("glPointParameteri");
	glPointParameteriv = cast(pfglPointParameteriv)getProc("glPointParameteriv");
	glSecondaryColor3b = cast(pfglSecondaryColor3b)getProc("glSecondaryColor3b");
	glSecondaryColor3bv = cast(pfglSecondaryColor3bv)getProc("glSecondaryColor3bv");
	glSecondaryColor3d = cast(pfglSecondaryColor3d)getProc("glSecondaryColor3d");
	glSecondaryColor3dv = cast(pfglSecondaryColor3dv)getProc("glSecondaryColor3dv");
	glSecondaryColor3f = cast(pfglSecondaryColor3f)getProc("glSecondaryColor3f");
	glSecondaryColor3fv = cast(pfglSecondaryColor3fv)getProc("glSecondaryColor3fv");
	glSecondaryColor3i = cast(pfglSecondaryColor3i)getProc("glSecondaryColor3i");
	glSecondaryColor3iv = cast(pfglSecondaryColor3iv)getProc("glSecondaryColor3iv");
	glSecondaryColor3s = cast(pfglSecondaryColor3s)getProc("glSecondaryColor3s");
	glSecondaryColor3sv = cast(pfglSecondaryColor3sv)getProc("glSecondaryColor3sv");
	glSecondaryColor3ub = cast(pfglSecondaryColor3ub)getProc("glSecondaryColor3ub");
	glSecondaryColor3ubv = cast(pfglSecondaryColor3ubv)getProc("glSecondaryColor3ubv");
	glSecondaryColor3ui = cast(pfglSecondaryColor3ui)getProc("glSecondaryColor3ui");
	glSecondaryColor3uiv = cast(pfglSecondaryColor3uiv)getProc("glSecondaryColor3uiv");
	glSecondaryColor3us = cast(pfglSecondaryColor3us)getProc("glSecondaryColor3us");
	glSecondaryColor3usv = cast(pfglSecondaryColor3usv)getProc("glSecondaryColor3usv");
	glSecondaryColorPointer = cast(pfglSecondaryColorPointer)getProc("glSecondaryColorPointer");
	glWindowPos2d = cast(pfglWindowPos2d)getProc("glWindowPos2d");
	glWindowPos2dv = cast(pfglWindowPos2dv)getProc("glWindowPos2dv");
	glWindowPos2f = cast(pfglWindowPos2f)getProc("glWindowPos2f");
	glWindowPos2fv = cast(pfglWindowPos2fv)getProc("glWindowPos2fv");
	glWindowPos2i = cast(pfglWindowPos2i)getProc("glWindowPos2i");
	glWindowPos2iv = cast(pfglWindowPos2iv)getProc("glWindowPos2iv");
	glWindowPos2s = cast(pfglWindowPos2s)getProc("glWindowPos2s");
	glWindowPos2sv = cast(pfglWindowPos2sv)getProc("glWindowPos2sv");
	glWindowPos3d = cast(pfglWindowPos3d)getProc("glWindowPos3d");
	glWindowPos3dv = cast(pfglWindowPos3dv)getProc("glWindowPos3dv");
	glWindowPos3f = cast(pfglWindowPos3f)getProc("glWindowPos3f");
	glWindowPos3fv = cast(pfglWindowPos3fv)getProc("glWindowPos3fv");
	glWindowPos3i = cast(pfglWindowPos3i)getProc("glWindowPos3i");
	glWindowPos3iv = cast(pfglWindowPos3iv)getProc("glWindowPos3iv");
	glWindowPos3s = cast(pfglWindowPos3s)getProc("glWindowPos3s");
	glWindowPos3sv = cast(pfglWindowPos3sv)getProc("glWindowPos3sv");

	glGenQueries = cast(pfglGenQueries)getProc("glGenQueries");
	glDeleteQueries = cast(pfglDeleteQueries)getProc("glDeleteQueries");
	glIsQuery = cast(pfglIsQuery)getProc("glIsQuery");
	glBeginQuery = cast(pfglBeginQuery)getProc("glBeginQuery");
	glEndQuery = cast(pfglEndQuery)getProc("glEndQuery");
	glGetQueryiv = cast(pfglGetQueryiv)getProc("glGetQueryiv");
	glGetQueryObjectiv = cast(pfglGetQueryObjectiv)getProc("glGetQueryObjectiv");
	glGetQueryObjectuiv = cast(pfglGetQueryObjectuiv)getProc("glGetQueryObjectuiv");
	glBindBuffer = cast(pfglBindBuffer)getProc("glBindBuffer");
	glDeleteBuffers = cast(pfglDeleteBuffers)getProc("glDeleteBuffers");
	glGenBuffers = cast(pfglGenBuffers)getProc("glGenBuffers");
	glIsBuffer = cast(pfglIsBuffer)getProc("glIsBuffer");
	glBufferData = cast(pfglBufferData)getProc("glBufferData");
	glBufferSubData = cast(pfglBufferSubData)getProc("glBufferSubData");
	glGetBufferSubData = cast(pfglGetBufferSubData)getProc("glGetBufferSubData");
	glMapBuffer = cast(pfglMapBuffer)getProc("glMapBuffer");
	glUnmapBuffer = cast(pfglUnmapBuffer)getProc("glUnmapBuffer");
	glGetBufferParameteriv = cast(pfglGetBufferParameteriv)getProc("glGetBufferParameteriv");
	glGetBufferPointerv = cast(pfglGetBufferPointerv)getProc("glGetBufferPointerv");

	glBlendEquationSeparate = cast(pfglBlendEquationSeparate)getProc("glBlendEquationSeparate");
	glDrawBuffers = cast(pfglDrawBuffers)getProc("glDrawBuffers");
	glStencilOpSeparate = cast(pfglStencilOpSeparate)getProc("glStencilOpSeparate");
	glStencilFuncSeparate = cast(pfglStencilFuncSeparate)getProc("glStencilFuncSeparate");
	glStencilMaskSeparate = cast(pfglStencilMaskSeparate)getProc("glStencilMaskSeparate");
	glAttachShader = cast(pfglAttachShader)getProc("glAttachShader");
	glBindAttribLocation = cast(pfglBindAttribLocation)getProc("glBindAttribLocation");
	glCompileShader = cast(pfglCompileShader)getProc("glCompileShader");
	glCreateProgram = cast(pfglCreateProgram)getProc("glCreateProgram");
	glCreateShader = cast(pfglCreateShader)getProc("glCreateShader");
	glDeleteProgram = cast(pfglDeleteProgram)getProc("glDeleteProgram");
	glDeleteShader = cast(pfglDeleteShader)getProc("glDeleteShader");
	glDetachShader = cast(pfglDetachShader)getProc("glDetachShader");
	glDisableVertexAttribArray = cast(pfglDisableVertexAttribArray)getProc("glDisableVertexAttribArray");
	glEnableVertexAttribArray = cast(pfglEnableVertexAttribArray)getProc("glEnableVertexAttribArray");
	glGetActiveAttrib = cast(pfglGetActiveAttrib)getProc("glGetActiveAttrib");
	glGetActiveUniform = cast(pfglGetActiveUniform)getProc("glGetActiveUniform");
	glGetAttachedShaders = cast(pfglGetAttachedShaders)getProc("glGetAttachedShaders");
	glGetAttribLocation = cast(pfglGetAttribLocation)getProc("glGetAttribLocation");
	glGetProgramiv = cast(pfglGetProgramiv)getProc("glGetProgramiv");
	glGetProgramInfoLog = cast(pfglGetProgramInfoLog)getProc("glGetProgramInfoLog");
	glGetShaderiv = cast(pfglGetShaderiv)getProc("glGetShaderiv");
	glGetShaderInfoLog = cast(pfglGetShaderInfoLog)getProc("glGetShaderInfoLog");
	glGetShaderSource = cast(pfglGetShaderSource)getProc("glGetShaderSource");
	glGetUniformLocation = cast(pfglGetUniformLocation)getProc("glGetUniformLocation");
	glGetUniformfv = cast(pfglGetUniformfv)getProc("glGetUniformfv");
	glGetUniformiv = cast(pfglGetUniformiv)getProc("glGetUniformiv");
	glGetVertexAttribdv = cast(pfglGetVertexAttribdv)getProc("glGetVertexAttribdv");
	glGetVertexAttribfv = cast(pfglGetVertexAttribfv)getProc("glGetVertexAttribfv");
	glGetVertexAttribiv = cast(pfglGetVertexAttribiv)getProc("glGetVertexAttribiv");
	glGetVertexAttribPointerv = cast(pfglGetVertexAttribPointerv)getProc("glGetVertexAttribPointerv");
	glIsProgram = cast(pfglIsProgram)getProc("glIsProgram");
	glIsShader = cast(pfglIsShader)getProc("glIsShader");
	glLinkProgram = cast(pfglLinkProgram)getProc("glLinkProgram");
	glShaderSource = cast(pfglShaderSource)getProc("glShaderSource");
	glUseProgram = cast(pfglUseProgram)getProc("glUseProgram");
	glUniform1f = cast(pfglUniform1f)getProc("glUniform1f");
	glUniform2f = cast(pfglUniform2f)getProc("glUniform2f");
	glUniform3f = cast(pfglUniform3f)getProc("glUniform3f");
	glUniform4f = cast(pfglUniform4f)getProc("glUniform4f");
	glUniform1i = cast(pfglUniform1i)getProc("glUniform1i");
	glUniform2i = cast(pfglUniform2i)getProc("glUniform2i");
	glUniform3i = cast(pfglUniform3i)getProc("glUniform3i");
	glUniform4i = cast(pfglUniform4i)getProc("glUniform4i");
	glUniform1fv = cast(pfglUniform1fv)getProc("glUniform1fv");
	glUniform2fv = cast(pfglUniform2fv)getProc("glUniform2fv");
	glUniform3fv = cast(pfglUniform3fv)getProc("glUniform3fv");
	glUniform4fv = cast(pfglUniform4fv)getProc("glUniform4fv");
	glUniform1iv = cast(pfglUniform1iv)getProc("glUniform1iv");
	glUniform2iv = cast(pfglUniform2iv)getProc("glUniform2iv");
	glUniform3iv = cast(pfglUniform3iv)getProc("glUniform3iv");
	glUniform4iv = cast(pfglUniform4iv)getProc("glUniform4iv");
	glUniformMatrix2fv = cast(pfglUniformMatrix2fv)getProc("glUniformMatrix2fv");
	glUniformMatrix3fv = cast(pfglUniformMatrix3fv)getProc("glUniformMatrix3fv");
	glUniformMatrix4fv = cast(pfglUniformMatrix4fv)getProc("glUniformMatrix4fv");
	glValidateProgram = cast(pfglValidateProgram)getProc("glValidateProgram");
	glVertexAttrib1d = cast(pfglVertexAttrib1d)getProc("glVertexAttrib1d");
	glVertexAttrib1dv = cast(pfglVertexAttrib1dv)getProc("glVertexAttrib1dv");
	glVertexAttrib1f = cast(pfglVertexAttrib1f)getProc("glVertexAttrib1f");
	glVertexAttrib1fv = cast(pfglVertexAttrib1fv)getProc("glVertexAttrib1fv");
	glVertexAttrib1s = cast(pfglVertexAttrib1s)getProc("glVertexAttrib1s");
	glVertexAttrib1sv = cast(pfglVertexAttrib1sv)getProc("glVertexAttrib1sv");
	glVertexAttrib2d = cast(pfglVertexAttrib2d)getProc("glVertexAttrib2d");
	glVertexAttrib2dv = cast(pfglVertexAttrib2dv)getProc("glVertexAttrib2dv");
	glVertexAttrib2f = cast(pfglVertexAttrib2f)getProc("glVertexAttrib2f");
	glVertexAttrib2fv = cast(pfglVertexAttrib2fv)getProc("glVertexAttrib2fv");
	glVertexAttrib2s = cast(pfglVertexAttrib2s)getProc("glVertexAttrib2s");
	glVertexAttrib2sv = cast(pfglVertexAttrib2sv)getProc("glVertexAttrib2sv");
	glVertexAttrib3d = cast(pfglVertexAttrib3d)getProc("glVertexAttrib3d");
	glVertexAttrib3dv = cast(pfglVertexAttrib3dv)getProc("glVertexAttrib3dv");
	glVertexAttrib3f = cast(pfglVertexAttrib3f)getProc("glVertexAttrib3f");
	glVertexAttrib3fv = cast(pfglVertexAttrib3fv)getProc("glVertexAttrib3fv");
	glVertexAttrib3s = cast(pfglVertexAttrib3s)getProc("glVertexAttrib3s");
	glVertexAttrib3sv = cast(pfglVertexAttrib3sv)getProc("glVertexAttrib3sv");
	glVertexAttrib4Nbv = cast(pfglVertexAttrib4Nbv)getProc("glVertexAttrib4Nbv");
	glVertexAttrib4Niv = cast(pfglVertexAttrib4Niv)getProc("glVertexAttrib4Niv");
	glVertexAttrib4Nsv = cast(pfglVertexAttrib4Nsv)getProc("glVertexAttrib4Nsv");
	glVertexAttrib4Nub = cast(pfglVertexAttrib4Nub)getProc("glVertexAttrib4Nub");
	glVertexAttrib4Nubv = cast(pfglVertexAttrib4Nubv)getProc("glVertexAttrib4Nubv");
	glVertexAttrib4Nuiv = cast(pfglVertexAttrib4Nuiv)getProc("glVertexAttrib4Nuiv");
	glVertexAttrib4Nusv = cast(pfglVertexAttrib4Nusv)getProc("glVertexAttrib4Nusv");
	glVertexAttrib4bv = cast(pfglVertexAttrib4bv)getProc("glVertexAttrib4bv");
	glVertexAttrib4d = cast(pfglVertexAttrib4d)getProc("glVertexAttrib4d");
	glVertexAttrib4dv = cast(pfglVertexAttrib4dv)getProc("glVertexAttrib4dv");
	glVertexAttrib4f = cast(pfglVertexAttrib4f)getProc("glVertexAttrib4f");
	glVertexAttrib4fv = cast(pfglVertexAttrib4fv)getProc("glVertexAttrib4fv");
	glVertexAttrib4iv = cast(pfglVertexAttrib4iv)getProc("glVertexAttrib4iv");
	glVertexAttrib4s = cast(pfglVertexAttrib4s)getProc("glVertexAttrib4s");
	glVertexAttrib4sv = cast(pfglVertexAttrib4sv)getProc("glVertexAttrib4sv");
	glVertexAttrib4ubv = cast(pfglVertexAttrib4ubv)getProc("glVertexAttrib4ubv");
	glVertexAttrib4uiv = cast(pfglVertexAttrib4uiv)getProc("glVertexAttrib4uiv");
	glVertexAttrib4usv = cast(pfglVertexAttrib4usv)getProc("glVertexAttrib4usv");
	glVertexAttribPointer = cast(pfglVertexAttribPointer)getProc("glVertexAttribPointer");
}

static ~this () {
	version(Rulada)
	{
	}
	else
	{
		ExeModule_Release(gldrv);
	}
}

version (Windows) {
	extern (Windows):
} else {
	extern (C):
}

typedef GLvoid function(GLfloat) pfglClearIndex;
typedef GLvoid function(GLclampf, GLclampf, GLclampf, GLclampf) pfglClearColor;
typedef GLvoid function(GLbitfield) pfglClear;
typedef GLvoid function(GLuint) pfglIndexMask;
typedef GLvoid function(GLboolean, GLboolean, GLboolean, GLboolean) pfglColorMask;
typedef GLvoid function(GLenum, GLclampf) pfglAlphaFunc;
typedef GLvoid function(GLenum, GLenum) pfglBlendFunc;
typedef GLvoid function(GLenum) pfglLogicOp;
typedef GLvoid function(GLenum) pfglCullFace;
typedef GLvoid function(GLenum) pfglFrontFace;
typedef GLvoid function(GLfloat) pfglPointSize;
typedef GLvoid function(GLfloat) pfglLineWidth;
typedef GLvoid function(GLint, GLushort) pfglLineStipple;
typedef GLvoid function(GLenum, GLenum) pfglPolygonMode;
typedef GLvoid function(GLfloat, GLfloat) pfglPolygonOffset;
typedef GLvoid function(GLubyte*) pfglPolygonStipple;
typedef GLvoid function(GLubyte*) pfglGetPolygonStipple;
typedef GLvoid function(GLboolean) pfglEdgeFlag;
typedef GLvoid function(GLboolean*) pfglEdgeFlagv;
typedef GLvoid function(GLint, GLint, GLsizei, GLsizei) pfglScissor;
typedef GLvoid function(GLenum, GLdouble*) pfglClipPlane;
typedef GLvoid function(GLenum, GLdouble*) pfglGetClipPlane;
typedef GLvoid function(GLenum) pfglDrawBuffer;
typedef GLvoid function(GLenum) pfglReadBuffer;
typedef GLvoid function(GLenum) pfglEnable;
typedef GLvoid function(GLenum) pfglDisable;
typedef GLboolean function(GLenum) pfglIsEnabled;
typedef GLvoid function(GLenum) pfglEnableClientState;
typedef GLvoid function(GLenum) pfglDisableClientState;
typedef GLvoid function(GLenum, GLboolean*) pfglGetBooleanv;
typedef GLvoid function(GLenum, GLdouble*) pfglGetDoublev;
typedef GLvoid function(GLenum, GLfloat*) pfglGetFloatv;
typedef GLvoid function(GLenum, GLint*) pfglGetIntegerv;
typedef GLvoid function(GLbitfield) pfglPushAttrib;
typedef GLvoid function() pfglPopAttrib;
typedef GLvoid function(GLbitfield) pfglPushClientAttrib;
typedef GLvoid function() pfglPopClientAttrib;
typedef GLint function(GLenum) pfglRenderMode;
typedef GLenum function() pfglGetError;
typedef GLubyte* function(GLenum) pfglGetString;
typedef GLvoid function() pfglFinish;
typedef GLvoid function() pfglFlush;
typedef GLvoid function(GLenum, GLenum) pfglHint;

pfglClearIndex			glClearIndex;
pfglClearColor			glClearColor;
pfglClear			glClear;
pfglIndexMask			glIndexMask;
pfglColorMask			glColorMask;
pfglAlphaFunc			glAlphaFunc;
pfglBlendFunc			glBlendFunc;
pfglLogicOp			glLogicOp;
pfglCullFace			glCullFace;
pfglFrontFace			glFrontFace;
pfglPointSize			glPointSize;
pfglLineWidth			glLineWidth;
pfglLineStipple			glLineStipple;
pfglPolygonMode			glPolygonMode;
pfglPolygonOffset		glPolygonOffset;
pfglPolygonStipple		glPolygonStipple;
pfglGetPolygonStipple		glGetPolygonStipple;
pfglEdgeFlag			glEdgeFlag;
pfglEdgeFlagv			glEdgeFlagv;
pfglScissor			glScissor;
pfglClipPlane			glClipPlane;
pfglGetClipPlane		glGetClipPlane;
pfglDrawBuffer			glDrawBuffer;
pfglReadBuffer			glReadBuffer;
pfglEnable			glEnable;
pfglDisable			glDisable;
pfglIsEnabled			glIsEnabled;
pfglEnableClientState		glEnableClientState;
pfglDisableClientState		glDisableClientState;
pfglGetBooleanv			glGetBooleanv;
pfglGetDoublev			glGetDoublev;
pfglGetFloatv			glGetFloatv;
pfglGetIntegerv			glGetIntegerv;
pfglPushAttrib			glPushAttrib;
pfglPopAttrib			glPopAttrib;
pfglPushClientAttrib		glPushClientAttrib;
pfglPopClientAttrib		glPopClientAttrib;
pfglRenderMode			glRenderMode;
pfglGetError			glGetError;
pfglGetString			glGetString;
pfglFinish			glFinish;
pfglFlush			glFlush;
pfglHint			glHint;

// Depth Buffer
typedef GLvoid function(GLclampd) pfglClearDepth;
typedef GLvoid function(GLenum) pfglDepthFunc;
typedef GLvoid function(GLboolean) pfglDepthMask;
typedef GLvoid function(GLclampd, GLclampd) pfglDepthRange;

pfglClearDepth			glClearDepth;
pfglDepthFunc			glDepthFunc;
pfglDepthMask			glDepthMask;
pfglDepthRange			glDepthRange;

// Accumulation Buffer
typedef GLvoid function(GLfloat, GLfloat, GLfloat, GLfloat) pfglClearAccum;
typedef GLvoid function(GLenum, GLfloat) pfglAccum;

pfglClearAccum			glClearAccum;
pfglAccum			glAccum;

// Transformation
typedef GLvoid function(GLenum) pfglMatrixMode;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble) pfglOrtho;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble) pfglFrustum;
typedef GLvoid function(GLint, GLint, GLsizei, GLsizei) pfglViewport;
typedef GLvoid function() pfglPushMatrix;
typedef GLvoid function() pfglPopMatrix;
typedef GLvoid function() pfglLoadIdentity;
typedef GLvoid function(GLdouble*) pfglLoadMatrixd;
typedef GLvoid function(GLfloat*) pfglLoadMatrixf;
typedef GLvoid function(GLdouble*) pfglMultMatrixd;
typedef GLvoid function(GLfloat*) pfglMultMatrixf;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble) pfglRotated;
typedef GLvoid function(GLfloat, GLfloat, GLfloat, GLfloat) pfglRotatef;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglScaled;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglScalef;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglTranslated;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglTranslatef;

pfglMatrixMode			glMatrixMode;
pfglOrtho			glOrtho;
pfglFrustum			glFrustum;
pfglViewport			glViewport;
pfglPushMatrix			glPushMatrix;
pfglPopMatrix			glPopMatrix;
pfglLoadIdentity		glLoadIdentity;
pfglLoadMatrixd			glLoadMatrixd;
pfglLoadMatrixf			glLoadMatrixf;
pfglMultMatrixd			glMultMatrixd;
pfglMultMatrixf			glMultMatrixf;
pfglRotated			glRotated;
pfglRotatef			glRotatef;
pfglScaled			glScaled;
pfglScalef			glScalef;
pfglTranslated			glTranslated;
pfglTranslatef			glTranslatef;

// Display Lists
typedef GLboolean function(GLuint) pfglIsList;
typedef GLvoid function(GLuint, GLsizei) pfglDeleteLists;
typedef GLuint function(GLsizei) pfglGenLists;
typedef GLvoid function(GLuint, GLenum) pfglNewList;
typedef GLvoid function() pfglEndList;
typedef GLvoid function(GLuint) pfglCallList;
typedef GLvoid function(GLsizei, GLenum, GLvoid*) pfglCallLists;
typedef GLvoid function(GLuint) pfglListBase;

pfglIsList			glIsList;
pfglDeleteLists			glDeleteLists;
pfglGenLists			glGenLists;
pfglNewList			glNewList;
pfglEndList			glEndList;
pfglCallList			glCallList;
pfglCallLists			glCallLists;
pfglListBase			glListBase;

// Drawing Functions
typedef GLvoid function(GLenum) pfglBegin;
typedef GLvoid function() pfglEnd;
typedef GLvoid function(GLdouble, GLdouble) pfglVertex2d;
typedef GLvoid function(GLfloat, GLfloat) pfglVertex2f;
typedef GLvoid function(GLint, GLint) pfglVertex2i;
typedef GLvoid function(GLshort, GLshort) pfglVertex2s;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglVertex3d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglVertex3f;
typedef GLvoid function(GLint, GLint, GLint) pfglVertex3i;
typedef GLvoid function(GLshort, GLshort, GLshort) pfglVertex3s;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble) pfglVertex4d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat, GLfloat) pfglVertex4f;
typedef GLvoid function(GLint, GLint, GLint, GLint) pfglVertex4i;
typedef GLvoid function(GLshort, GLshort, GLshort, GLshort) pfglVertex4s;
typedef GLvoid function(GLdouble*) pfglVertex2dv;
typedef GLvoid function(GLfloat*) pfglVertex2fv;
typedef GLvoid function(GLint*) pfglVertex2iv;
typedef GLvoid function(GLshort*) pfglVertex2sv;
typedef GLvoid function(GLdouble*) pfglVertex3dv;
typedef GLvoid function(GLfloat*) pfglVertex3fv;
typedef GLvoid function(GLint*) pfglVertex3iv;
typedef GLvoid function(GLshort*) pfglVertex3sv;
typedef GLvoid function(GLdouble*) pfglVertex4dv;
typedef GLvoid function(GLfloat*) pfglVertex4fv;
typedef GLvoid function(GLint*) pfglVertex4iv;
typedef GLvoid function(GLshort*) pfglVertex4sv;
typedef GLvoid function(GLbyte, GLbyte, GLbyte) pfglNormal3b;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglNormal3d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglNormal3f;
typedef GLvoid function(GLint, GLint, GLint) pfglNormal3i;
typedef GLvoid function(GLshort, GLshort, GLshort) pfglNormal3s;
typedef GLvoid function(GLbyte*) pfglNormal3bv;
typedef GLvoid function(GLdouble*) pfglNormal3dv;
typedef GLvoid function(GLfloat*) pfglNormal3fv;
typedef GLvoid function(GLint*) pfglNormal3iv;
typedef GLvoid function(GLshort*) pfglNormal3sv;
typedef GLvoid function(GLdouble) pfglIndexd;
typedef GLvoid function(GLfloat) pfglIndexf;
typedef GLvoid function(GLint) pfglIndexi;
typedef GLvoid function(GLshort) pfglIndexs;
typedef GLvoid function(GLubyte) pfglIndexub;
typedef GLvoid function(GLdouble*) pfglIndexdv;
typedef GLvoid function(GLfloat*) pfglIndexfv;
typedef GLvoid function(GLint*) pfglIndexiv;
typedef GLvoid function(GLshort*) pfglIndexsv;
typedef GLvoid function(GLubyte*) pfglIndexubv;
typedef GLvoid function(GLbyte, GLbyte, GLbyte) pfglColor3b;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglColor3d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglColor3f;
typedef GLvoid function(GLint, GLint, GLint) pfglColor3i;
typedef GLvoid function(GLshort, GLshort, GLshort) pfglColor3s;
typedef GLvoid function(GLubyte, GLubyte, GLubyte) pfglColor3ub;
typedef GLvoid function(GLuint, GLuint, GLuint) pfglColor3ui;
typedef GLvoid function(GLushort, GLushort, GLushort) pfglColor3us;
typedef GLvoid function(GLbyte, GLbyte, GLbyte, GLbyte) pfglColor4b;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble) pfglColor4d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat, GLfloat) pfglColor4f;
typedef GLvoid function(GLint, GLint, GLint, GLint) pfglColor4i;
typedef GLvoid function(GLshort, GLshort, GLshort, GLshort) pfglColor4s;
typedef GLvoid function(GLubyte, GLubyte, GLubyte, GLubyte) pfglColor4ub;
typedef GLvoid function(GLuint, GLuint, GLuint, GLuint) pfglColor4ui;
typedef GLvoid function(GLushort, GLushort, GLushort, GLushort) pfglColor4us;
typedef GLvoid function(GLbyte*) pfglColor3bv;
typedef GLvoid function(GLdouble*) pfglColor3dv;
typedef GLvoid function(GLfloat*) pfglColor3fv;
typedef GLvoid function(GLint*) pfglColor3iv;
typedef GLvoid function(GLshort*) pfglColor3sv;
typedef GLvoid function(GLubyte*) pfglColor3ubv;
typedef GLvoid function(GLuint*) pfglColor3uiv;
typedef GLvoid function(GLushort*) pfglColor3usv;
typedef GLvoid function(GLbyte*) pfglColor4bv;
typedef GLvoid function(GLdouble*) pfglColor4dv;
typedef GLvoid function(GLfloat*) pfglColor4fv;
typedef GLvoid function(GLint*) pfglColor4iv;
typedef GLvoid function(GLshort*) pfglColor4sv;
typedef GLvoid function(GLubyte*) pfglColor4ubv;
typedef GLvoid function(GLuint*) pfglColor4uiv;
typedef GLvoid function(GLushort*) pfglColor4usv;
typedef GLvoid function(GLdouble) pfglTexCoord1d;
typedef GLvoid function(GLfloat) pfglTexCoord1f;
typedef GLvoid function(GLint) pfglTexCoord1i;
typedef GLvoid function(GLshort) pfglTexCoord1s;
typedef GLvoid function(GLdouble, GLdouble) pfglTexCoord2d;
typedef GLvoid function(GLfloat, GLfloat) pfglTexCoord2f;
typedef GLvoid function(GLint, GLint) pfglTexCoord2i;
typedef GLvoid function(GLshort, GLshort) pfglTexCoord2s;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglTexCoord3d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglTexCoord3f;
typedef GLvoid function(GLint, GLint, GLint) pfglTexCoord3i;
typedef GLvoid function(GLshort, GLshort, GLshort) pfglTexCoord3s;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble) pfglTexCoord4d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat, GLfloat) pfglTexCoord4f;
typedef GLvoid function(GLint, GLint, GLint, GLint) pfglTexCoord4i;
typedef GLvoid function(GLshort, GLshort, GLshort, GLshort) pfglTexCoord4s;
typedef GLvoid function(GLdouble*) pfglTexCoord1dv;
typedef GLvoid function(GLfloat*) pfglTexCoord1fv;
typedef GLvoid function(GLint*) pfglTexCoord1iv;
typedef GLvoid function(GLshort*) pfglTexCoord1sv;
typedef GLvoid function(GLdouble*) pfglTexCoord2dv;
typedef GLvoid function(GLfloat*) pfglTexCoord2fv;
typedef GLvoid function(GLint*) pfglTexCoord2iv;
typedef GLvoid function(GLshort*) pfglTexCoord2sv;
typedef GLvoid function(GLdouble*) pfglTexCoord3dv;
typedef GLvoid function(GLfloat*) pfglTexCoord3fv;
typedef GLvoid function(GLint*) pfglTexCoord3iv;
typedef GLvoid function(GLshort*) pfglTexCoord3sv;
typedef GLvoid function(GLdouble*) pfglTexCoord4dv;
typedef GLvoid function(GLfloat*) pfglTexCoord4fv;
typedef GLvoid function(GLint*) pfglTexCoord4iv;
typedef GLvoid function(GLshort*) pfglTexCoord4sv;
typedef GLvoid function(GLdouble, GLdouble) pfglRasterPos2d;
typedef GLvoid function(GLfloat, GLfloat) pfglRasterPos2f;
typedef GLvoid function(GLint, GLint) pfglRasterPos2i;
typedef GLvoid function(GLshort, GLshort) pfglRasterPos2s;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglRasterPos3d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglRasterPos3f;
typedef GLvoid function(GLint, GLint, GLint) pfglRasterPos3i;
typedef GLvoid function(GLshort, GLshort, GLshort) pfglRasterPos3s;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble) pfglRasterPos4d;
typedef GLvoid function(GLfloat, GLfloat, GLfloat, GLfloat) pfglRasterPos4f;
typedef GLvoid function(GLint, GLint, GLint, GLint) pfglRasterPos4i;
typedef GLvoid function(GLshort, GLshort, GLshort, GLshort) pfglRasterPos4s;
typedef GLvoid function(GLdouble*) pfglRasterPos2dv;
typedef GLvoid function(GLfloat*) pfglRasterPos2fv;
typedef GLvoid function(GLint*) pfglRasterPos2iv;
typedef GLvoid function(GLshort*) pfglRasterPos2sv;
typedef GLvoid function(GLdouble*) pfglRasterPos3dv;
typedef GLvoid function(GLfloat*) pfglRasterPos3fv;
typedef GLvoid function(GLint*) pfglRasterPos3iv;
typedef GLvoid function(GLshort*) pfglRasterPos3sv;
typedef GLvoid function(GLdouble*) pfglRasterPos4dv;
typedef GLvoid function(GLfloat*) pfglRasterPos4fv;
typedef GLvoid function(GLint*) pfglRasterPos4iv;
typedef GLvoid function(GLshort*) pfglRasterPos4sv;
typedef GLvoid function(GLdouble, GLdouble, GLdouble, GLdouble) pfglRectd;
typedef GLvoid function(GLfloat, GLfloat, GLfloat, GLfloat) pfglRectf;
typedef GLvoid function(GLint, GLint, GLint, GLint) pfglRecti;
typedef GLvoid function(GLshort, GLshort, GLshort, GLshort) pfglRects;
typedef GLvoid function(GLdouble*, GLdouble*) pfglRectdv;
typedef GLvoid function(GLfloat*, GLfloat*) pfglRectfv;
typedef GLvoid function(GLint*, GLint*) pfglRectiv;
typedef GLvoid function(GLshort*, GLshort*) pfglRectsv;

pfglBegin			glBegin;
pfglEnd				glEnd;
pfglVertex2d			glVertex2d;
pfglVertex2f			glVertex2f;
pfglVertex2i			glVertex2i;
pfglVertex2s			glVertex2s;
pfglVertex3d			glVertex3d;
pfglVertex3f			glVertex3f;
pfglVertex3i			glVertex3i;
pfglVertex3s			glVertex3s;
pfglVertex4d			glVertex4d;
pfglVertex4f			glVertex4f;
pfglVertex4i			glVertex4i;
pfglVertex4s			glVertex4s;
pfglVertex2dv			glVertex2dv;
pfglVertex2fv			glVertex2fv;
pfglVertex2iv			glVertex2iv;
pfglVertex2sv			glVertex2sv;
pfglVertex3dv			glVertex3dv;
pfglVertex3fv			glVertex3fv;
pfglVertex3iv			glVertex3iv;
pfglVertex3sv			glVertex3sv;
pfglVertex4dv			glVertex4dv;
pfglVertex4fv			glVertex4fv;
pfglVertex4iv			glVertex4iv;
pfglVertex4sv			glVertex4sv;
pfglNormal3b			glNormal3b;
pfglNormal3d			glNormal3d;
pfglNormal3f			glNormal3f;
pfglNormal3i			glNormal3i;
pfglNormal3s			glNormal3s;
pfglNormal3bv			glNormal3bv;
pfglNormal3dv			glNormal3dv;
pfglNormal3fv			glNormal3fv;
pfglNormal3iv			glNormal3iv;
pfglNormal3sv			glNormal3sv;
pfglIndexd			glIndexd;
pfglIndexf			glIndexf;
pfglIndexi			glIndexi;
pfglIndexs			glIndexs;
pfglIndexub			glIndexub;
pfglIndexdv			glIndexdv;
pfglIndexfv			glIndexfv;
pfglIndexiv			glIndexiv;
pfglIndexsv			glIndexsv;
pfglIndexubv			glIndexubv;
pfglColor3b			glColor3b;
pfglColor3d			glColor3d;
pfglColor3f			glColor3f;
pfglColor3i			glColor3i;
pfglColor3s			glColor3s;
pfglColor3ub			glColor3ub;
pfglColor3ui			glColor3ui;
pfglColor3us			glColor3us;
pfglColor4b			glColor4b;
pfglColor4d			glColor4d;
pfglColor4f			glColor4f;
pfglColor4i			glColor4i;
pfglColor4s			glColor4s;
pfglColor4ub			glColor4ub;
pfglColor4ui			glColor4ui;
pfglColor4us			glColor4us;
pfglColor3bv			glColor3bv;
pfglColor3dv			glColor3dv;
pfglColor3fv			glColor3fv;
pfglColor3iv			glColor3iv;
pfglColor3sv			glColor3sv;
pfglColor3ubv			glColor3ubv;
pfglColor3uiv			glColor3uiv;
pfglColor3usv			glColor3usv;
pfglColor4bv			glColor4bv;
pfglColor4dv			glColor4dv;
pfglColor4fv			glColor4fv;
pfglColor4iv			glColor4iv;
pfglColor4sv			glColor4sv;
pfglColor4ubv			glColor4ubv;
pfglColor4uiv			glColor4uiv;
pfglColor4usv			glColor4usv;
pfglTexCoord1d			glTexCoord1d;
pfglTexCoord1f			glTexCoord1f;
pfglTexCoord1i			glTexCoord1i;
pfglTexCoord1s			glTexCoord1s;
pfglTexCoord2d			glTexCoord2d;
pfglTexCoord2f			glTexCoord2f;
pfglTexCoord2i			glTexCoord2i;
pfglTexCoord2s			glTexCoord2s;
pfglTexCoord3d			glTexCoord3d;
pfglTexCoord3f			glTexCoord3f;
pfglTexCoord3i			glTexCoord3i;
pfglTexCoord3s			glTexCoord3s;
pfglTexCoord4d			glTexCoord4d;
pfglTexCoord4f			glTexCoord4f;
pfglTexCoord4i			glTexCoord4i;
pfglTexCoord4s			glTexCoord4s;
pfglTexCoord1dv			glTexCoord1dv;
pfglTexCoord1fv			glTexCoord1fv;
pfglTexCoord1iv			glTexCoord1iv;
pfglTexCoord1sv			glTexCoord1sv;
pfglTexCoord2dv			glTexCoord2dv;
pfglTexCoord2fv			glTexCoord2fv;
pfglTexCoord2iv			glTexCoord2iv;
pfglTexCoord2sv			glTexCoord2sv;
pfglTexCoord3dv			glTexCoord3dv;
pfglTexCoord3fv			glTexCoord3fv;
pfglTexCoord3iv			glTexCoord3iv;
pfglTexCoord3sv			glTexCoord3sv;
pfglTexCoord4dv			glTexCoord4dv;
pfglTexCoord4fv			glTexCoord4fv;
pfglTexCoord4iv			glTexCoord4iv;
pfglTexCoord4sv			glTexCoord4sv;
pfglRasterPos2d			glRasterPos2d;
pfglRasterPos2f			glRasterPos2f;
pfglRasterPos2i			glRasterPos2i;
pfglRasterPos2s			glRasterPos2s;
pfglRasterPos3d			glRasterPos3d;
pfglRasterPos3f			glRasterPos3f;
pfglRasterPos3i			glRasterPos3i;
pfglRasterPos3s			glRasterPos3s;
pfglRasterPos4d			glRasterPos4d;
pfglRasterPos4f			glRasterPos4f;
pfglRasterPos4i			glRasterPos4i;
pfglRasterPos4s			glRasterPos4s;
pfglRasterPos2dv		glRasterPos2dv;
pfglRasterPos2fv		glRasterPos2fv;
pfglRasterPos2iv		glRasterPos2iv;
pfglRasterPos2sv		glRasterPos2sv;
pfglRasterPos3dv		glRasterPos3dv;
pfglRasterPos3fv		glRasterPos3fv;
pfglRasterPos3iv		glRasterPos3iv;
pfglRasterPos3sv		glRasterPos3sv;
pfglRasterPos4dv		glRasterPos4dv;
pfglRasterPos4fv		glRasterPos4fv;
pfglRasterPos4iv		glRasterPos4iv;
pfglRasterPos4sv		glRasterPos4sv;
pfglRectd			glRectd;
pfglRectf			glRectf;
pfglRecti			glRecti;
pfglRects			glRects;
pfglRectdv			glRectdv;
pfglRectfv			glRectfv;
pfglRectiv			glRectiv;
pfglRectsv			glRectsv;

// Vertex Arrays
typedef GLvoid function(GLint, GLenum, GLsizei stride, GLvoid*) pfglVertexPointer;
typedef GLvoid function(GLenum, GLsizei, GLvoid*) pfglNormalPointer;
typedef GLvoid function(GLint, GLenum, GLsizei, GLvoid*) pfglColorPointer;
typedef GLvoid function(GLenum, GLsizei, GLvoid*) pfglIndexPointer;
typedef GLvoid function(GLint, GLenum, GLsizei stride, GLvoid* ptr) pfglTexCoordPointer;
typedef GLvoid function(GLsizei, GLvoid* ptr) pfglEdgeFlagPointer;
typedef GLvoid function(GLenum, GLvoid**) pfglGetPointerv;
typedef GLvoid function(GLint) pfglArrayElement;
typedef GLvoid function(GLenum, GLint, GLsizei) pfglDrawArrays;
typedef GLvoid function(GLenum, GLsizei, GLenum, GLvoid*) pfglDrawElements;
typedef GLvoid function(GLenum, GLsizei, GLvoid*) pfglInterleavedArrays;

pfglVertexPointer		glVertexPointer;
pfglNormalPointer		glNormalPointer;
pfglColorPointer		glColorPointer;
pfglIndexPointer		glIndexPointer;
pfglTexCoordPointer		glTexCoordPointer;
pfglEdgeFlagPointer		glEdgeFlagPointer;
pfglGetPointerv			glGetPointerv;
pfglArrayElement		glArrayElement;
pfglDrawArrays			glDrawArrays;
pfglDrawElements		glDrawElements;
pfglInterleavedArrays		glInterleavedArrays;

// Lighting
typedef GLvoid function(GLenum) pfglShadeModel;
typedef GLvoid function(GLenum, GLenum, GLfloat) pfglLightf;
typedef GLvoid function(GLenum, GLenum, GLint) pfglLighti;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglLightfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglLightiv;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglGetLightfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetLightiv;
typedef GLvoid function(GLenum, GLfloat) pfglLightModelf;
typedef GLvoid function(GLenum, GLint) pfglLightModeli;
typedef GLvoid function(GLenum, GLfloat*) pfglLightModelfv;
typedef GLvoid function(GLenum, GLint*) pfglLightModeliv;
typedef GLvoid function(GLenum, GLenum, GLfloat) pfglMaterialf;
typedef GLvoid function(GLenum, GLenum, GLint) pfglMateriali;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglMaterialfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglMaterialiv;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglGetMaterialfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetMaterialiv;
typedef GLvoid function(GLenum, GLenum) pfglColorMaterial;

pfglShadeModel			glShadeModel;
pfglLightf			glLightf;
pfglLighti			glLighti;
pfglLightfv			glLightfv;
pfglLightiv			glLightiv;
pfglGetLightfv			glGetLightfv;
pfglGetLightiv			glGetLightiv;
pfglLightModelf			glLightModelf;
pfglLightModeli			glLightModeli;
pfglLightModelfv		glLightModelfv;
pfglLightModeliv		glLightModeliv;
pfglMaterialf			glMaterialf;
pfglMateriali			glMateriali;
pfglMaterialfv			glMaterialfv;
pfglMaterialiv			glMaterialiv;
pfglGetMaterialfv		glGetMaterialfv;
pfglGetMaterialiv		glGetMaterialiv;
pfglColorMaterial		glColorMaterial;

// Raster functions
typedef GLvoid function(GLfloat, GLfloat) pfglPixelZoom;
typedef GLvoid function(GLenum, GLfloat) pfglPixelStoref;
typedef GLvoid function(GLenum, GLint) pfglPixelStorei;
typedef GLvoid function(GLenum, GLfloat) pfglPixelTransferf;
typedef GLvoid function(GLenum, GLint) pfglPixelTransferi;
typedef GLvoid function(GLenum, GLsizei, GLfloat*) pfglPixelMapfv;
typedef GLvoid function(GLenum, GLsizei, GLuint*) pfglPixelMapuiv;
typedef GLvoid function(GLenum, GLsizei, GLushort*) pfglPixelMapusv;
typedef GLvoid function(GLenum, GLfloat*) pfglGetPixelMapfv;
typedef GLvoid function(GLenum, GLuint*) pfglGetPixelMapuiv;
typedef GLvoid function(GLenum, GLushort*) pfglGetPixelMapusv;
typedef GLvoid function(GLsizei, GLsizei, GLfloat, GLfloat, GLfloat, GLfloat, GLubyte*) pfglBitmap;
typedef GLvoid function(GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, GLvoid*) pfglReadPixels;
typedef GLvoid function(GLsizei, GLsizei, GLenum, GLenum, GLvoid*) pfglDrawPixels;
typedef GLvoid function(GLint, GLint, GLsizei, GLsizei, GLenum) pfglCopyPixels;

pfglPixelZoom			glPixelZoom;
pfglPixelStoref			glPixelStoref;
pfglPixelStorei			glPixelStorei;
pfglPixelTransferf		glPixelTransferf;
pfglPixelTransferi		glPixelTransferi;
pfglPixelMapfv			glPixelMapfv;
pfglPixelMapuiv			glPixelMapuiv;
pfglPixelMapusv			glPixelMapusv;
pfglGetPixelMapfv		glGetPixelMapfv;
pfglGetPixelMapuiv		glGetPixelMapuiv;
pfglGetPixelMapusv		glGetPixelMapusv;
pfglBitmap			glBitmap;
pfglReadPixels			glReadPixels;
pfglDrawPixels			glDrawPixels;
pfglCopyPixels			glCopyPixels;

// Stenciling
typedef GLvoid function(GLenum, GLint, GLuint) pfglStencilFunc;
typedef GLvoid function(GLuint) pfglStencilMask;
typedef GLvoid function(GLenum, GLenum, GLenum) pfglStencilOp;
typedef GLvoid function(GLint) pfglClearStencil;

pfglStencilFunc			glStencilFunc;
pfglStencilMask			glStencilMask;
pfglStencilOp			glStencilOp;
pfglClearStencil		glClearStencil;

// Texture mapping
typedef GLvoid function(GLenum, GLenum, GLdouble) pfglTexGend;
typedef GLvoid function(GLenum, GLenum, GLfloat) pfglTexGenf;
typedef GLvoid function(GLenum, GLenum, GLint) pfglTexGeni;
typedef GLvoid function(GLenum, GLenum, GLdouble*) pfglTexGendv;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglTexGenfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglTexGeniv;
typedef GLvoid function(GLenum, GLenum, GLdouble*) pfglGetTexGendv;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglGetTexGenfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetTexGeniv;
typedef GLvoid function(GLenum, GLenum, GLfloat) pfglTexEnvf;
typedef GLvoid function(GLenum, GLenum, GLint) pfglTexEnvi;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglTexEnvfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglTexEnviv;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglGetTexEnvfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetTexEnviv;
typedef GLvoid function(GLenum, GLenum, GLfloat) pfglTexParameterf;
typedef GLvoid function(GLenum, GLenum, GLint) pfglTexParameteri;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglTexParameterfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglTexParameteriv;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglGetTexParameterfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetTexParameteriv;
typedef GLvoid function(GLenum, GLint, GLenum, GLfloat*) pfglGetTexLevelParameterfv;
typedef GLvoid function(GLenum, GLint, GLenum, GLint*) pfglGetTexLevelParameteriv;
typedef GLvoid function(GLenum, GLint, GLint, GLsizei, GLint, GLenum, GLenum, GLvoid*) pfglTexImage1D;
typedef GLvoid function(GLenum, GLint, GLint, GLsizei, GLsizei, GLint, GLenum, GLenum, GLvoid*) pfglTexImage2D;
typedef GLvoid function(GLenum, GLint, GLenum, GLenum, GLvoid*) pfglGetTexImage;

pfglTexGend			glTexGend;
pfglTexGenf			glTexGenf;
pfglTexGeni			glTexGeni;
pfglTexGendv			glTexGendv;
pfglTexGenfv			glTexGenfv;
pfglTexGeniv			glTexGeniv;
pfglGetTexGendv			glGetTexGendv;
pfglGetTexGenfv			glGetTexGenfv;
pfglGetTexGeniv			glGetTexGeniv;
pfglTexEnvf			glTexEnvf;
pfglTexEnvi			glTexEnvi;
pfglTexEnvfv			glTexEnvfv;
pfglTexEnviv			glTexEnviv;
pfglGetTexEnvfv			glGetTexEnvfv;
pfglGetTexEnviv			glGetTexEnviv;
pfglTexParameterf		glTexParameterf;
pfglTexParameteri		glTexParameteri;
pfglTexParameterfv		glTexParameterfv;
pfglTexParameteriv		glTexParameteriv;
pfglGetTexParameterfv		glGetTexParameterfv;
pfglGetTexParameteriv		glGetTexParameteriv;
pfglGetTexLevelParameterfv	glGetTexLevelParameterfv;
pfglGetTexLevelParameteriv	glGetTexLevelParameteriv;
pfglTexImage1D			glTexImage1D;
pfglTexImage2D			glTexImage2D;
pfglGetTexImage			glGetTexImage;

// Evaluators
typedef GLvoid function(GLenum, GLdouble, GLdouble, GLint, GLint, GLdouble*) pfglMap1d;
typedef GLvoid function(GLenum, GLfloat, GLfloat, GLint, GLint, GLfloat*) pfglMap1f;
typedef GLvoid function(GLenum, GLdouble, GLdouble, GLint, GLint, GLdouble, GLdouble, GLint, GLint, GLdouble*) pfglMap2d;
typedef GLvoid function(GLenum, GLfloat, GLfloat, GLint, GLint, GLfloat, GLfloat, GLint, GLint, GLfloat*) pfglMap2f;
typedef GLvoid function(GLenum, GLenum, GLdouble*) pfglGetMapdv;
typedef GLvoid function(GLenum, GLenum, GLfloat*) pfglGetMapfv;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetMapiv;
typedef GLvoid function(GLdouble) pfglEvalCoord1d;
typedef GLvoid function(GLfloat) pfglEvalCoord1f;
typedef GLvoid function(GLdouble*) pfglEvalCoord1dv;
typedef GLvoid function(GLfloat*) pfglEvalCoord1fv;
typedef GLvoid function(GLdouble, GLdouble) pfglEvalCoord2d;
typedef GLvoid function(GLfloat, GLfloat) pfglEvalCoord2f;
typedef GLvoid function(GLdouble*) pfglEvalCoord2dv;
typedef GLvoid function(GLfloat*) pfglEvalCoord2fv;
typedef GLvoid function(GLint, GLdouble, GLdouble) pfglMapGrid1d;
typedef GLvoid function(GLint, GLfloat, GLfloat) pfglMapGrid1f;
typedef GLvoid function(GLint, GLdouble, GLdouble, GLint, GLdouble, GLdouble) pfglMapGrid2d;
typedef GLvoid function(GLint, GLfloat, GLfloat, GLint, GLfloat, GLfloat) pfglMapGrid2f;
typedef GLvoid function(GLint) pfglEvalPoint1;
typedef GLvoid function(GLint, GLint) pfglEvalPoint2;
typedef GLvoid function(GLenum, GLint, GLint) pfglEvalMesh1;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLint) pfglEvalMesh2;

pfglMap1d			glMap1d;
pfglMap1f			glMap1f;
pfglMap2d			glMap2d;
pfglMap2f			glMap2f;
pfglGetMapdv			glGetMapdv;
pfglGetMapfv			glGetMapfv;
pfglGetMapiv			glGetMapiv;
pfglEvalCoord1d			glEvalCoord1d;
pfglEvalCoord1f			glEvalCoord1f;
pfglEvalCoord1dv		glEvalCoord1dv;
pfglEvalCoord1fv		glEvalCoord1fv;
pfglEvalCoord2d			glEvalCoord2d;
pfglEvalCoord2f			glEvalCoord2f;
pfglEvalCoord2dv		glEvalCoord2dv;
pfglEvalCoord2fv		glEvalCoord2fv;
pfglMapGrid1d			glMapGrid1d;
pfglMapGrid1f			glMapGrid1f;
pfglMapGrid2d			glMapGrid2d;
pfglMapGrid2f			glMapGrid2f;
pfglEvalPoint1			glEvalPoint1;
pfglEvalPoint2			glEvalPoint2;
pfglEvalMesh1			glEvalMesh1;
pfglEvalMesh2			glEvalMesh2;

// Fog
typedef GLvoid function(GLenum, GLfloat) pfglFogf;
typedef GLvoid function(GLenum, GLint) pfglFogi;
typedef GLvoid function(GLenum, GLfloat*) pfglFogfv;
typedef GLvoid function(GLenum, GLint*) pfglFogiv;

pfglFogf			glFogf;
pfglFogi			glFogi;
pfglFogfv			glFogfv;
pfglFogiv			glFogiv;

// Selection and Feedback
typedef GLvoid function(GLsizei, GLenum, GLfloat*) pfglFeedbackBuffer;
typedef GLvoid function(GLfloat) pfglPassThrough;
typedef GLvoid function(GLsizei, GLuint*) pfglSelectBuffer;
typedef GLvoid function() pfglInitNames;
typedef GLvoid function(GLuint) pfglLoadName;
typedef GLvoid function(GLuint) pfglPushName;
typedef GLvoid function() pfglPopName;

pfglFeedbackBuffer		glFeedbackBuffer;
pfglPassThrough			glPassThrough;
pfglSelectBuffer		glSelectBuffer;
pfglInitNames			glInitNames;
pfglLoadName			glLoadName;
pfglPushName			glPushName;
pfglPopName			glPopName;

// OpenGL 1.1
typedef GLvoid function(GLsizei, GLuint*) pfglGenTextures;
typedef GLvoid function(GLsizei, GLuint*) pfglDeleteTextures;
typedef GLvoid function(GLenum, GLuint) pfglBindTexture;
typedef GLvoid function(GLsizei, GLuint*, GLclampf*) pfglPrioritizeTextures;
typedef GLboolean function(GLsizei, GLuint*, GLboolean*) pfglAreTexturesResident;
typedef GLboolean function(GLuint) pfglIsTexture;
typedef GLvoid function(GLenum, GLint, GLint, GLsizei, GLenum, GLenum, GLvoid*) pfglTexSubImage1D;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, GLvoid*) pfglTexSubImage2D;
typedef GLvoid function(GLenum, GLint, GLenum internalformat, GLint, GLint, GLsizei, GLint) pfglCopyTexImage1D;
typedef GLvoid function(GLenum, GLint, GLenum internalformat, GLint, GLint, GLsizei, GLsizei, GLint) pfglCopyTexImage2D;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLint, GLsizei) pfglCopyTexSubImage1D;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei) pfglCopyTexSubImage2D;

pfglGenTextures			glGenTextures;
pfglDeleteTextures		glDeleteTextures;
pfglBindTexture			glBindTexture;
pfglPrioritizeTextures		glPrioritizeTextures;
pfglAreTexturesResident		glAreTexturesResident;
pfglIsTexture			glIsTexture;
pfglTexSubImage1D		glTexSubImage1D;
pfglTexSubImage2D		glTexSubImage2D;
pfglCopyTexImage1D		glCopyTexImage1D;
pfglCopyTexImage2D		glCopyTexImage2D;
pfglCopyTexSubImage1D		glCopyTexSubImage1D;
pfglCopyTexSubImage2D		glCopyTexSubImage2D;

// OpenGL 1.2
typedef GLvoid function(GLenum, GLuint, GLuint, GLsizei, GLenum, GLvoid*) pfglDrawRangeElements;
typedef GLvoid function(GLenum, GLint, GLint, GLsizei, GLsizei, GLsizei, GLint, GLenum, GLenum, GLvoid*) pfglTexImage3D;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, GLvoid*) pfglTexSubImage3D;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei) pfglCopyTexSubImage3D;

pfglDrawRangeElements		glDrawRangeElements;
pfglTexImage3D			glTexImage3D;
pfglTexSubImage3D		glTexSubImage3D;
pfglCopyTexSubImage3D		glCopyTexSubImage3D;

// OpenGL 1.3
typedef GLvoid function(GLenum) pfglActiveTexture;
typedef GLvoid function(GLenum) pfglClientActiveTexture;
typedef GLvoid function(GLenum, GLdouble) pfglMultiTexCoord1d;
typedef GLvoid function(GLenum, GLdouble*) pfglMultiTexCoord1dv;
typedef GLvoid function(GLenum, GLfloat) pfglMultiTexCoord1f;
typedef GLvoid function(GLenum, GLfloat*) pfglMultiTexCoord1fv;
typedef GLvoid function(GLenum, GLint) pfglMultiTexCoord1i;
typedef GLvoid function(GLenum, GLint*) pfglMultiTexCoord1iv;
typedef GLvoid function(GLenum, GLshort) pfglMultiTexCoord1s;
typedef GLvoid function(GLenum, GLshort*) pfglMultiTexCoord1sv;
typedef GLvoid function(GLenum, GLdouble, GLdouble) pfglMultiTexCoord2d;
typedef GLvoid function(GLenum, GLdouble*) pfglMultiTexCoord2dv;
typedef GLvoid function(GLenum, GLfloat, GLfloat) pfglMultiTexCoord2f;
typedef GLvoid function(GLenum, GLfloat*) pfglMultiTexCoord2fv;
typedef GLvoid function(GLenum, GLint, GLint) pfglMultiTexCoord2i;
typedef GLvoid function(GLenum, GLint*) pfglMultiTexCoord2iv;
typedef GLvoid function(GLenum, GLshort, GLshort) pfglMultiTexCoord2s;
typedef GLvoid function(GLenum, GLshort*) pfglMultiTexCoord2sv;
typedef GLvoid function(GLenum, GLdouble, GLdouble, GLdouble) pfglMultiTexCoord3d;
typedef GLvoid function(GLenum, GLdouble*) pfglMultiTexCoord3dv;
typedef GLvoid function(GLenum, GLfloat, GLfloat, GLfloat) pfglMultiTexCoord3f;
typedef GLvoid function(GLenum, GLfloat*) pfglMultiTexCoord3fv;
typedef GLvoid function(GLenum, GLint, GLint, GLint) pfglMultiTexCoord3i;
typedef GLvoid function(GLenum, GLint*) pfglMultiTexCoord3iv;
typedef GLvoid function(GLenum, GLshort, GLshort, GLshort) pfglMultiTexCoord3s;
typedef GLvoid function(GLenum, GLshort*) pfglMultiTexCoord3sv;
typedef GLvoid function(GLenum, GLdouble, GLdouble, GLdouble, GLdouble) pfglMultiTexCoord4d;
typedef GLvoid function(GLenum, GLdouble*) pfglMultiTexCoord4dv;
typedef GLvoid function(GLenum, GLfloat, GLfloat, GLfloat, GLfloat) pfglMultiTexCoord4f;
typedef GLvoid function(GLenum, GLfloat*) pfglMultiTexCoord4fv;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLint) pfglMultiTexCoord4i;
typedef GLvoid function(GLenum, GLint*) pfglMultiTexCoord4iv;
typedef GLvoid function(GLenum, GLshort, GLshort, GLshort, GLshort) pfglMultiTexCoord4s;
typedef GLvoid function(GLenum, GLshort*) pfglMultiTexCoord4sv;
typedef GLvoid function(GLdouble[16]) pfglLoadTransposeMatrixd;
typedef GLvoid function(GLfloat[16]) pfglLoadTransposeMatrixf;
typedef GLvoid function(GLdouble[16]) pfglMultTransposeMatrixd;
typedef GLvoid function(GLfloat[16]) pfglMultTransposeMatrixf;
typedef GLvoid function(GLclampf, GLboolean) pfglSampleCoverage;
typedef GLvoid function(GLenum, GLint, GLenum, GLsizei, GLint, GLsizei, GLvoid*) pfglCompressedTexImage1D;
typedef GLvoid function(GLenum, GLint, GLenum, GLsizei, GLsizei, GLint, GLsizei, GLvoid*) pfglCompressedTexImage2D;
typedef GLvoid function(GLenum, GLint, GLenum, GLsizei, GLsizei, GLsizei depth, GLint, GLsizei, GLvoid*) pfglCompressedTexImage3D;
typedef GLvoid function(GLenum, GLint, GLint, GLsizei, GLenum, GLsizei, GLvoid*) pfglCompressedTexSubImage1D;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLsizei, GLvoid*) pfglCompressedTexSubImage2D;
typedef GLvoid function(GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLsizei, GLvoid*) pfglCompressedTexSubImage3D;
typedef GLvoid function(GLenum, GLint, GLvoid*) pfglGetCompressedTexImage;

pfglActiveTexture		glActiveTexture;
pfglClientActiveTexture		glClientActiveTexture;
pfglMultiTexCoord1d		glMultiTexCoord1d;
pfglMultiTexCoord1dv		glMultiTexCoord1dv;
pfglMultiTexCoord1f		glMultiTexCoord1f;
pfglMultiTexCoord1fv		glMultiTexCoord1fv;
pfglMultiTexCoord1i		glMultiTexCoord1i;
pfglMultiTexCoord1iv		glMultiTexCoord1iv;
pfglMultiTexCoord1s		glMultiTexCoord1s;
pfglMultiTexCoord1sv		glMultiTexCoord1sv;
pfglMultiTexCoord2d		glMultiTexCoord2d;
pfglMultiTexCoord2dv		glMultiTexCoord2dv;
pfglMultiTexCoord2f		glMultiTexCoord2f;
pfglMultiTexCoord2fv		glMultiTexCoord2fv;
pfglMultiTexCoord2i		glMultiTexCoord2i;
pfglMultiTexCoord2iv		glMultiTexCoord2iv;
pfglMultiTexCoord2s		glMultiTexCoord2s;
pfglMultiTexCoord2sv		glMultiTexCoord2sv;
pfglMultiTexCoord3d		glMultiTexCoord3d;
pfglMultiTexCoord3dv		glMultiTexCoord3dv;
pfglMultiTexCoord3f		glMultiTexCoord3f;
pfglMultiTexCoord3fv		glMultiTexCoord3fv;
pfglMultiTexCoord3i		glMultiTexCoord3i;
pfglMultiTexCoord3iv		glMultiTexCoord3iv;
pfglMultiTexCoord3s		glMultiTexCoord3s;
pfglMultiTexCoord3sv		glMultiTexCoord3sv;
pfglMultiTexCoord4d		glMultiTexCoord4d;
pfglMultiTexCoord4dv		glMultiTexCoord4dv;
pfglMultiTexCoord4f		glMultiTexCoord4f;
pfglMultiTexCoord4fv		glMultiTexCoord4fv;
pfglMultiTexCoord4i		glMultiTexCoord4i;
pfglMultiTexCoord4iv		glMultiTexCoord4iv;
pfglMultiTexCoord4s		glMultiTexCoord4s;
pfglMultiTexCoord4sv		glMultiTexCoord4sv;
pfglLoadTransposeMatrixd	glLoadTransposeMatrixd;
pfglLoadTransposeMatrixf	glLoadTransposeMatrixf;
pfglMultTransposeMatrixd	glMultTransposeMatrixd;
pfglMultTransposeMatrixf	glMultTransposeMatrixf;
pfglSampleCoverage		glSampleCoverage;
pfglCompressedTexImage1D	glCompressedTexImage1D;
pfglCompressedTexImage2D	glCompressedTexImage2D;
pfglCompressedTexImage3D	glCompressedTexImage3D;
pfglCompressedTexSubImage1D	glCompressedTexSubImage1D;
pfglCompressedTexSubImage2D	glCompressedTexSubImage2D;
pfglCompressedTexSubImage3D	glCompressedTexSubImage3D;
pfglGetCompressedTexImage	glGetCompressedTexImage;

// OpenGL 1.4
typedef GLvoid function(GLenum, GLenum, GLenum, GLenum) pfglBlendFuncSeparate;
typedef GLvoid function(GLfloat) pfglFogCoordf;
typedef GLvoid function(GLfloat*) pfglFogCoordfv;
typedef GLvoid function(GLdouble) pfglFogCoordd;
typedef GLvoid function(GLdouble*) pfglFogCoorddv;
typedef GLvoid function(GLenum, GLsizei,GLvoid*) pfglFogCoordPointer;
typedef GLvoid function(GLenum, GLint*, GLsizei*, GLsizei) pfglMultiDrawArrays;
typedef GLvoid function(GLenum, GLsizei*, GLenum, GLvoid**, GLsizei) pfglMultiDrawElements;
typedef GLvoid function(GLenum, GLfloat) pfglPointParameterf;
typedef GLvoid function(GLenum, GLfloat*) pfglPointParameterfv;
typedef GLvoid function(GLenum, GLint) pfglPointParameteri;
typedef GLvoid function(GLenum, GLint*) pfglPointParameteriv;
typedef GLvoid function(GLbyte, GLbyte, GLbyte) pfglSecondaryColor3b;
typedef GLvoid function(GLbyte*) pfglSecondaryColor3bv;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglSecondaryColor3d;
typedef GLvoid function(GLdouble*) pfglSecondaryColor3dv;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglSecondaryColor3f;
typedef GLvoid function(GLfloat*) pfglSecondaryColor3fv;
typedef GLvoid function(GLint, GLint, GLint) pfglSecondaryColor3i;
typedef GLvoid function(GLint*) pfglSecondaryColor3iv;
typedef GLvoid function(GLshort, GLshort, GLshort) pfglSecondaryColor3s;
typedef GLvoid function(GLshort*) pfglSecondaryColor3sv;
typedef GLvoid function(GLubyte, GLubyte, GLubyte) pfglSecondaryColor3ub;
typedef GLvoid function(GLubyte*) pfglSecondaryColor3ubv;
typedef GLvoid function(GLuint, GLuint, GLuint) pfglSecondaryColor3ui;
typedef GLvoid function(GLuint*) pfglSecondaryColor3uiv;
typedef GLvoid function(GLushort, GLushort, GLushort) pfglSecondaryColor3us;
typedef GLvoid function(GLushort*) pfglSecondaryColor3usv;
typedef GLvoid function(GLint, GLenum, GLsizei, GLvoid*) pfglSecondaryColorPointer;
typedef GLvoid function(GLdouble, GLdouble) pfglWindowPos2d;
typedef GLvoid function(GLdouble*) pfglWindowPos2dv;
typedef GLvoid function(GLfloat, GLfloat) pfglWindowPos2f;
typedef GLvoid function(GLfloat*) pfglWindowPos2fv;
typedef GLvoid function(GLint, GLint) pfglWindowPos2i;
typedef GLvoid function(GLint*) pfglWindowPos2iv;
typedef GLvoid function(GLshort, GLshort) pfglWindowPos2s;
typedef GLvoid function(GLshort*) pfglWindowPos2sv;
typedef GLvoid function(GLdouble, GLdouble, GLdouble) pfglWindowPos3d;
typedef GLvoid function(GLdouble*) pfglWindowPos3dv;
typedef GLvoid function(GLfloat, GLfloat, GLfloat) pfglWindowPos3f;
typedef GLvoid function(GLfloat*) pfglWindowPos3fv;
typedef GLvoid function(GLint, GLint, GLint) pfglWindowPos3i;
typedef GLvoid function(GLint*) pfglWindowPos3iv;
typedef GLvoid function(GLshort, GLshort, GLshort) pfglWindowPos3s;
typedef GLvoid function(GLshort*) pfglWindowPos3sv;

pfglBlendFuncSeparate		glBlendFuncSeparate;
pfglFogCoordf			glFogCoordf;
pfglFogCoordfv			glFogCoordfv;
pfglFogCoordd			glFogCoordd;
pfglFogCoorddv			glFogCoorddv;
pfglFogCoordPointer		glFogCoordPointer;
pfglMultiDrawArrays		glMultiDrawArrays;
pfglMultiDrawElements		glMultiDrawElements;
pfglPointParameterf		glPointParameterf;
pfglPointParameterfv		glPointParameterfv;
pfglPointParameteri		glPointParameteri;
pfglPointParameteriv		glPointParameteriv;
pfglSecondaryColor3b		glSecondaryColor3b;
pfglSecondaryColor3bv		glSecondaryColor3bv;
pfglSecondaryColor3d		glSecondaryColor3d;
pfglSecondaryColor3dv		glSecondaryColor3dv;
pfglSecondaryColor3f		glSecondaryColor3f;
pfglSecondaryColor3fv		glSecondaryColor3fv;
pfglSecondaryColor3i		glSecondaryColor3i;
pfglSecondaryColor3iv		glSecondaryColor3iv;
pfglSecondaryColor3s		glSecondaryColor3s;
pfglSecondaryColor3sv		glSecondaryColor3sv;
pfglSecondaryColor3ub		glSecondaryColor3ub;
pfglSecondaryColor3ubv		glSecondaryColor3ubv;
pfglSecondaryColor3ui		glSecondaryColor3ui;
pfglSecondaryColor3uiv		glSecondaryColor3uiv;
pfglSecondaryColor3us		glSecondaryColor3us;
pfglSecondaryColor3usv		glSecondaryColor3usv;
pfglSecondaryColorPointer	glSecondaryColorPointer;
pfglWindowPos2d			glWindowPos2d;
pfglWindowPos2dv		glWindowPos2dv;
pfglWindowPos2f			glWindowPos2f;
pfglWindowPos2fv		glWindowPos2fv;
pfglWindowPos2i			glWindowPos2i;
pfglWindowPos2iv		glWindowPos2iv;
pfglWindowPos2s			glWindowPos2s;
pfglWindowPos2sv		glWindowPos2sv;
pfglWindowPos3d			glWindowPos3d;
pfglWindowPos3dv		glWindowPos3dv;
pfglWindowPos3f			glWindowPos3f;
pfglWindowPos3fv		glWindowPos3fv;
pfglWindowPos3i			glWindowPos3i;
pfglWindowPos3iv		glWindowPos3iv;
pfglWindowPos3s			glWindowPos3s;
pfglWindowPos3sv		glWindowPos3sv;

// OpenGL 1.5
typedef GLvoid function(GLsizei, GLuint*) pfglGenQueries;
typedef GLvoid function(GLsizei,GLuint*) pfglDeleteQueries;
typedef GLboolean function(GLuint) pfglIsQuery;
typedef GLvoid function(GLenum, GLuint) pfglBeginQuery;
typedef GLvoid function(GLenum) pfglEndQuery;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetQueryiv;
typedef GLvoid function(GLuint, GLenum, GLint*) pfglGetQueryObjectiv;
typedef GLvoid function(GLuint, GLenum, GLuint*) pfglGetQueryObjectuiv;
typedef GLvoid function(GLenum, GLuint) pfglBindBuffer;
typedef GLvoid function(GLsizei, GLuint*) pfglDeleteBuffers;
typedef GLvoid function(GLsizei, GLuint*) pfglGenBuffers;
typedef GLboolean function(GLuint) pfglIsBuffer;
typedef GLvoid function(GLenum, GLsizeiptr, GLvoid*, GLenum) pfglBufferData;
typedef GLvoid function(GLenum, GLintptr, GLsizeiptr,GLvoid*) pfglBufferSubData;
typedef GLvoid function(GLenum, GLintptr, GLsizeiptr, GLvoid*) pfglGetBufferSubData;
typedef GLvoid* function(GLenum, GLenum) pfglMapBuffer;
typedef GLboolean function(GLenum) pfglUnmapBuffer;
typedef GLvoid function(GLenum, GLenum, GLint*) pfglGetBufferParameteriv;
typedef GLvoid function(GLenum, GLenum, GLvoid**) pfglGetBufferPointerv;

pfglGenQueries			glGenQueries;
pfglDeleteQueries		glDeleteQueries;
pfglIsQuery			glIsQuery;
pfglBeginQuery			glBeginQuery;
pfglEndQuery			glEndQuery;
pfglGetQueryiv			glGetQueryiv;
pfglGetQueryObjectiv		glGetQueryObjectiv;
pfglGetQueryObjectuiv		glGetQueryObjectuiv;
pfglBindBuffer			glBindBuffer;
pfglDeleteBuffers		glDeleteBuffers;
pfglGenBuffers			glGenBuffers;
pfglIsBuffer			glIsBuffer;
pfglBufferData			glBufferData;
pfglBufferSubData		glBufferSubData;
pfglGetBufferSubData		glGetBufferSubData;
pfglMapBuffer			glMapBuffer;
pfglUnmapBuffer			glUnmapBuffer;
pfglGetBufferParameteriv	glGetBufferParameteriv;
pfglGetBufferPointerv		glGetBufferPointerv;

// OpenGL 2.0
typedef GLvoid function(GLenum, GLenum) pfglBlendEquationSeparate;
typedef GLvoid function(GLsizei, GLenum*) pfglDrawBuffers;
typedef GLvoid function(GLenum, GLenum, GLenum, GLenum) pfglStencilOpSeparate;
typedef GLvoid function(GLenum, GLenum, GLint, GLuint) pfglStencilFuncSeparate;
typedef GLvoid function(GLenum, GLuint) pfglStencilMaskSeparate;
typedef GLvoid function(GLuint, GLuint) pfglAttachShader;
typedef GLvoid function(GLuint, GLuint, GLchar*) pfglBindAttribLocation;
typedef GLvoid function(GLuint) pfglCompileShader;
typedef GLuint function() pfglCreateProgram;
typedef GLuint function(GLenum) pfglCreateShader;
typedef GLvoid function(GLuint) pfglDeleteProgram;
typedef GLvoid function(GLuint) pfglDeleteShader;
typedef GLvoid function(GLuint, GLuint) pfglDetachShader;
typedef GLvoid function(GLuint) pfglDisableVertexAttribArray;
typedef GLvoid function(GLuint) pfglEnableVertexAttribArray;
typedef GLvoid function(GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*) pfglGetActiveAttrib;
typedef GLvoid function(GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*) pfglGetActiveUniform;
typedef GLvoid function(GLuint, GLsizei, GLsizei*, GLuint*) pfglGetAttachedShaders;
typedef GLint function(GLuint, GLchar*) pfglGetAttribLocation;
typedef GLvoid function(GLuint, GLenum, GLint*) pfglGetProgramiv;
typedef GLvoid function(GLuint, GLsizei, GLsizei*, GLchar*) pfglGetProgramInfoLog;
typedef GLvoid function(GLuint, GLenum, GLint *) pfglGetShaderiv;
typedef GLvoid function(GLuint, GLsizei, GLsizei*, GLchar*) pfglGetShaderInfoLog;
typedef GLvoid function(GLuint, GLsizei, GLsizei*, GLchar*) pfglGetShaderSource;
typedef GLint function(GLuint, GLchar*) pfglGetUniformLocation;
typedef GLvoid function(GLuint, GLint, GLfloat*) pfglGetUniformfv;
typedef GLvoid function(GLuint, GLint, GLint*) pfglGetUniformiv;
typedef GLvoid function(GLuint, GLenum, GLdouble*) pfglGetVertexAttribdv;
typedef GLvoid function(GLuint, GLenum, GLfloat*) pfglGetVertexAttribfv;
typedef GLvoid function(GLuint, GLenum, GLint*) pfglGetVertexAttribiv;
typedef GLvoid function(GLuint, GLenum, GLvoid**) pfglGetVertexAttribPointerv;
typedef GLboolean function(GLuint) pfglIsProgram;
typedef GLboolean function(GLuint) pfglIsShader;
typedef GLvoid function(GLuint) pfglLinkProgram;
typedef GLvoid function(GLuint, GLsizei, GLchar**, GLint*) pfglShaderSource;
typedef GLvoid function(GLuint) pfglUseProgram;
typedef GLvoid function(GLint, GLfloat) pfglUniform1f;
typedef GLvoid function(GLint, GLfloat, GLfloat) pfglUniform2f;
typedef GLvoid function(GLint, GLfloat, GLfloat, GLfloat) pfglUniform3f;
typedef GLvoid function(GLint, GLfloat, GLfloat, GLfloat, GLfloat) pfglUniform4f;
typedef GLvoid function(GLint, GLint) pfglUniform1i;
typedef GLvoid function(GLint, GLint, GLint) pfglUniform2i;
typedef GLvoid function(GLint, GLint, GLint, GLint) pfglUniform3i;
typedef GLvoid function(GLint, GLint, GLint, GLint, GLint) pfglUniform4i;
typedef GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform1fv;
typedef GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform2fv;
typedef GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform3fv;
typedef GLvoid function(GLint, GLsizei, GLfloat*) pfglUniform4fv;
typedef GLvoid function(GLint, GLsizei, GLint*) pfglUniform1iv;
typedef GLvoid function(GLint, GLsizei, GLint*) pfglUniform2iv;
typedef GLvoid function(GLint, GLsizei, GLint*) pfglUniform3iv;
typedef GLvoid function(GLint, GLsizei, GLint*) pfglUniform4iv;
typedef GLvoid function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix2fv;
typedef GLvoid function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix3fv;
typedef GLvoid function(GLint, GLsizei, GLboolean, GLfloat*) pfglUniformMatrix4fv;
typedef GLvoid function(GLuint) pfglValidateProgram;
typedef GLvoid function(GLuint, GLdouble) pfglVertexAttrib1d;
typedef GLvoid function(GLuint, GLdouble*) pfglVertexAttrib1dv;
typedef GLvoid function(GLuint, GLfloat) pfglVertexAttrib1f;
typedef GLvoid function(GLuint, GLfloat*) pfglVertexAttrib1fv;
typedef GLvoid function(GLuint, GLshort) pfglVertexAttrib1s;
typedef GLvoid function(GLuint, GLshort*) pfglVertexAttrib1sv;
typedef GLvoid function(GLuint, GLdouble, GLdouble) pfglVertexAttrib2d;
typedef GLvoid function(GLuint, GLdouble*) pfglVertexAttrib2dv;
typedef GLvoid function(GLuint, GLfloat, GLfloat) pfglVertexAttrib2f;
typedef GLvoid function(GLuint, GLfloat*) pfglVertexAttrib2fv;
typedef GLvoid function(GLuint, GLshort, GLshort) pfglVertexAttrib2s;
typedef GLvoid function(GLuint, GLshort*) pfglVertexAttrib2sv;
typedef GLvoid function(GLuint, GLdouble, GLdouble, GLdouble) pfglVertexAttrib3d;
typedef GLvoid function(GLuint, GLdouble*) pfglVertexAttrib3dv;
typedef GLvoid function(GLuint, GLfloat, GLfloat, GLfloat) pfglVertexAttrib3f;
typedef GLvoid function(GLuint, GLfloat*) pfglVertexAttrib3fv;
typedef GLvoid function(GLuint, GLshort, GLshort, GLshort) pfglVertexAttrib3s;
typedef GLvoid function(GLuint, GLshort*) pfglVertexAttrib3sv;
typedef GLvoid function(GLuint, GLbyte*) pfglVertexAttrib4Nbv;
typedef GLvoid function(GLuint, GLint*) pfglVertexAttrib4Niv;
typedef GLvoid function(GLuint, GLshort*) pfglVertexAttrib4Nsv;
typedef GLvoid function(GLuint, GLubyte, GLubyte, GLubyte, GLubyte) pfglVertexAttrib4Nub;
typedef GLvoid function(GLuint, GLubyte*) pfglVertexAttrib4Nubv;
typedef GLvoid function(GLuint, GLuint*) pfglVertexAttrib4Nuiv;
typedef GLvoid function(GLuint, GLushort*) pfglVertexAttrib4Nusv;
typedef GLvoid function(GLuint, GLbyte*) pfglVertexAttrib4bv;
typedef GLvoid function(GLuint, GLdouble, GLdouble, GLdouble, GLdouble) pfglVertexAttrib4d;
typedef GLvoid function(GLuint, GLdouble*) pfglVertexAttrib4dv;
typedef GLvoid function(GLuint, GLfloat, GLfloat, GLfloat, GLfloat) pfglVertexAttrib4f;
typedef GLvoid function(GLuint, GLfloat*) pfglVertexAttrib4fv;
typedef GLvoid function(GLuint, GLint*) pfglVertexAttrib4iv;
typedef GLvoid function(GLuint, GLshort, GLshort, GLshort, GLshort) pfglVertexAttrib4s;
typedef GLvoid function(GLuint, GLshort*) pfglVertexAttrib4sv;
typedef GLvoid function(GLuint, GLubyte*) pfglVertexAttrib4ubv;
typedef GLvoid function(GLuint, GLuint*) pfglVertexAttrib4uiv;
typedef GLvoid function(GLuint, GLushort*) pfglVertexAttrib4usv;
typedef GLvoid function(GLuint, GLint, GLenum, GLboolean, GLsizei, GLvoid*) pfglVertexAttribPointer;

pfglBlendEquationSeparate	glBlendEquationSeparate;
pfglDrawBuffers			glDrawBuffers;
pfglStencilOpSeparate		glStencilOpSeparate;
pfglStencilFuncSeparate		glStencilFuncSeparate;
pfglStencilMaskSeparate		glStencilMaskSeparate;
pfglAttachShader		glAttachShader;
pfglBindAttribLocation		glBindAttribLocation;
pfglCompileShader		glCompileShader;
pfglCreateProgram		glCreateProgram;
pfglCreateShader		glCreateShader;
pfglDeleteProgram		glDeleteProgram;
pfglDeleteShader		glDeleteShader;
pfglDetachShader		glDetachShader;
pfglDisableVertexAttribArray	glDisableVertexAttribArray;
pfglEnableVertexAttribArray	glEnableVertexAttribArray;
pfglGetActiveAttrib		glGetActiveAttrib;
pfglGetActiveUniform		glGetActiveUniform;
pfglGetAttachedShaders		glGetAttachedShaders;
pfglGetAttribLocation		glGetAttribLocation;
pfglGetProgramiv		glGetProgramiv;
pfglGetProgramInfoLog		glGetProgramInfoLog;
pfglGetShaderiv			glGetShaderiv;
pfglGetShaderInfoLog		glGetShaderInfoLog;
pfglGetShaderSource		glGetShaderSource;
pfglGetUniformLocation		glGetUniformLocation;
pfglGetUniformfv		glGetUniformfv;
pfglGetUniformiv		glGetUniformiv;
pfglGetVertexAttribdv		glGetVertexAttribdv;
pfglGetVertexAttribfv		glGetVertexAttribfv;
pfglGetVertexAttribiv		glGetVertexAttribiv;
pfglGetVertexAttribPointerv	glGetVertexAttribPointerv;
pfglIsProgram			glIsProgram;
pfglIsShader			glIsShader;
pfglLinkProgram			glLinkProgram;
pfglShaderSource		glShaderSource;
pfglUseProgram			glUseProgram;
pfglUniform1f			glUniform1f;
pfglUniform2f			glUniform2f;
pfglUniform3f			glUniform3f;
pfglUniform4f			glUniform4f;
pfglUniform1i			glUniform1i;
pfglUniform2i			glUniform2i;
pfglUniform3i			glUniform3i;
pfglUniform4i			glUniform4i;
pfglUniform1fv			glUniform1fv;
pfglUniform2fv			glUniform2fv;
pfglUniform3fv			glUniform3fv;
pfglUniform4fv			glUniform4fv;
pfglUniform1iv			glUniform1iv;
pfglUniform2iv			glUniform2iv;
pfglUniform3iv			glUniform3iv;
pfglUniform4iv			glUniform4iv;
pfglUniformMatrix2fv		glUniformMatrix2fv;
pfglUniformMatrix3fv		glUniformMatrix3fv;
pfglUniformMatrix4fv		glUniformMatrix4fv;
pfglValidateProgram		glValidateProgram;
pfglVertexAttrib1d		glVertexAttrib1d;
pfglVertexAttrib1dv		glVertexAttrib1dv;
pfglVertexAttrib1f		glVertexAttrib1f;
pfglVertexAttrib1fv		glVertexAttrib1fv;
pfglVertexAttrib1s		glVertexAttrib1s;
pfglVertexAttrib1sv		glVertexAttrib1sv;
pfglVertexAttrib2d		glVertexAttrib2d;
pfglVertexAttrib2dv		glVertexAttrib2dv;
pfglVertexAttrib2f		glVertexAttrib2f;
pfglVertexAttrib2fv		glVertexAttrib2fv;
pfglVertexAttrib2s		glVertexAttrib2s;
pfglVertexAttrib2sv		glVertexAttrib2sv;
pfglVertexAttrib3d		glVertexAttrib3d;
pfglVertexAttrib3dv		glVertexAttrib3dv;
pfglVertexAttrib3f		glVertexAttrib3f;
pfglVertexAttrib3fv		glVertexAttrib3fv;
pfglVertexAttrib3s		glVertexAttrib3s;
pfglVertexAttrib3sv		glVertexAttrib3sv;
pfglVertexAttrib4Nbv		glVertexAttrib4Nbv;
pfglVertexAttrib4Niv		glVertexAttrib4Niv;
pfglVertexAttrib4Nsv		glVertexAttrib4Nsv;
pfglVertexAttrib4Nub		glVertexAttrib4Nub;
pfglVertexAttrib4Nubv		glVertexAttrib4Nubv;
pfglVertexAttrib4Nuiv		glVertexAttrib4Nuiv;
pfglVertexAttrib4Nusv		glVertexAttrib4Nusv;
pfglVertexAttrib4bv		glVertexAttrib4bv;
pfglVertexAttrib4d		glVertexAttrib4d;
pfglVertexAttrib4dv		glVertexAttrib4dv;
pfglVertexAttrib4f		glVertexAttrib4f;
pfglVertexAttrib4fv		glVertexAttrib4fv;
pfglVertexAttrib4iv		glVertexAttrib4iv;
pfglVertexAttrib4s		glVertexAttrib4s;
pfglVertexAttrib4sv		glVertexAttrib4sv;
pfglVertexAttrib4ubv		glVertexAttrib4ubv;
pfglVertexAttrib4uiv		glVertexAttrib4uiv;
pfglVertexAttrib4usv		glVertexAttrib4usv;
pfglVertexAttribPointer		glVertexAttribPointer;

}




version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
