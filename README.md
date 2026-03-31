# nbody-parallel
COMPILE: make all



Parallel:
./nbody_par <input> <dt> <nbstep> <printevery> <nbthreads>

Sequential:
./nbody_seq <input> <dt> <nbstep> <printevery>

./nbody_par 1000 1 10000 100 4
./nbody_seq 1000 1 10000 100
./nbody_par planet 200 5000000 10000 4

Benchmark Results

Case         Seq (s)   Par 1 (s)   Par 4 (s)   Par 8 (s)   Speedup @4   Speedup @8
random100     0.75       0.93        1.72        4.18        0.44x        0.18x
random1000   70.34      67.85       28.40       26.81        2.48x        2.62x
solar         3.47      11.06       25.78       40.83        0.13x        0.08x

For the 100-particle case, the sequential version outperformed the parallel version because the workload was too small and thread/scheduling overhead dominated execution time. For the 1000-particle case, the parallel implementation showed clear speedup, with 4 threads achieving about 2.48x speedup and 8 threads achieving about 2.62x speedup over sequential. The solar-system case remained faster sequentially because it only contains 10 particles, so despite the large number of time steps, each step has too little work to benefit from parallelization.

S