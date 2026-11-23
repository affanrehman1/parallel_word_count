# ==============================================================================
# Parallel Word Count - Makefile
# ==============================================================================
# Build system for sequential and MPI-parallel word count implementations.
#
# Usage:
#   make seq          - Build the sequential version
#   make mpi          - Build the MPI parallel version
#   make all          - Build both versions
#   make clean        - Remove all build artifacts
#   make test_seq     - Build and run sequential version on a small test file
#   make test_mpi     - Build and run MPI version on a small test file (4 procs)
# ==============================================================================

# --- Compiler Configuration ---
CC        = gcc
MPICC     = mpicc
CFLAGS    = -Wall -Wextra -O2 -std=c99
LDFLAGS   = -lm

# --- Directories ---
SRC_DIR       = src
COMMON_DIR    = $(SRC_DIR)/common
SEQ_DIR       = $(SRC_DIR)/sequential
MPI_DIR       = $(SRC_DIR)/mpi_parallel
TEST_DIR      = tests
DATA_DIR      = data

# --- Source Files ---
COMMON_SRC    = $(wildcard $(COMMON_DIR)/*.c)
COMMON_OBJ    = $(COMMON_SRC:.c=.o)

SEQ_SRC       = $(wildcard $(SEQ_DIR)/*.c)
SEQ_OBJ       = $(SEQ_SRC:.c=.o)

MPI_SRC       = $(wildcard $(MPI_DIR)/*.c)
MPI_OBJ       = $(MPI_SRC:.c=.o)

# --- Output Executables ---
SEQ_BIN       = word_count_seq
MPI_BIN       = word_count_mpi

# --- Default Target ---
.PHONY: all seq mpi clean test_seq test_mpi help

all: seq mpi

# --- Sequential Build ---
seq: $(SEQ_BIN)

$(SEQ_BIN): $(SEQ_OBJ) $(COMMON_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# --- MPI Build ---
mpi: $(MPI_BIN)

$(MPI_BIN): $(MPI_OBJ) $(COMMON_OBJ)
	$(MPICC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# --- Compile Rules ---
$(COMMON_DIR)/%.o: $(COMMON_DIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(SEQ_DIR)/%.o: $(SEQ_DIR)/%.c
	$(CC) $(CFLAGS) -I$(COMMON_DIR) -c -o $@ $<

$(MPI_DIR)/%.o: $(MPI_DIR)/%.c
	$(MPICC) $(CFLAGS) -I$(COMMON_DIR) -c -o $@ $<

# --- Quick Test Targets ---
test_seq: $(SEQ_BIN)
	@echo "=== Running Sequential Word Count ==="
	./$(SEQ_BIN) $(DATA_DIR)/sample.txt

test_mpi: $(MPI_BIN)
	@echo "=== Running MPI Word Count (4 processes) ==="
	mpirun -np 4 ./$(MPI_BIN) $(DATA_DIR)/sample.txt

# --- Cleanup ---
clean:
	rm -f $(COMMON_DIR)/*.o $(SEQ_DIR)/*.o $(MPI_DIR)/*.o
	rm -f $(SEQ_BIN) $(MPI_BIN)

# --- Help ---
help:
	@echo "Available targets:"
	@echo "  make all       - Build sequential and MPI versions"
	@echo "  make seq       - Build sequential version only"
	@echo "  make mpi       - Build MPI version only"
	@echo "  make test_seq  - Build and run sequential test"
	@echo "  make test_mpi  - Build and run MPI test (4 processes)"
	@echo "  make clean     - Remove build artifacts"
