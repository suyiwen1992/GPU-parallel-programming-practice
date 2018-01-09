/******************************************************************************
 *cr
 *cr            (C) Copyright 2010 The Board of Trustees of the
 *cr                        University of Illinois
 *cr                         All Rights Reserved
 *cr
 ******************************************************************************/

#define BLOCK_SIZE 1024 

// Define your kernels in this file you may use more than one kernel if you
// need to

// INSERT KERNEL(S) HERE
__global__ void Scan1(float *out, float *in,unsigned in_size)
{
   __shared__ float XY[2*BLOCK_SIZE];
   int i=threadIdx.x;
   int j=(blockIdx.x*blockDim.x)*2;
   if(i+j<in_size&&i+j>0) {
        XY[threadIdx.x]=in[i+j-1];
   }else{
        XY[threadIdx.x]=0.0;     
   }
   if (i+j+blockDim.x<in_size){
        XY[threadIdx.x+blockDim.x]=in[i+j+blockDim.x-1];
   }else{
        XY[threadIdx.x+blockDim.x]=0.0;
   }
   __syncthreads();
   for(unsigned int stride=1;stride<=BLOCK_SIZE;stride*=2){
       int index=(threadIdx.x+1)*stride*2-1;
       if(index<2*BLOCK_SIZE){ XY[index]+=XY[index-stride];}
       __syncthreads();


    }

    for(unsigned int stride=BLOCK_SIZE/2;stride>0;stride/=2){
        __syncthreads();
        int index=(threadIdx.x+1)*stride*2-1;
        if(index+stride<2*BLOCK_SIZE){
           XY[index+stride]+=XY[index];
         }

     }
     __syncthreads();
     if(i+j<in_size) out[i+j]=XY[threadIdx.x];
     if(i+j+blockDim.x<in_size) out[i+j+blockDim.x]=XY[i+blockDim.x];
     __syncthreads();
     if(i==BLOCK_SIZE-1&&j+i<in_size) in[blockIdx.x]=XY[i+blockDim.x];
     __syncthreads();

}

__global__ void Scan2(float *out, float *in,unsigned in_size)
{
   __shared__ float XY[2*BLOCK_SIZE];
   int i=threadIdx.x;
   int j=(blockIdx.x*blockDim.x)*2;
   if(i+j<in_size) {
        XY[threadIdx.x]=in[i+j];
    }else{
        XY[threadIdx.x]=0.0;
   }
   if (i+j+blockDim.x<in_size){
        XY[threadIdx.x+blockDim.x]=in[i+j+blockDim.x];
   }else{
        XY[threadIdx.x+blockDim.x]=0.0;
   }


   __syncthreads();
   for(unsigned int stride=1;stride<=BLOCK_SIZE;stride*=2){
       int index=(threadIdx.x+1)*stride*2-1;
       if(index<2*BLOCK_SIZE) XY[index]+=XY[index-stride];
       __syncthreads();


    }

    for(unsigned int stride=BLOCK_SIZE/2;stride>0;stride/=2){
        __syncthreads();
        int index=(threadIdx.x+1)*stride*2-1;
        if(index+stride<2*BLOCK_SIZE){
           XY[index+stride]+=XY[index];
         }

     }
     __syncthreads();
     if(i+j<in_size) out[i+j]=XY[threadIdx.x];
     if(i+j+blockDim.x<in_size) out[i+j+blockDim.x]=XY[i+blockDim.x];
    // if(i=BLOCK_SIZE-1) array[blockIdx.x]=out[j+i];
     __syncthreads();







}

__global__ void Add(float *arr_out, float *out, int in_size){

    __shared__ float XY[2*BLOCK_SIZE];
    __shared__ float ARR;

   int i=threadIdx.x;
   int j=(blockIdx.x*blockDim.x)*2;
   if(i+j<in_size) {
        XY[threadIdx.x]=out[i+j];
   }else{
        XY[threadIdx.x]=0.0;
   }
   if (i+j+blockDim.x<in_size){
        XY[threadIdx.x+blockDim.x]=out[i+j+blockDim.x];
   }else{
        XY[threadIdx.x+blockDim.x]=0.0;
   }
 //  __syncthreads();

   if(blockIdx.x>0) ARR=arr_out[blockIdx.x-1];
   __syncthreads();
    if(blockIdx.x>0){
      if(i+j<in_size)
          XY[threadIdx.x] +=ARR;
      if(i+j+blockDim.x<in_size)
          XY[threadIdx.x+blockDim.x]+=ARR;
      __syncthreads();
    }

   // if(blockIdx.x==1) XY[i]+=300;
    __syncthreads();
    if(i+j<in_size) out[i+j]=XY[threadIdx.x];
    if(i+j+blockDim.x<in_size) out[i+j+blockDim.x]=XY[threadIdx.x+blockDim.x];
    __syncthreads();



}









/******************************************************************************
Setup and invoke your kernel(s) in this function. You may also allocate more
GPU memory if you need to
*******************************************************************************/
void preScan(float *out, float *in, unsigned in_size)
{
    // INSERT CODE HERE
  //  float *array_h,*arr_out_h;
   // float *array_d,*arr_out_d;
    int arr_size=(in_size/2-1)/BLOCK_SIZE+1;
   // array = (float*)calloc(arr_size, sizeof(float));
   // arr_out_h=(float*)calloc(arr_size,sizeof(float));
  //  cudaMalloc((void**)&array_,sizeof(float)*VecSize);
   // int arr_size=(in_size/2-1)/BLOCK_SIZE;
    Scan1<<<(in_size/2)/BLOCK_SIZE+1,BLOCK_SIZE>>>(out,in,in_size);
     // Scan<<<512,512>>>(out,in,in_size);
    Scan2<<<(arr_size/2)/BLOCK_SIZE+1,BLOCK_SIZE>>>(in,in,arr_size);

    Add<<<(in_size/2)/BLOCK_SIZE+1,BLOCK_SIZE>>>(in,out,in_size);


















}

