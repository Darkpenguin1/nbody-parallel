#!/bin/bash
#SBATCH --job-name=nbody-r100
#SBATCH --partition=Centaurus
#SBATCH --time=00:30:00
#SBATCH --output=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err
#SBATCH --mem=20GB
#SBATCH --cpus-per-task=8

set -euo pipefail

mkdir -p logs results

echo "=== Job started at $(date) ==="
echo "Node: $(hostname)"
echo "CPUs allocated: ${SLURM_CPUS_PER_TASK:-unknown}"
echo

echo "=== Building programs ==="
make clean >/dev/null 2>&1 || true
make

SUMMARY="results/summary-random100-${SLURM_JOB_ID}.tsv"
echo -e "case\tmode\tthreads\tdt\tnbstep\tprintevery\ttime_seconds\toutput_file" > "$SUMMARY"

run_seq() {
    local label="$1"
    local input="$2"
    local dt="$3"
    local nbstep="$4"
    local printevery="$5"
    local outfile="results/${label}_seq.out"

    echo "=== Running SEQ: ${label} ==="
    echo "Command: ./nbody_seq ${input} ${dt} ${nbstep} ${printevery}"

    {
        echo "START $(date)"
        /usr/bin/time -f "TIME_SECONDS\t%e" ./nbody_seq "${input}" "${dt}" "${nbstep}" "${printevery}"
        echo "END $(date)"
    } > "$outfile" 2>&1

    local runtime
    runtime=$(grep 'TIME_SECONDS' "$outfile" | tail -n1 | awk '{print $2}')
    echo -e "${label}\tseq\t1\t${dt}\t${nbstep}\t${printevery}\t${runtime}\t${outfile}" >> "$SUMMARY"
}

run_par() {
    local label="$1"
    local input="$2"
    local dt="$3"
    local nbstep="$4"
    local printevery="$5"
    local threads="$6"
    local outfile="results/${label}_par_${threads}.out"

    echo "=== Running PAR: ${label} with ${threads} thread(s) ==="
    echo "Command: ./nbody_par ${input} ${dt} ${nbstep} ${printevery} ${threads}"

    {
        echo "START $(date)"
        /usr/bin/time -f "TIME_SECONDS\t%e" ./nbody_par "${input}" "${dt}" "${nbstep}" "${printevery}" "${threads}"
        echo "END $(date)"
    } > "$outfile" 2>&1

    local runtime
    runtime=$(grep 'TIME_SECONDS' "$outfile" | tail -n1 | awk '{print $2}')
    echo -e "${label}\tpar\t${threads}\t${dt}\t${nbstep}\t${printevery}\t${runtime}\t${outfile}" >> "$SUMMARY"
}

run_seq "random100" "100" "1" "10000" "100"
for t in 1 4 8; do
    run_par "random100" "100" "1" "10000" "100" "$t"
done

echo
echo "=== Benchmark summary ==="
column -t -s $'\t' "$SUMMARY" || cat "$SUMMARY"
echo
echo "Summary written to: $SUMMARY"
echo "=== Job finished at $(date) ==="