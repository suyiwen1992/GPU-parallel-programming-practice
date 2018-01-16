# GPU-parallel-programming-practice
Cuda stream:
Use four strams to optimize the vector add function. The execution time for stream method is 4-5 times speed up than the non-stream method. Because stream allow concurrent copying and kernel execution, so the kernel don’t need to wait all the be copied for computation. Also, we don’t need to wait for all output data to be computed, the output data can be copied form device to host in concurrency. So, the total time is reduced
