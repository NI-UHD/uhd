//
// Copyright 2019 Ettus Research, a National Instruments Brand
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

// Include our own header:
#include <rfnoc/example/scheduler_block_control.hpp>

// These two includes are the minimum required to implement a block:
#include <uhd/rfnoc/defaults.hpp>
#include <uhd/rfnoc/registry.hpp>

using namespace rfnoc::example;
using namespace uhd::rfnoc;

class scheduler_block_control_impl : public scheduler_block_control
{
public:
    RFNOC_BLOCK_CONSTRUCTOR(scheduler_block_control) {}


private:
};

UHD_RFNOC_BLOCK_REGISTER_DIRECT(
    scheduler_block_control, 0xAAAA, "Scheduler", CLOCK_KEY_GRAPH, "bus_clk")
