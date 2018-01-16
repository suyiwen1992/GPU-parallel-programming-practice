# GPU-parallel-programming-practice
Reduction method using GPU parallel programming
For better reduction method, in each step, threads satisfy threadId.x<stride will do the add operation and other threads won’t do the operation. So, when stride is a multiple of warp size 32, no divergence will exhibit. Otherwise, it will exhibit divergence.
In my code, better reduction method is implemented and the divergence is reduced. The block size is 512. In the first step, stride is 512, so no divergence exhibit. In the second step, stride is 256, so no divergence exhibit. When at the six step, stride is 16, one warp will have divergence in each block. So, in the first five steps, no divergence will exhibit. When step is larger than 5, divergence will exhibit.
