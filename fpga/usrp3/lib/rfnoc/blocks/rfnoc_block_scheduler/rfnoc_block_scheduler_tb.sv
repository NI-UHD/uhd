//
// Copyright 2020 Ettus Research, a National Instruments Brand
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//
// Module: rfnoc_block_scheduler_tb
//
// Description: Testbench for the scheduler RFNoC block.
//

`default_nettype none


module rfnoc_block_scheduler_tb();

  `include "test_exec.svh"

  import PkgTestExec::*;
  import PkgChdrUtils::*;
  import PkgRfnocBlockCtrlBfm::*;
//  import PkgRfnocItemUtils::*;

  //---------------------------------------------------------------------------
  // Testbench Configuration
  //---------------------------------------------------------------------------

  localparam [31:0] NOC_ID          = 32'h0000AAAA;
  localparam [ 9:0] THIS_PORTID     = 10'h123;
  localparam int    CHDR_W          = 64;    // CHDR size in bits
  localparam int    MTU             = 10;    // Log2 of max transmission unit in CHDR words
  localparam int    NUM_PORTS_I     = 1;
  localparam int    NUM_PORTS_O     = 1;
  localparam int    ITEM_W          = 32;    // Sample size in bits
  localparam int    SPP             = 64;    // Samples per packet
  localparam int    PKT_SIZE_BYTES  = SPP * (ITEM_W/8);
  localparam int    STALL_PROB      = 25;    // Default BFM stall probability
  localparam real   CHDR_CLK_PER    = 5.0;   // 200 MHz
  localparam real   CTRL_CLK_PER    = 5.0;   // 125 MHz

  //---------------------------------------------------------------------------
  // Clocks and Resets
  //---------------------------------------------------------------------------

  bit rfnoc_chdr_clk;
  bit rfnoc_ctrl_clk;

  sim_clock_gen #(CHDR_CLK_PER) rfnoc_chdr_clk_gen (.clk(rfnoc_chdr_clk), .rst());
  sim_clock_gen #(CTRL_CLK_PER) rfnoc_ctrl_clk_gen (.clk(rfnoc_ctrl_clk), .rst());

  //---------------------------------------------------------------------------
  // Bus Functional Models
  //---------------------------------------------------------------------------

  // Backend Interface
  RfnocBackendIf backend (rfnoc_chdr_clk, rfnoc_ctrl_clk);

  // AXIS-Ctrl Interface
  AxiStreamIf #(32) m_ctrl (rfnoc_ctrl_clk, 1'b0);
  AxiStreamIf #(32) s_ctrl (rfnoc_ctrl_clk, 1'b0);

  // AXIS-CHDR Interfaces
  AxiStreamIf #(CHDR_W) m_chdr [NUM_PORTS_I] (rfnoc_chdr_clk, 1'b0);
  AxiStreamIf #(CHDR_W) s_chdr [NUM_PORTS_O] (rfnoc_chdr_clk, 1'b0);

  // Block Controller BFM
  RfnocBlockCtrlBfm #(CHDR_W, ITEM_W) blk_ctrl = new(backend, m_ctrl, s_ctrl);

  // CHDR word and item/sample data types
  typedef ChdrData #(CHDR_W, ITEM_W)::chdr_word_t chdr_word_t;
  typedef ChdrData #(CHDR_W, ITEM_W)::item_t      item_t;

  // Connect block controller to BFMs
  for (genvar i = 0; i < NUM_PORTS_I; i++) begin : gen_bfm_input_connections
    initial begin
      blk_ctrl.connect_master_data_port(i, m_chdr[i], PKT_SIZE_BYTES);
      blk_ctrl.set_master_stall_prob(i, STALL_PROB);
    end
  end
  for (genvar i = 0; i < NUM_PORTS_O; i++) begin : gen_bfm_output_connections
    initial begin
      blk_ctrl.connect_slave_data_port(i, s_chdr[i]);
      blk_ctrl.set_slave_stall_prob(i, STALL_PROB);
    end
  end

  //---------------------------------------------------------------------------
  // Device Under Test (DUT)
  //---------------------------------------------------------------------------

  // DUT Slave (Input) Port Signals
  logic [CHDR_W*NUM_PORTS_I-1:0] s_rfnoc_chdr_tdata;
  logic [       NUM_PORTS_I-1:0] s_rfnoc_chdr_tlast;
  logic [       NUM_PORTS_I-1:0] s_rfnoc_chdr_tvalid;
  logic [       NUM_PORTS_I-1:0] s_rfnoc_chdr_tready;

  // DUT Master (Output) Port Signals
  logic [CHDR_W*NUM_PORTS_O-1:0] m_rfnoc_chdr_tdata;
  logic [       NUM_PORTS_O-1:0] m_rfnoc_chdr_tlast;
  logic [       NUM_PORTS_O-1:0] m_rfnoc_chdr_tvalid;
  logic [       NUM_PORTS_O-1:0] m_rfnoc_chdr_tready;

  // Map the array of BFMs to a flat vector for the DUT connections
  for (genvar i = 0; i < NUM_PORTS_I; i++) begin : gen_dut_input_connections
    // Connect BFM master to DUT slave port
    assign s_rfnoc_chdr_tdata[CHDR_W*i+:CHDR_W] = m_chdr[i].tdata;
    assign s_rfnoc_chdr_tlast[i]                = m_chdr[i].tlast;
    assign s_rfnoc_chdr_tvalid[i]               = m_chdr[i].tvalid;
    assign m_chdr[i].tready                     = s_rfnoc_chdr_tready[i];
  end
  for (genvar i = 0; i < NUM_PORTS_O; i++) begin : gen_dut_output_connections
    // Connect BFM slave to DUT master port
    assign s_chdr[i].tdata        = m_rfnoc_chdr_tdata[CHDR_W*i+:CHDR_W];
    assign s_chdr[i].tlast        = m_rfnoc_chdr_tlast[i];
    assign s_chdr[i].tvalid       = m_rfnoc_chdr_tvalid[i];
    assign m_rfnoc_chdr_tready[i] = s_chdr[i].tready;
  end

  rfnoc_block_scheduler #(
    .THIS_PORTID         (THIS_PORTID),
    .CHDR_W              (CHDR_W),
    .MTU                 (MTU)
  ) dut (
    .rfnoc_chdr_clk      (rfnoc_chdr_clk),
    .rfnoc_ctrl_clk      (rfnoc_ctrl_clk),
    .rfnoc_core_config   (backend.cfg),
    .rfnoc_core_status   (backend.sts),
    .s_rfnoc_chdr_tdata  (s_rfnoc_chdr_tdata),
    .s_rfnoc_chdr_tlast  (s_rfnoc_chdr_tlast),
    .s_rfnoc_chdr_tvalid (s_rfnoc_chdr_tvalid),
    .s_rfnoc_chdr_tready (s_rfnoc_chdr_tready),
    .m_rfnoc_chdr_tdata  (m_rfnoc_chdr_tdata),
    .m_rfnoc_chdr_tlast  (m_rfnoc_chdr_tlast),
    .m_rfnoc_chdr_tvalid (m_rfnoc_chdr_tvalid),
    .m_rfnoc_chdr_tready (m_rfnoc_chdr_tready),
    .s_rfnoc_ctrl_tdata  (m_ctrl.tdata),
    .s_rfnoc_ctrl_tlast  (m_ctrl.tlast),
    .s_rfnoc_ctrl_tvalid (m_ctrl.tvalid),
    .s_rfnoc_ctrl_tready (m_ctrl.tready),
    .m_rfnoc_ctrl_tdata  (s_ctrl.tdata),
    .m_rfnoc_ctrl_tlast  (s_ctrl.tlast),
    .m_rfnoc_ctrl_tvalid (s_ctrl.tvalid),
    .m_rfnoc_ctrl_tready (s_ctrl.tready)
  );
    // Test sending packets of ones
  task automatic send_ones(int port, int interp_rate, bit has_time, int p);
    begin
      import math_pkg::*;
      const bit [63:0] start_time = 64'h0123456789ABCDEF;       
      fork
        begin
          chdr_word_t send_payload[$];
          packet_info_t pkt_info;
          reg [31:0] count1 =32'b1;
          reg [31:0] count2 =32'b10;
           
          $display("Send ones");

          // Generate a payload of all ones
          send_payload = {};
          send_payload.push_back({16'h0000, 16'h0000, 16'h2000, 16'h0000});          
          for (int j = 0; j < PKT_SIZE_BYTES/8 - 1; j++) begin
                
                 send_payload.push_back({(count2[31:16]), (count2[15:0]), (count1[31:16]), (count1[15:0])});
