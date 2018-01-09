/******************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "kernel.cu"
#include "support.cu"

int main (int argc, char *argv[])
{
    //set standard seed
    srand(217);

    Timer timer;
   cudaError_t cuda_ret;
   Timer timeExe;

//   float elapstimeforExe = 0;
    // Initialize host variables ----------------------------------------------

    printf("\nSetting up the problem..."); fflush(stdout);
    startTime(&timer);

    float *A_h, *B_h, *C_h;
   // float *A0_d, *B0_d, *C0_d;
   // float *A1_d, *B1_d, *C1_d;
    size_t A_sz, B_sz, C_sz;
    unsigned VecSize;
   
    dim3 dim_grid, dim_block;

    if (argc == 1) {
        VecSize = 1000000;

      } else if (argc == 2) {
      VecSize = atoi(argv[1]);   
      
      
      }
  
      else {
        printf("\nOh no!\nUsage: ./vecAdd <Size>");
        exit(0);
    }

    A_sz = VecSize;
    B_sz = VecSize;
    C_sz = VecSize;
 /*   A_h = (float*) malloc( sizeof(float)*A_sz );
    for (unsigned int i=0; i < A_sz; i++) { A_h[i] = (rand()%100)/100.00; }

    B_h = (float*) malloc( sizeof(float)*B_sz );
    for (unsigned int i=0; i < B_sz; i++) { B_h[i] = (rand()%100)/100.00; }

    C_h = (float*) malloc( sizeof(float)*C_sz );*/

    cudaHostAlloc((void **) &A_h, A_sz*sizeof(float),cudaHostAllocDefault);
    for (unsigned int i=0; i < A_sz; i++) { A_h[i] = (rand()%100)/100.00; }

    cudaHostAlloc((void **) &B_h, B_sz*sizeof(float),cudaHostAllocDefault); 
    for (unsigned int i=0; i < B_sz; i++) { B_h[i] = (rand()%100)/100.00; }

    cudaHostAlloc((void **) &C_h, C_sz*sizeof(float),cudaHostAllocDefault);

    stopTime(&timer); printf("%f s\n", elapsedTime(timer));
    printf("    size Of vector: %u x %u\n  ", VecSize,1);

    // Allocate device variables ----------------------------------------------

    printf("Allocating device variables..."); fflush(stdout);
