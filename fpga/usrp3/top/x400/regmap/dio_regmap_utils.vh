//
// Copyright 2021 Ettus Research, A National Instruments Company
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//
// Module: dio_regmap_utils.vh
// Description:
// The constants in this file are autogenerated by XmlParse.

//===============================================================================
// A numerically ordered list of registers and their HDL source files
//===============================================================================

  // DIO_MASTER_REGISTER    : 0x0 (x4xx_dio.v)
  // DIO_DIRECTION_REGISTER : 0x4 (x4xx_dio.v)
  // DIO_INPUT_REGISTER     : 0x8 (x4xx_dio.v)
  // DIO_OUTPUT_REGISTER    : 0xC (x4xx_dio.v)

//===============================================================================
// RegTypes
//===============================================================================

//===============================================================================
// Register Group DIO_REGS
//===============================================================================

  // DIO_MASTER_REGISTER Register (from x4xx_dio.v)
  localparam DIO_MASTER_REGISTER = 'h0; // Register Offset
  localparam DIO_MASTER_REGISTER_SIZE = 32;  // register width in bits
  localparam DIO_MASTER_REGISTER_MASK = 32'hFFF0FFF;
  localparam DIO_MASTER_A_SIZE = 12;  //DIO_MASTER_REGISTER:DIO_MASTER_A
  localparam DIO_MASTER_A_MSB  = 11;  //DIO_MASTER_REGISTER:DIO_MASTER_A
  localparam DIO_MASTER_A      =  0;  //DIO_MASTER_REGISTER:DIO_MASTER_A
  localparam DIO_MASTER_B_SIZE = 12;  //DIO_MASTER_REGISTER:DIO_MASTER_B
  localparam DIO_MASTER_B_MSB  = 27;  //DIO_MASTER_REGISTER:DIO_MASTER_B
  localparam DIO_MASTER_B      = 16;  //DIO_MASTER_REGISTER:DIO_MASTER_B

  // DIO_DIRECTION_REGISTER Register (from x4xx_dio.v)
  localparam DIO_DIRECTION_REGISTER = 'h4; // Register Offset
  localparam DIO_DIRECTION_REGISTER_SIZE = 32;  // register width in bits
  localparam DIO_DIRECTION_REGISTER_MASK = 32'hFFF0FFF;
  localparam DIO_DIRECTION_A_SIZE = 12;  //DIO_DIRECTION_REGISTER:DIO_DIRECTION_A
  localparam DIO_DIRECTION_A_MSB  = 11;  //DIO_DIRECTION_REGISTER:DIO_DIRECTION_A
  localparam DIO_DIRECTION_A      =  0;  //DIO_DIRECTION_REGISTER:DIO_DIRECTION_A
  localparam DIO_DIRECTION_B_SIZE = 12;  //DIO_DIRECTION_REGISTER:DIO_DIRECTION_B
  localparam DIO_DIRECTION_B_MSB  = 27;  //DIO_DIRECTION_REGISTER:DIO_DIRECTION_B
  localparam DIO_DIRECTION_B      = 16;  //DIO_DIRECTION_REGISTER:DIO_DIRECTION_B

  // DIO_INPUT_REGISTER Register (from x4xx_dio.v)
  localparam DIO_INPUT_REGISTER = 'h8; // Register Offset
  localparam DIO_INPUT_REGISTER_SIZE = 32;  // register width in bits
  localparam DIO_INPUT_REGISTER_MASK = 32'hFFF0FFF;
  localparam DIO_INPUT_A_SIZE = 12;  //DIO_INPUT_REGISTER:DIO_INPUT_A
  localparam DIO_INPUT_A_MSB  = 11;  //DIO_INPUT_REGISTER:DIO_INPUT_A
  localparam DIO_INPUT_A      =  0;  //DIO_INPUT_REGISTER:DIO_INPUT_A
  localparam DIO_INPUT_B_SIZE = 12;  //DIO_INPUT_REGISTER:DIO_INPUT_B
  localparam DIO_INPUT_B_MSB  = 27;  //DIO_INPUT_REGISTER:DIO_INPUT_B
  localparam DIO_INPUT_B      = 16;  //DIO_INPUT_REGISTER:DIO_INPUT_B

  // DIO_OUTPUT_REGISTER Register (from x4xx_dio.v)
  localparam DIO_OUTPUT_REGISTER = 'hC; // Register Offset
  localparam DIO_OUTPUT_REGISTER_SIZE = 32;  // register width in bits
  localparam DIO_OUTPUT_REGISTER_MASK = 32'hFFF0FFF;
  localparam DIO_OUTPUT_A_SIZE = 12;  //DIO_OUTPUT_REGISTER:DIO_OUTPUT_A
  localparam DIO_OUTPUT_A_MSB  = 11;  //DIO_OUTPUT_REGISTER:DIO_OUTPUT_A
  localparam DIO_OUTPUT_A      =  0;  //DIO_OUTPUT_REGISTER:DIO_OUTPUT_A
  localparam DIO_OUTPUT_B_SIZE = 12;  //DIO_OUTPUT_REGISTER:DIO_OUTPUT_B
  localparam DIO_OUTPUT_B_MSB  = 27;  //DIO_OUTPUT_REGISTER:DIO_OUTPUT_B
  localparam DIO_OUTPUT_B      = 16;  //DIO_OUTPUT_REGISTER:DIO_OUTPUT_B