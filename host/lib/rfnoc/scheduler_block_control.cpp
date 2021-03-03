//
// Copyright 2019 Ettus Research, a National Instruments Brand
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

// Include our own header:
#include <uhd/rfnoc/scheduler_block_control.hpp>

// These two includes are the minimum required to implement a block:
#include <uhd/rfnoc/defaults.hpp>
#include <uhd/rfnoc/registry.hpp>

using namespace rfnoc::example;
using namespace uhd::rfnoc;

const uint32_t scheduler_block_control::REG_RUN = 128;

class scheduler_block_control_impl : public scheduler_block_control
{
public:
    RFNOC_BLOCK_CONSTRUCTOR(scheduler_block_control) {}

void scheduer_run(const uint32_t run)
{
    regs().poke32(REG_RUN, run);
}

uint32_t get_status()
    {
        return regs().peek32(REG_RUN);
    }

private:

};

UHD_RFNOC_BLOCK_REGISTER_DIRECT(
    scheduler_block_control, 0xAAAA, "Scheduler", CLOCK_KEY_GRAPH, "bus_clk")
