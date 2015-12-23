#include <iostream>
#include <cstdlib>
#include <vector>

#include "timer.hpp"

// Convenience function for checking CUDA runtime API results
// can be wrapped around any runtime API call. No-op in release builds.
inline
cudaError_t checkCuda(cudaError_t result)
{
#if defined(DEBUG) || defined(_DEBUG)
  if (result != cudaSuccess) {
    fprintf(stderr, "CUDA Runtime Error: %sn", cudaGetErrorString(result));
    assert(result == cudaSuccess);
  }
#endif
  return result;
}


__global__ void add(double *a, double *b, double *c)
{
  int i = blockDim.x * blockIdx.x + threadIdx.x;
  a[i] = b[i] + c[i];
}



template <typename T>
void runTest(int deviceId, int blocknum)
{
  T *d_a;
  T *d_b;
  T *d_c;

  int N = blocknum*256;

  std::vector<T> vec_init(N);

  // NB:  d_a(33*nMB) for stride case
  checkCuda( cudaMalloc(&d_a, N * sizeof(T)) );
  checkCuda( cudaMalloc(&d_b, N * sizeof(T)) );
  checkCuda( cudaMalloc(&d_c, N * sizeof(T)) );

  checkCuda( cudaMemcpy(&d_a, &(vec_init[0]), N * sizeof(T), cudaMemcpyHostToDevice) );
  checkCuda( cudaMemcpy(&d_b, &(vec_init[0]), N * sizeof(T), cudaMemcpyHostToDevice) );
  checkCuda( cudaMemcpy(&d_c, &(vec_init[0]), N * sizeof(T), cudaMemcpyHostToDevice) );

  add<<<blocknum, 256>>>(d_a, d_b, d_c); // warm up
  cudaDeviceSynchronize();

  viennacl::tools::timer timer;
  timer.start();
  for (int n = 0; n < 10; ++n)
  {
    add<<<blocknum, 256>>>(d_a, d_b, d_c);
  }
  cudaDeviceSynchronize();
  double bandwidth = 30 * N * sizeof(double) / timer.get() / 1e9;
  std::cout << N << "    " << bandwidth << "     " << timer.get() << std::endl;


  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
}

int main(int argc, char **argv)
{
  int deviceId = 0;
  cudaDeviceProp prop;

  checkCuda( cudaGetDeviceProperties(&prop, deviceId) );
  std::cout << "Device: " << prop.name << std::endl;
  std::cout << "#Size   Bandwidth (GB/s)    Time (sec)" << std::endl;

  for (int blocks=1; blocks<20000; blocks *= 2)
    runTest<double>(deviceId, blocks);

  return EXIT_SUCCESS;
}
