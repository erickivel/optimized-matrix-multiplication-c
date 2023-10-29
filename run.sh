#!/bin/bash

# Eric Kivel - GRR20220069 | Murilo Paes - GRR20190158

Ns="64 100 128 200 256 512 600 900 1024 2000 2048 3000 4000"  
METRICA="FLOPS_DP ENERGY L3 L2CACHE" 
LOGS_FOLDER="logs/"
RESULT_FOLDER="resultados/"

if [ ! -d "${RESULT_FOLDER}" ]; then
  mkdir "${RESULT_FOLDER}"
fi

if [ ! -d "${LOGS_FOLDER}" ]; then
  mkdir "${LOGS_FOLDER}"
fi

make
echo "performance" > /sys/devices/system/cpu/cpufreq/policy3/scaling_governor

for n in $Ns
do
  for k in $METRICA
  do
    likwid-perfctr -C 3 -g ${k} -m ./matmult $n > ${LOGS_FOLDER}${k}_${n}.log
  done

  ./matmult $n > ${LOGS_FOLDER}TIME_${n}.log

  # Tempo 
    TIME_NAMES="TempoMatVet TempoMatMat"
    GROUP="TIME"
    for NAME in $TIME_NAMES
    do
      if [ ! -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        touch "${RESULT_FOLDER}${NAME}.csv"
      fi

      if [ -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        echo -n "$n," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -A 1 "Std_${NAME}" | tail -n 1 | tr -d '\n' >> "${RESULT_FOLDER}${NAME}.csv"
        echo -n "," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -A 1 "Opt_${NAME}" | tail -n 1 >> "${RESULT_FOLDER}${NAME}.csv"
      fi
    done

  # Mem 
    L3_NAMES="L3MatVet L3MatMat"
    GROUP="L3"
    i=1
    for NAME in $L3_NAMES
    do
      if [ ! -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        touch "${RESULT_FOLDER}${NAME}.csv"
      fi

      if [ -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        echo -n "$n," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "L3 bandwidth" | tail -n 1 | grep -oE '[0-9]+\.[0-9]+' | tr -d '\n' >> "${RESULT_FOLDER}${NAME}.csv"
        let "i+=1"
        echo -n "," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "L3 bandwidth" | tail -n 1 | grep -oE '[0-9]+\.[0-9]+'  >> "${RESULT_FOLDER}${NAME}.csv"
        let "i+=1"
      fi
    done

  # Cache 
    L2CACHE_NAMES="L2CacheMatVet L2CacheMatMat"
    GROUP="L2CACHE"
    i=1
    for NAME in $L2CACHE_NAMES
    do
      if [ ! -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        touch "${RESULT_FOLDER}${NAME}.csv"
      fi

      if [ -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        echo -n "$n," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "L2 miss ratio" | tail -n 1 | grep -oE '[0-9]+\.[0-9]+' | tr -d '\n' >> "${RESULT_FOLDER}${NAME}.csv"
        let "i+=1"
        echo -n "," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "L2 miss ratio" | tail -n 1 | grep -oE '[0-9]+\.[0-9]+' >> "${RESULT_FOLDER}${NAME}.csv"
        let "i+=1"
      fi
    done

  # Energy 
    ENERGY_NAMES="EnergyMatVet EnergyMatMat"
    GROUP="ENERGY"
    i=1
    for NAME in $ENERGY_NAMES
    do
      if [ ! -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        touch "${RESULT_FOLDER}${NAME}.csv"
      fi

      if [ -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        echo -n "$n," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "Energy \[J\]" | tail -n 1 | grep -oE '[0-9]+(\.[0-9]+)?' | tr -d '\n' >> "${RESULT_FOLDER}${NAME}.csv"
        let "i+=1"
        echo -n "," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "Energy \[J\]"| tail -n 1 | grep -oE '[0-9]+(\.[0-9]+)?' >> "${RESULT_FOLDER}${NAME}.csv"
        let "i+=1"
      fi
    done

  # Flops 
    FLOPS_NAMES="AritmeticaMatVet AritmeticaMatMat"
    GROUP="FLOPS_DP"
    i=1
    j=1
    for NAME in $FLOPS_NAMES
    do
      if [ ! -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        touch "${RESULT_FOLDER}${NAME}.csv"
      fi

      if [ -f "${RESULT_FOLDER}${NAME}.csv" ]; then
        echo -n "$n," >> "${RESULT_FOLDER}${NAME}.csv" 
        # DP
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "DP MFLOP\/s" | tail -n 1 | grep -oE '[0-9]+(\.[0-9]+)?' | tr -d '\n' >> "${RESULT_FOLDER}${NAME}.csv"
        let "i+=2"
        echo -n "," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $i "DP MFLOP\/s"| tail -n 1 | grep -oE '[0-9]+(\.[0-9]+)?' | tr -d '\n'>> "${RESULT_FOLDER}${NAME}.csv"
        echo -n "," >> "${RESULT_FOLDER}${NAME}.csv" 
        let "i+=2"

        # AVX
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $j "AVX DP MFLOP\/s" | tail -n 1 | grep -oE '[0-9]+(\.[0-9]+)?' | tr -d '\n' >> "${RESULT_FOLDER}${NAME}.csv"
        let "j+=1"
        echo -n "," >> "${RESULT_FOLDER}${NAME}.csv" 
        cat ${LOGS_FOLDER}${GROUP}_${n}.log | grep -m $j "AVX DP MFLOP\/s"| tail -n 1 | grep -oE '[0-9]+(\.[0-9]+)?'>> "${RESULT_FOLDER}${NAME}.csv"
        let "j+=1"
      fi
    done
done

echo "powersave" > /sys/devices/system/cpu/cpufreq/policy3/scaling_governor
make clean
