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

/*! Block controller for the scheduler block: Send control signals to change duc/ddc frequencies.
 *
 * This block will send control signal to other blocks.
 */
class UHD_API scheduler_block_control : public uhd::rfnoc::noc_block_base
{
public:
    RFNOC_DECLARE_BLOCK(scheduler_block_control)

    //! The register address of the run 
    static const uint32_t REG_RUN;
    
    /*! Set the run to start/stop scheduling
     */
    virtual void scheduer_run(const uint32_t run) = 0;
    
    /*! Get the current run value (read it from the device)
     */
    virtual uint32_t get_status() = 0;
};

}} // namespace rfnoc::example

#endif /* INCLUDED_RFNOC_EXAMPLE_SCHEDULER_BLOCK_CONTROL_HPP */
