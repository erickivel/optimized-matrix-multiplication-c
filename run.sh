#!/bin/bash

# Eric Kivel - GRR20220069 | Murilo Paes - GRR20190158

METRICA="FLOPS_DP ENERGY MEM CACHE" 

make

echo "performance" > /sys/devices/system/cpu/cpufreq/policy3/scaling_governor

for k in $METRICA
do
  likwid-perfctr -C 3 -g ${k} -m ./matmult $1 > ${k}_resultado.log
done

echo "powersave" > /sys/devices/system/cpu/cpufreq/policy3/scaling_governor

printf "Resultado: \n" > resultado.out
./matmult $1 >> resultado.out
printf "\n" >> resultado.out

echo "Matrix x Matrix" >> resultado.out
cat FLOPS_DP_resultado.log | grep -m 1 "DP MFLOP/s" >> resultado.out
cat FLOPS_DP_resultado.log | grep -m 1 "DP MFLOP/s" >> resultado.out
cat ENERGY_resultado.log | grep -m 1 "Energy Core" >> resultado.out
printf "\n" >> resultado.out
echo "Matrix x Vector" >> resultado.out
cat FLOPS_DP_resultado.log | grep -m 2 "DP MFLOP/s" | tail -n 1 >> resultado.out
cat FLOPS_DP_resultado.log | grep -m 2 "DP MFLOP/s" | tail -n 1 >> resultado.out
cat ENERGY_resultado.log | grep -m 2 "Energy Core" | tail -n 1 >> resultado.out

make purge
