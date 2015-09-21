#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cstdio>
#include <cublas_v2.h>

// 1-D row major index
#define IDX2R(i,j,w) (((i)*(w))+(j))
// 1-D column major index
#define IDX2C(i,j,h) (((j)*(h))+(i))

void printMatrix(double *h_M, int height, int width) {
	for (int i=0; i < height; i++) {
		for (int j=0; j < width; j++)
			std::cout << h_M[i * width + j] << ' ';
		std::cout << std::endl;
	}
	std::cout << std::endl;
}

void printMatrix(int *h_M, int height, int width) {
	for (int i=0; i < height; i++) {
		for (int j=0; j < width; j++)
			std::cout << h_M[i * width + j] << ' ';
		std::cout << std::endl;
	}
	std::cout << std::endl;
}

int main() {
	// cuBLAS handle
	cublasHandle_t handle;
	cublasCreate(&handle);
	
	int m = 2;
	int k = 3;
	int n = 4;
	
	double *A = (double *)malloc(k*m*sizeof(double));
	double *B = (double *)malloc(k*n*sizeof(double));
	double *C = (double *)malloc(m*n*sizeof(double));
	
	double *d_A, *d_B, *d_C;
	cudaMalloc(&d_A, k*m*sizeof(double));
	cudaMalloc(&d_B, k*n*sizeof(double));
	cudaMalloc(&d_C, m*n*sizeof(double));
	
	for (int i = 0; i < k*m; i++)	A[i] = i;
	for (int i = 0; i < k*n; i++)	B[i] = 1.0;
	
	printMatrix(A, m, k);
	printMatrix(B, k, n);
	
	cudaMemcpy(d_A, A, k*m*sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, k*n*sizeof(double), cudaMemcpyHostToDevice);
	
	double alpha = 1.0;
	double beta = 0.0;
	cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, &alpha, d_A, k, d_B, n, &beta, d_C, n);
	
	cudaMemcpy(C, d_C, m*n*sizeof(double), cudaMemcpyDeviceToHost);
	

	printMatrix(C, m, n);

	
	return 0;

}