//    startTime(&timer);
    

    float *A0_d, *B0_d, *C0_d;
    float *A1_d, *B1_d, *C1_d;
    float *A2_d, *B2_d, *C2_d;
    float *A3_d, *B3_d, *C3_d;
    float *A_d, *B_d, *C_d;
    int SegSize=VecSize/4;
    cudaMalloc((void**)&A0_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&B0_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&C0_d,sizeof(float)*SegSize);

    cudaMalloc((void**)&A1_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&B1_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&C1_d,sizeof(float)*SegSize);

    cudaMalloc((void**)&A2_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&B2_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&C2_d,sizeof(float)*SegSize);

    cudaMalloc((void**)&A3_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&B3_d,sizeof(float)*SegSize);
    cudaMalloc((void**)&C3_d,sizeof(float)*SegSize);


    cudaMalloc((void**)&A_d,sizeof(float)*4*SegSize);
    cudaMalloc((void**)&B_d,sizeof(float)*4*SegSize);
    cudaMalloc((void**)&C_d,sizeof(float)*4*SegSize);

    cudaDeviceSynchronize();
    // Initialize thread block and kernel grid dimensions ---------------------
    cudaStream_t stream0,stream1,stream2,stream3;
    cudaStreamCreate(&stream0);
    cudaStreamCreate(&stream1);
    cudaStreamCreate(&stream2);
    cudaStreamCreate(&stream3);

    // Timer timer;
     startTime(&timeExe);

     int blocksize=256;
     int num=VecSize/(SegSize*4);
     int i=0;
 
    
    //INSERT CODE HERE
  //  basicVecAdd(A_h,B_h,C_h,VecSize);

    for(int j=0;j<num;j++){

             cudaMemcpyAsync(A0_d,A_h+i,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream0);
             cudaMemcpyAsync(B0_d,B_h+i,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream0);
             cudaMemcpyAsync(A1_d,A_h+i+SegSize,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream1);
             cudaMemcpyAsync(B1_d,B_h+i+SegSize,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream1);

            VecAdd<<<(SegSize-1)/blocksize+1,blocksize,0,stream0>>>(SegSize,A0_d,B0_d,C0_d);
            VecAdd<<<(SegSize-1)/blocksize+1,blocksize,0,stream1>>>(SegSize,A1_d,B1_d,C1_d);

            cudaMemcpyAsync(C_h+i,C0_d,SegSize*sizeof(float),cudaMemcpyDeviceToHost,stream0);
            cudaMemcpyAsync(C_h+i+SegSize,C1_d,SegSize*sizeof(float),cudaMemcpyDeviceToHost,stream1);


             cudaMemcpyAsync(A2_d,A_h+i+2*SegSize,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream2);
             cudaMemcpyAsync(B2_d,B_h+i+2*SegSize,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream2);
             cudaMemcpyAsync(A3_d,A_h+i+3*SegSize,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream3);
             cudaMemcpyAsync(B3_d,B_h+i+3*SegSize,SegSize*sizeof(float),cudaMemcpyHostToDevice,stream3);


            VecAdd<<<(SegSize-1)/blocksize+1,blocksize,0,stream2>>>(SegSize,A2_d,B2_d,C2_d);
            VecAdd<<<(SegSize-1)/blocksize+1,blocksize,0,stream3>>>(SegSize,A3_d,B3_d,C3_d);


            cudaMemcpyAsync(C_h+i+2*SegSize,C2_d,SegSize*sizeof(float),cudaMemcpyDeviceToHost,stream2);
            cudaMemcpyAsync(C_h+i+3*SegSize,C3_d,SegSize*sizeof(float),cudaMemcpyDeviceToHost,stream3);
            i+=4*SegSize;
      }
       if(i<VecSize){
           cudaMemcpy(A_d,A_h+i,sizeof(float)*(VecSize-i),cudaMemcpyHostToDevice);
           cudaMemcpy(B_d,B_h+i,sizeof(float)*(VecSize-i),cudaMemcpyHostToDevice);

             VecAdd<<<(VecSize-i-1)/blocksize+1,blocksize>>>(VecSize-i,A_d,B_d,C_d);


             cudaMemcpy(C_h+i,C_d,(VecSize-i)*sizeof(float),cudaMemcpyDeviceToHost);}

      stopTime(&timeExe);printf("\n Execution time is %f s\n",elapsedTime(timeExe));

  cuda_ret = cudaDeviceSynchronize();
	if(cuda_ret != cudaSuccess) FATAL("Unable to launch kernel");
  //  stopTime(&timer); printf("Excution time is: %f s\n", elapsedTime(timer));
    // Verify correctness -----------------------------------------------------

    printf("Verifying results..."); fflush(stdout);

    verify(A_h, B_h, C_h, VecSize);


    // Free memory ------------------------------------------------------------

    cudaFreeHost(A_h);
    cudaFreeHost(B_h);
    cudaFreeHost(C_h);
   cudaFree(A0_d);
    cudaFree(B0_d);
    cudaFree(C0_d);
    cudaFree(A1_d);
    cudaFree(B1_d);
    cudaFree(C1_d);
   cudaFree(A2_d);
    cudaFree(B2_d);
    cudaFree(C2_d);
    cudaFree(A3_d);
    cudaFree(B3_d);
    cudaFree(C3_d);

    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);
    //INSERT CODE HERE
   // cudaFree(A0_d);
   // cudaFree(B0_d);
   // cudaFree(C0_d);
   // cudaFree(A1_d);
   // cudaFree(B1_d);
   // cudaFree(C1_d);   
    return 0;

}