//               send_payload.push_back({(16'h0008 << j*2), (16'h0004 << j*2), (16'h0002 << j*2), (16'h0001 << j*2)});
                count1 = count1 << 2;
                count2 = count2 << 2;
          end
         // if (s_ctrl.tvalid == 1) begin
//          end
          // Send two packets with EOB on the second packet
          pkt_info = 0;
          pkt_info.has_time  = has_time;
          pkt_info.timestamp = start_time;
          for (int i =1; i<p;i++) begin              
              blk_ctrl.send_packets(port, send_payload, /*data_bytes*/, /*metadata*/, pkt_info);
              pkt_info.timestamp = start_time + i*SPP;
          end 
          pkt_info.eob = 1;
          blk_ctrl.send_packets(port, send_payload, /*data_bytes*/, /*metadata*/, pkt_info);
          
          $display("Send ones complete");
        end
        begin
          string s;
          chdr_word_t samples;
          int data_bytes;
          chdr_word_t recv_payload[$];
          chdr_word_t metadata[$];
          packet_info_t pkt_info;

          $display("Check incoming samples");
          for (int i = 0; i < p; i++) begin
            blk_ctrl.recv_adv(port, recv_payload, data_bytes, metadata, pkt_info);

            // Check the packet size
            $sformat(s, "incorrect (drop) packet size! expected: %0d, actual: %0d", PKT_SIZE_BYTES/8, recv_payload.size());
