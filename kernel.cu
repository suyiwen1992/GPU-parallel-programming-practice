/******************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

#define BLOCK_SIZE 512

__global__ void reduction(float *out, float *in, unsigned size)
{
    /********************************************************************
    Load a segment of the input vector into shared memory
    Traverse the reduction tree
    Write the computed sum to the output vector at the correct index
    ********************************************************************/

    // INSERT KERNEL CODE HERE
    __shared__ float Sum[2*BLOCK_SIZE]; 
    unsigned int t=threadIdx.x;
    unsigned int start=2*blockIdx.x*blockDim.x;
    if(start+t<size){
      Sum[t]=in[start+t];
    }else{
      Sum[t]=0.0;
    }
    if(start+blockDim.x+t<size){
       Sum[blockDim.x+t]=in[start+blockDim.x+t];
     }else{
      Sum[blockDim.x+t]=0.0;
    }
    __syncthreads();
    for(unsigned int stride=BLOCK_SIZE;stride>=1;stride=stride/2){
           __syncthreads();
           if(threadIdx.x<stride){
              Sum[t]=Sum[t]+Sum[t+stride];
             }
     }
     __syncthreads();
     if(threadIdx.x==0){
        out[blockIdx.x]=Sum[0];}
    






























}
