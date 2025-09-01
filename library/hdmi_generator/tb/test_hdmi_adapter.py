import os
import sys
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.runner import get_runner
from cocotb.triggers import RisingEdge, Timer
from cocotbext.axi import AxiStreamBus, AxiStreamMonitor, AxiStreamSink, AxiStreamSource

counter = 0


def get_bytes(n=8):
    global counter

    b = []
    for i in range(n):
        b.append(counter)
        counter += 1
    return bytes(b)


@cocotb.test()
async def test1(dut):
    PERIOD = 10

    cocotb.start_soon(Clock(dut.aclk, PERIOD, units="ns").start())

    axis_source = AxiStreamSource(
        AxiStreamBus.from_prefix(dut, "s_axis_rgb"),
        dut.aclk,
        dut.areset,
        reset_active_level=True,
    )

    dut.areset.value = 1
    await RisingEdge(dut.aclk)
    dut.areset.value = 0
    await RisingEdge(dut.aclk)

    dut.sof.value = 1
    await RisingEdge(dut.aclk)
    dut.sof.value = 0
    await axis_source.send(get_bytes(16))
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    dut.sof.value = 1
    await RisingEdge(dut.aclk)
    dut.sof.value = 0
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await axis_source.send(get_bytes(16))
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    dut.sof.value = 1
    await RisingEdge(dut.aclk)
    dut.sof.value = 0
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)
    await RisingEdge(dut.aclk)


def test_runner():
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "verilator")

    proj_path = Path(__file__).resolve().parent.parent
    root_path = proj_path.parent
    common_path = root_path / "common"

    verilog_sources = [
        root_path / "verilator_config.vlt",
        proj_path / "hdmi_adapter.v",
    ]
    build_test_args = []

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel="hdmi_adapter",
        always=True,
        waves=True,
        build_args=build_test_args,
    )
    runner.test(
        hdl_toplevel="hdmi_adapter",
        test_module="test_hdmi_adapter",
        waves=True,
        test_args=build_test_args,
    )


if __name__ == "__main__":
    test_runner()
