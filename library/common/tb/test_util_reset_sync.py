#!/bin/env python
import os
import sys
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.runner import get_runner
from cocotb.triggers import Edge, FallingEdge, RisingEdge, Timer


@cocotb.test()
async def test_sync_reset_behavior(dut):
    """
    Test that the async rst is safely synchronized and that out behaves correctly.
    """

    # Parameters
    clk_period = 5  # in ns
    N = int(dut.N)  # sync depth
    D = int(dut.D)  # pulse duration

    # Start clock
    cocotb.start_soon(Clock(dut.clk, clk_period, units="ns").start())

    # Initialize inputs
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Wait a few cycles
    for _ in range(2):
        await RisingEdge(dut.clk)

    # Apply async reset (simulate glitch or async input)
    await Timer(clk_period / 5, units="ns")  # async timing
    dut.rst.value = 1
    await Timer(clk_period / 5, units="ns")  # async timing
    dut.rst.value = 0

    # Check that output is zero immediately after rst toggle
    # out should not go high immediately (this checks async assertion is avoided)
    assert dut.out.value == 0, "Output asserted asynchronously — not expected"

    # On the second clock cycle, output should go high
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.out.value == 1, f"Output did not go high at the next cycle"

    # Stay high for at least D cycles
    for i in range(D - 1):
        await RisingEdge(dut.clk)
        assert dut.out.value == 1, f"Output went low too early at D-cycle {i}"

    # It should become low after no more than D + N cycles
    for i in range(N):
        await RisingEdge(dut.clk)

    assert dut.out.value == 0, f"Output did not return to 0 after {D + N} cycles"

    # Final pass message
    dut._log.info("✅ sync_reset test passed.")


def test_runner():
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "verilator")

    proj_path = Path(__file__).resolve().parent.parent
    root_path = proj_path.parent

    verilator_config = root_path / "verilator_config.vlt"
    verilog_sources = [verilator_config, proj_path / "util_reset_sync.v"]
    build_test_args = []

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel="util_reset_sync",
        always=True,
        waves=True,
        build_args=build_test_args,
    )
    runner.test(
        hdl_toplevel="util_reset_sync",
        test_module="test_util_reset_sync",
        waves=True,
        test_args=build_test_args,
    )


if __name__ == "__main__":
    test_runner()
