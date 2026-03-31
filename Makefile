CXXFLAGS = -O3 -fopenmp

nbody_par: nbody_par.cpp
	g++ $(CXXFLAGS) nbody_par.cpp -o nbody_par

nbody_seq: nbody_seq.cpp
	g++ -O3 nbody_seq.cpp -o nbody_seq

solar_seq.out: nbody_seq
	date
	./nbody_seq planet 200 5000000 10000 > solar_seq.out
	date

solar_par_1.out: nbody_par
	date
	./nbody_par planet 200 5000000 10000 1 > solar_par_1.out
	date

solar_par_2.out: nbody_par
	date
	./nbody_par planet 200 5000000 10000 2 > solar_par_2.out
	date

solar_par_4.out: nbody_par
	date
	./nbody_par planet 200 5000000 10000 4 > solar_par_4.out
	date

CXXFLAGS = -O3 -fopenmp

nbody_par: nbody_par.cpp
	g++ $(CXXFLAGS) nbody_par.cpp -o nbody_par

nbody_seq: nbody_seq.cpp
	g++ -O3 nbody_seq.cpp -o nbody_seq


solar_seq.out: nbody_seq
	date > solar_seq.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_seq planet 200 5000000 10000 >> solar_seq.out 2>&1
	date >> solar_seq.out

solar_par_1.out: nbody_par
	date > solar_par_1.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_par planet 200 5000000 10000 1 >> solar_par_1.out 2>&1
	date >> solar_par_1.out

solar_par_2.out: nbody_par
	date > solar_par_2.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_par planet 200 5000000 10000 2 >> solar_par_2.out 2>&1
	date >> solar_par_2.out

solar_par_4.out: nbody_par
	date > solar_par_4.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_par planet 200 5000000 10000 4 >> solar_par_4.out 2>&1
	date >> solar_par_4.out


random100_seq.out: nbody_seq
	date > random100_seq.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_seq 100 1 10000 100 >> random100_seq.out 2>&1
	date >> random100_seq.out

random100_par_4.out: nbody_par
	date > random100_par_4.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_par 100 1 10000 100 4 >> random100_par_4.out 2>&1
	date >> random100_par_4.out


random1000_seq.out: nbody_seq
	date > random1000_seq.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_seq 1000 1 10000 100 >> random1000_seq.out 2>&1
	date >> random1000_seq.out

random1000_par_4.out: nbody_par
	date > random1000_par_4.out
	/usr/bin/time -f "TIME: %e seconds" ./nbody_par 1000 1 10000 100 4 >> random1000_par_4.out 2>&1
	date >> random1000_par_4.out