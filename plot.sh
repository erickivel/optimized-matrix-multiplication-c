#!/bin/sh

if [ ! -d "graps"]; then
  mkdir "graphs"
fi

OUT=("Energia_MVM" "Energia_MMM"
      "Cache_miss_L2_MVM" "Cache_miss_L2_MMM"
      "Banda_De_Memoria_MVM" "Banda_De_Memoria_MMM"
      "Tempo_Médio_MVM" "Tempo_Médio_MMM")

FILENAMES=("EnergyMatVet.csv" "EnergyMatMat.csv"
           "L2CacheMatMat.csv" "L2CacheMatVet.csv"
           "L3MatVet.csv" "L3MatMat.csv"
           "TempoMatVet.csv" "TempoMatMat.csv")

TITLES=("Energia MVM" "Energia MMM"
        "Cache miss L2 MVM" "Cache miss L2 MMM"
        "Banda De Memoria MVM" "Banda De Memoria MMM"
        "Tempo Médio MVM" "Tempo Médio MMM")

YLABELS=("Energia (joules)" "Energia (joules)"
         "Cache Miss L2 (ratio)" "Cache Miss L2 (ratio)"
         "Banda de Memória (MBYTE/s)" "Banda de Memória (MBYTE/s)"
         "Tempo (milisegundos)" "Tempo (milisegundos)")

for i in {0..7}
do
  gnuplot <<- EOM
  set terminal png size 1080, 1080 enhanced font 'Helvetica,20' linewidth 3
  set output "./graphs/${OUT[$i]}.png"
  set title "${TITLES[$i]}"
  set xlabel "Tamanho da matriz"
  set ylabel "${YLABELS[$i]}"
  set grid

  set datafile separator ","

  plot "./resultados/${FILENAMES[$i]}" \
          using 1:2 \
          w lp \
          lt 5 \
          lc 7 \
          title 'Sem otimização', \
       "./resultados/${FILENAMES[$i]}"\
          using 1:3 \
          w lp \
          lt 7 \
          lc 6 \
          title 'Com otimização'
EOM
done

gnuplot <<- EOM
set terminal png size 1080, 1080 enhanced font 'Helvetica,20' linewidth 3 
set output "./graphs/FLOPS_MMM.png"
set title "Operações Aritméticas MMM"
set xlabel "Tamanho da matriz"
set ylabel "MFLOP/s"
set grid

set datafile separator ","

plot "./resultados/AritmeticaMatMat.csv" \
        using 1:2 \
        w lp \
        lt 5 \
        lc 7 \
        title 'FLOPS DP Sem otimização', \
     "./resultados/AritmeticaMatMat.csv"\
        using 1:3 \
        w lp \
        lt 7 \
        lc 6 \
        title 'FLOPS DP Com otimização', \
     "./resultados/AritmeticaMatMat.csv"\
        using 1:4 \
        w lp \
        lt 7 \
        lc 9 \
        title 'FLOPS AVX Com otimização', \
     "./resultados/AritmeticaMatMat.csv"\
        using 1:5 \
        w lp \
        lt 7 \
        lc 4 \
        title 'FLOPS AVX Com otimização'
EOM

gnuplot <<- EOM
set terminal png size 1080, 1080 enhanced font 'Helvetica,20' linewidth 3
set output "./graphs/FLOPS_MVM.png"
set title "Operações Aritméticas MVM"
set xlabel "Tamanho da matriz"
set ylabel "MFLOP/s"
set grid

set datafile separator ","

plot "./resultados/AritmeticaMatMat.csv" \
        using 1:2 \
        w lp \
        lt 5 \
        lc 7 \
        title 'FLOPS DP Sem otimização', \
     "./resultados/AritmeticaMatVet.csv"\
        using 1:3 \
        w lp \
        lt 7 \
        lc 6 \
        title 'FLOPS DP Com otimização', \
     "./resultados/AritmeticaMatVet.csv"\
        using 1:4 \
        w lp \
        lt 7 \
        lc 9 \
        title 'FLOPS AVX Com otimização', \
     "./resultados/AritmeticaMatVet.csv"\
        using 1:5 \
        w lp \
        lt 7 \
        lc 4 \
        title 'FLOPS AVX Com otimização'
EOM
