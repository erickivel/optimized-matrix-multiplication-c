# Eric Kivel - GRR20220069 | Murilo Paes - GRR20190158

# Arquivos auxiliares
    - run.sh
        Gera todas as tabelas dos 13 tamanhos de matrizes;
    - plot.sh
        Gera os gráficos para cada tabela;
    - resultados/
        Tabela com os dados obtidos das funções com e sem
        otimização;
    - logs/
        Relatório do LIKWID;
    - graphs/
        Gráficos plotados a partir das tabelas.

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

--------------------------------------------------------------------------------
CPU name:	Intel(R) Core(TM) i5-7500 CPU @ 3.40GHz
CPU type:	Intel Coffeelake processor
CPU stepping:	9
********************************************************************************
Hardware Thread Topology
********************************************************************************
Sockets:		1
Cores per socket:	4
Threads per core:	1
--------------------------------------------------------------------------------
HWThread	Thread		Core		Socket		Available
0		0		0		0		*
1		0		1		0		*
2		0		2		0		*
3		0		3		0		*
--------------------------------------------------------------------------------
Socket 0:		( 0 1 2 3 )
--------------------------------------------------------------------------------
********************************************************************************
Cache Topology
********************************************************************************
Level:			1
Size:			32 kB
Type:			Data cache
Associativity:		8
Number of sets:		64
Cache line size:	64
Cache type:		Non Inclusive
Shared by threads:	1
Cache groups:		( 0 ) ( 1 ) ( 2 ) ( 3 )
--------------------------------------------------------------------------------
Level:			2
Size:			256 kB
Type:			Unified cache
Associativity:		4
Number of sets:		1024
Cache line size:	64
Cache type:		Non Inclusive
Shared by threads:	1
Cache groups:		( 0 ) ( 1 ) ( 2 ) ( 3 )
--------------------------------------------------------------------------------
Level:			3
Size:			6 MB
Type:			Unified cache
Associativity:		12
Number of sets:		8192
Cache line size:	64
Cache type:		Inclusive
Shared by threads:	4
Cache groups:		( 0 1 2 3 )
--------------------------------------------------------------------------------
********************************************************************************
NUMA Topology
********************************************************************************
NUMA domains:		1
--------------------------------------------------------------------------------
Domain:			0
Processors:		( 0 1 2 3 )
Distances:		10
Free memory:		5000.11 MB
Total memory:		7826.25 MB
--------------------------------------------------------------------------------


********************************************************************************
Graphical Topology
********************************************************************************
Socket 0:
+---------------------------------------------+
| +--------+ +--------+ +--------+ +--------+ |
| |    0   | |    1   | |    2   | |    3   | |
| +--------+ +--------+ +--------+ +--------+ |
| +--------+ +--------+ +--------+ +--------+ |
| |  32 kB | |  32 kB | |  32 kB | |  32 kB | |
| +--------+ +--------+ +--------+ +--------+ |
| +--------+ +--------+ +--------+ +--------+ |
| | 256 kB | | 256 kB | | 256 kB | | 256 kB | |
| +--------+ +--------+ +--------+ +--------+ |
| +-----------------------------------------+ |
| |                   6 MB                  | |
| +-----------------------------------------+ |
+---------------------------------------------+
