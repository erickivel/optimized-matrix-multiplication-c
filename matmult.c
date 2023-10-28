#include <getopt.h> /* getopt */
#include <stdio.h>
#include <stdlib.h> /* exit, malloc, calloc, etc. */
#include <string.h>
#include <time.h>

#include "matriz.h"

/**
 * Exibe mensagem de erro indicando forma de uso do programa e termina
 * o programa.
 */

static void usage(char *progname) {
  fprintf(stderr, "Forma de uso: %s [ <ordem> ] \n", progname);
  exit(1);
}

/**
 * Programa principal
 * Forma de uso: matmult [ -n <ordem> ]
 * -n <ordem>: ordem da matriz quadrada e dos vetores
 *
 */

int main(int argc, char *argv[]) {
  int n = DEF_SIZE;

  MatRow mRow_1, mRow_2, resMat, resMatOpt;
  Vetor vet, res, resOpt;

  /* =============== TRATAMENTO DE LINHA DE COMANDO =============== */

  if (argc < 2)
    usage(argv[0]);

  n = atoi(argv[1]);

  /* ================ FIM DO TRATAMENTO DE LINHA DE COMANDO ========= */

  srandom(20232);

  res = geraVetor(n, 1); // (real_t *) malloc (n*sizeof(real_t));
  resOpt = geraVetor(n, 1);
  resMat = geraMatRow(n, n, 1);
  resMatOpt = geraMatRow(n, n, 1);

  mRow_1 = geraMatRow(n, n, 0);
  mRow_2 = geraMatRow(n, n, 0);

  vet = geraVetor(n, 0);

  if (!res || !resMat || !resOpt || !resMatOpt || !mRow_1 || !mRow_2 || !vet) {
    fprintf(stderr, "Falha em alocação de memória !!\n");
    liberaVetor((void *)mRow_1);
    liberaVetor((void *)mRow_2);
    liberaVetor((void *)resMat);
    liberaVetor((void *)resMatOpt);
    liberaVetor((void *)vet);
    liberaVetor((void *)res);
    liberaVetor((void *)resOpt);
    exit(2);
  }

#ifdef _DEBUG_
  prnMat(mRow_1, n, n);
  prnMat(mRow_2, n, n);
  prnVetor(vet, n);
  printf("=================================\n\n");
#endif /* _DEBUG_ */

  multMatVet(mRow_1, vet, n, n, res);
  multMatVetOpt(mRow_1, vet, n, n, resOpt);

  multMatMat(mRow_1, mRow_2, n, resMat);
  multMatMatOpt(mRow_1, mRow_2, n, resMatOpt);

#ifdef _DEBUG_
  prnVetor(res, n);
  prnVetor(resOpt, n);
  prnMat(resMat, n, n);
  prnMat(resMatOpt, n, n);
#endif /* _DEBUG_ */

  liberaVetor((void *)mRow_1);
  liberaVetor((void *)mRow_2);
  liberaVetor((void *)resMat);
  liberaVetor((void *)resMatOpt);
  liberaVetor((void *)vet);
  liberaVetor((void *)res);
  liberaVetor((void *)resOpt);

  return 0;
}
