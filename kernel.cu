/******************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

// Define your kernels in this file you may use more than one kernel if you
// need to

// INSERT KERNEL(S) HERE
__global__ void histogram_kernel(unsigned int* input, unsigned int* bin, unsigned int num_elements, unsigned int num_bins){
         extern __shared__ unsigned int histogram_private[];
          int j=threadIdx.x;
         while (j<num_bins) {
            histogram_private[j]=0;
            j+=blockDim.x;
           }
          __syncthreads();

          int i=threadIdx.x+blockIdx.x*blockDim.x;
          int stride=blockDim.x*gridDim.x;
          while(i<num_elements){

               atomicAdd(&(histogram_private[input[i]]),1);

               i+=stride;
          }
          __syncthreads();
          int k=threadIdx.x;
          while(k<num_bins){
               atomicAdd(&(bin[k]), histogram_private[k]);
               k+=blockDim.x;
          }

} 





















/******************************************************************************
Setup and invoke your kernel(s) in this function. You may also allocate more
GPU memory if you need to
*******************************************************************************/
void histogram(unsigned int* input, unsigned int* bins, unsigned int num_elements,
        unsigned int num_bins) {

    // INSERT CODE HERE

          const unsigned int BLOCK_SIZE=512;
           
          histogram_kernel<<<BLOCK_SIZE,BLOCK_SIZE,num_bins*sizeof(unsigned int)>>>(input,bins,num_elements,num_bins);

















}


