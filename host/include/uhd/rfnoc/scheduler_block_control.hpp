//
// Copyright 2019 Ettus Research, a National Instruments Brand
//
// SPDX-License-Identifier: GPL-3.0-or-later
//

#ifndef INCLUDED_RFNOC_EXAMPLE_SCHEDULER_BLOCK_CONTROL_HPP
#define INCLUDED_RFNOC_EXAMPLE_SCHEDULER_BLOCK_CONTROL_HPP

#include <uhd/config.hpp>
#include <uhd/rfnoc/noc_block_base.hpp>
#include <uhd/types/stream_cmd.hpp>

namespace rfnoc { namespace example {

/*! Block controller for the gain block: Multiply amplitude of signal
 *
 * This block multiplies the signal input with a fixed gain value.
 */
class UHD_API scheduler_block_control : public uhd::rfnoc::noc_block_base
{
public:
    RFNOC_DECLARE_BLOCK(scheduler_block_control)

};

}} // namespace rfnoc::example

#endif /* INCLUDED_RFNOC_EXAMPLE_GAIN_BLOCK_CONTROL_HPP */
