# MIPS-pipelined-cpu

A 5 stage pipelined MIPS processor in Verilog (Vivado).

## Features

* A 5 stage pipeline supporting Instruction Level Parallelism.
* Support for data forwarding and control hazard handling.

## Pipeline Design
<img width="789" height="330" alt="image" src="https://github.com/user-attachments/assets/3ec9618b-d99d-413f-abe2-cd35ff6fa3da" />

## Performance Comparison

The first two bars show the performance difference between single cycle vs pipelined CPU design. Single cycle executes all pipelines for one instruction before the next instruction can begin, thereby limiting instruction level parallelism.

![CMPE_200_Assignment_7](https://github.com/user-attachments/assets/78487b27-6df8-4a68-8c37-fe94c7549ec6)

