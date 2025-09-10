# Introduction

This repo is a fork of https://github.com/microsoft/FASTER. The purpose of this for is to build FASTER c++ with the zig build system and make it available as an importable zig package so it can be used by the zig build system when building other projects. The repo DOES NOT contain zig language compatible bindings.


# What is FASTER?

Managing large application state easily, resiliently, and with high performance is one of the hardest
problems in the cloud today. The FASTER project offers two artifacts to help tackle this problem.

* **FASTER Log** is a high-performance concurrent persistent recoverable log, iterator, and random 
reader library in C#. It supports very frequent commit operations at low latency, and can quickly saturate 
disk bandwidth. It supports both sync and async interfaces, handles disk errors, and supports checksums.

* **FASTER KV** is a concurrent key-value store + cache (available in C# and C++) that is designed for point 
lookups and heavy updates. FASTER supports data larger than memory, by leveraging fast external 
storage (local or cloud). It also supports consistent recovery using a fast non-blocking checkpointing technique 
that lets applications trade-off performance for commit latency.

Both FASTER KV and FASTER Log offer orders-of-magnitude higher performance than comparable solutions, on standard
workloads. Start learning about FASTER, its unique capabilities, and how to get started at our official website:

[aka.ms/FASTER](https://aka.ms/FASTER)



# Build

## System Dependencies
The library depends on the following system libraries
- uuid
- aio
- tbb

If on Ubuntu 24.04 the following commands were needed to setup env for build

- sudo apt-get install uuid-dev
- sudo apt-get install libaio1t64 libaio-dev
- sudo apt install libtbb-dev

## Build System
The build system used is `zig` version `0.15.1`. Download from https://ziglang.org/download/ and add to path.

## Build Command
`zig build`