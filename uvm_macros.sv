`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;
import booth_uvm_pkg::*;

module tb_top;

    localparam N = booth_uvm_pkg::N_BITS;

    logic clk;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    booth_if #(.N(N)) intf (clk);

    booth_mult_top #(.N(N)) dut (
        .clk          (clk),
        .rst          (intf.rst),
        .start        (intf.start),
        .multiplicand (intf.multiplicand),
        .multiplier   (intf.multiplier),
        .product      (intf.product),
        .done         (intf.done)
    );

    initial begin
        uvm_config_db#(virtual booth_if)::set(null, "*", "vif", intf);
        run_test("booth_test");
    end

    initial begin
        #200000;
        `uvm_fatal("TB_TOP", "TIMEOUT - simulation did not finish in time")
    end

    initial begin
        $dumpfile("booth_mult.vcd");
        $dumpvars(0, tb_top);
    end

endmodule