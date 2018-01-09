/******************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

#include <stdio.h>
    

__global__ void VecAdd(int n, const float *A, const float *B, float* C) {

    /********************************************************************
     *
     * Compute C = A + B
     *   where A is a (1 * n) vector
     *   where B is a (1 * n) vector
     *   where C is a (1 * n) vector
     *
     ********************************************************************/

    // INSERT KERNEL CODE HERE
    int index=blockIdx.x*blockDim.x+threadIdx.x;
    if(index<n){
    C[index]=A[index]+B[index];}
     
}


void basicVecAdd( float *A,  float *B, float *C, int n)
{

    // Initialize thread block and kernel grid dimensions ---------------------

    const unsigned int BLOCK_SIZE = 512; 
    //INSERT CODE HERE
	int blocksize = 256;
    VecAdd<<<(n-1)/blocksize+1,blocksize>>>(n,A,B,C);
}

