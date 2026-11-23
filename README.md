# Parallel Word Count / Text Processing on Large Corpora

A high-performance parallel word frequency counter designed for multi-gigabyte text corpora.  
This project implements both a **sequential baseline** and an **MPI-based distributed parallel** version to demonstrate real-world speedup through parallel and distributed computing.

## Project Overview

**Course:** Parallel & Distributed Computing (PDC)  
**Objective:** Count every distinct word across a large text corpus using MPI, measure the parallel speedup, and analyze scaling efficiency.

### Key Features
- **Sequential baseline** with buffered I/O for files of any size
- **MPI parallel implementation** with intelligent file chunking and boundary-word resolution
- **Automated benchmarking** across varying process counts
- **Performance visualization** (speedup, efficiency, and scaling plots)

## Project Structure

```
parallel_word_count/
├── Makefile                  # Build system
├── README.md                 # This file
├── src/
│   ├── common/               # Shared modules (tokenizer, hash map, utilities)
│   ├── sequential/           # Sequential baseline implementation
│   └── mpi_parallel/         # MPI distributed parallel implementation
├── scripts/                  # Corpus generation, benchmarking, and plotting
├── tests/                    # Unit and correctness tests
├── data/                     # Input corpus files (not tracked by git)
└── results/                  # Benchmark outputs and graphs (not tracked by git)
```

## Building

**Prerequisites:** GCC, MPI (MPICH or OpenMPI), Python 3 (for scripts), Make

```bash
# Build both sequential and MPI versions
make all

# Build only sequential
make seq

# Build only MPI parallel
make mpi
```

## Running

```bash
# Sequential
./word_count_seq data/my_corpus.txt

# MPI Parallel (e.g., 4 processes)
mpirun -np 4 ./word_count_mpi data/my_corpus.txt
```

## Benchmarking

```bash
# Generate a synthetic test corpus
python3 scripts/generate_corpus.py --size 500MB --output data/test_500mb.txt

# Run automated benchmarks
python3 scripts/run_benchmark.py --input data/test_500mb.txt --procs 1,2,4,8

# Generate performance graphs
python3 scripts/plot_metrics.py --input results/benchmark.csv
```

## Performance Metrics

| Metric               | Formula                |
|-----------------------|------------------------|
| **Speedup**           | S = T_seq / T_parallel |
| **Efficiency**        | E = S / P              |
| **Amdahl's Speedup**  | S = 1 / (f + (1-f)/P) |

Where `T_seq` is sequential time, `T_parallel` is parallel time, `P` is process count, and `f` is the serial fraction.

## License

This project is developed for academic purposes.