//            `ASSERT_ERROR(recv_payload.size() == PKT_SIZE_BYTES/8, s);

            // Check the timestamp
            if (has_time) begin
              bit [63:0] expected_time;
              // Calculate what the timestamp should be
              expected_time = start_time + i * SPP;
              $sformat(s, "Incorrect timestamp: has_time = %0d, timestamp = 0x%0X, expected 0x%0X",
                       pkt_info.has_time, pkt_info.timestamp, expected_time);
//              `ASSERT_ERROR(pkt_info.has_time == 1 && pkt_info.timestamp == expected_time, s);
            end else begin
//              `ASSERT_ERROR(pkt_info.has_time == 0, "Packet has timestamp when it shouldn't");
            end

            // Check EOB
//            if (i == 2*interp_rate-1) begin
//              `ASSERT_ERROR(pkt_info.eob == 1, "EOB not set on last packet");
//            end else begin
//              `ASSERT_ERROR(pkt_info.eob == 0, 
//                $sformatf("EOB unexpectedly set on packet %0d", i));
//            end

            // Check the sample values
            samples = 64'd0;
            for (int j = 0; j < PKT_SIZE_BYTES/8; j++) begin
              samples = recv_payload[j];
              $sformat(s, "Ramp word %0d invalid! Expected a real value, Received: %0d", 2*j, samples);
//              `ASSERT_ERROR(samples >= 0, s);
            end
          end
          $display("Check complete");
        end
      join
    end
  endtask
  //---------------------------------------------------------------------------
  // Main Test Process
  //---------------------------------------------------------------------------

  initial begin : tb_main

    // Initialize the test exec object for this testbench
    test.start_tb("rfnoc_block_scheduler_tb");

    // Start the BFMs running
    blk_ctrl.run();

    //--------------------------------
    // Reset
    //--------------------------------

    test.start_test("Flush block then reset it", 10us);
    blk_ctrl.flush_and_reset();
    test.end_test();

    //--------------------------------
    // Verify Block Info
    //--------------------------------

    test.start_test("Verify Block Info", 2us);
    `ASSERT_ERROR(blk_ctrl.get_noc_id() == NOC_ID, "Incorrect NOC_ID Value");
    `ASSERT_ERROR(blk_ctrl.get_num_data_i() == NUM_PORTS_I, "Incorrect NUM_DATA_I Value");
    `ASSERT_ERROR(blk_ctrl.get_num_data_o() == NUM_PORTS_O, "Incorrect NUM_DATA_O Value");
    `ASSERT_ERROR(blk_ctrl.get_mtu() == MTU, "Incorrect MTU Value");
    test.end_test();

    //--------------------------------
    // Test Sequences
    //--------------------------------

    // <Add your test code here>
    test.start_test("<Name your first test>", 100us);
    `ASSERT_WARNING(0, "This testbench doesn't test anything yet!");
    test.end_test();
    s_ctrl.tready = 1;
    send_ones(0, 1,  0, 2);
    s_ctrl.tready = 1;
    //--------------------------------
    // Finish Up
    //--------------------------------

    // Display final statistics and results
    test.end_tb();
  end : tb_main

reg [1:0] cc =0;
reg rrr = 0;
always@(posedge rfnoc_ctrl_clk)  begin
    if (s_ctrl.tvalid == 1) begin
        rrr <= 1;
    end
    if (rrr == 1) begin
        cc <= cc + 1;
        m_ctrl.tlast <= 1'b0;
        if (cc == 0) begin
        m_ctrl.tdata <= {1'b1, 1'b0, 6'b0, 4'b1, 10'h2, 10'h123};
        m_ctrl.tvalid <= 1'b1;
        end else if (cc == 1) begin
            m_ctrl.tdata <= 0;
            m_ctrl.tvalid <= 1'b1;
        end else if (cc == 2) begin      
            m_ctrl.tdata <= {2'b0, 2'b0, 4'b0, 4'hF, 20'b0};
            m_ctrl.tvalid <= 1'b1;
        end else if (cc == 3) begin
            m_ctrl.tdata <= 0;
            m_ctrl.tvalid <= 1'b1;
            m_ctrl.tlast <= 1'b1;
            s_ctrl.tready <= 1'b1;
            rrr <= 0;
        end
    end
end


endmodule : rfnoc_block_scheduler_tb


`default_nettype wire
