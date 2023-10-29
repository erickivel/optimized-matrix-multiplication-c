# Eric Kivel - GRR20220069 | Murilo Paes - GRR20190158

# Otimizações realizadas

- Unroll & Jam
  Foi aplicado unroll & jam nas duas multiplicações, reduzindo assim o
  número de acessos ao vetor B; O unroll factor (UF) utilizado foi 4;

- Blocking
  Na multiplicação de matrizes foi aplicado o método de loop blocking
  com o tamanho de bloco (BK) 4 - Que é um multiplo do unroll factor (UF);

- Restrict
  Na declaração de parâmetros das duas funções foi utlizado o restrict antes 
  da declaração das mesmas, que junto com o "-O3" permite que o compilador
  otimize operações, pois considera que as matrizes sempre serão diferentes
  (considera que não há alias).
  
# Especificações da Arquitetura do processador (Dinf)
