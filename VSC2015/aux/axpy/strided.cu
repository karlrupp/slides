#include <iostream>
#include <cstdlib>

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


__global__ void offset(double *a, double *b, int s)
{
  int i = blockDim.x * blockIdx.x + threadIdx.x + s;
  b[i] = a[i] + 1;
}


__global__ void stride(double *a, double *b, int s)
{
  int i = (blockDim.x * blockIdx.x + threadIdx.x) * s;
  b[i] = a[i] + 1;
}



template <typename T>
void runTest(int deviceId)
{
  T *d_a;
  T *d_b;

  int N = 1024*256;

  // NB:  d_a(33*nMB) for stride case
  checkCuda( cudaMalloc(&d_a, N * 33 * sizeof(T)) );
  checkCuda( cudaMalloc(&d_b, N * 33 * sizeof(T)) );

  offset<<<1024, 256>>>(d_a, d_b, 0); // warm up
  cudaDeviceSynchronize();

  std::cout << "#Offset, Bandwidth (GB/s)" << std::endl;

  viennacl::tools::timer timer;
  for (int i = 0; i <= 32; i++) {
    timer.start();
    for (int n = 0; n < 10; ++n)
    {
      offset<<<1024, 256>>>(d_a, d_b, i);
    }
    cudaDeviceSynchronize();
    double bandwidth = 20 * 1024 * 256 * sizeof(double) / timer.get() / 1e9;
    std::cout << i << "    " << bandwidth << std::endl;
  }

  std::cout << "#Stride, Bandwidth (GB/s)" << std::endl;

  stride<<<1024, 256>>>(d_a, d_b, 0); // warm up
  cudaDeviceSynchronize();

  for (int i = 1; i <= 32; i++) {
    timer.start();
    for (int n = 0; n < 10; ++n)
    {
      stride<<<1024, 256>>>(d_a, d_b, i);
    }
    cudaDeviceSynchronize();
    double bandwidth = 20 * 1024 * 256 * sizeof(double) / timer.get() / 1e9;
    std::cout << i << "    " << bandwidth << std::endl;
  }

  cudaFree(d_a);
}

int main(int argc, char **argv)
{
  int deviceId = 0;
  cudaDeviceProp prop;

  checkCuda( cudaGetDeviceProperties(&prop, deviceId) );
  std::cout << "Device: " << prop.name << std::endl;

  runTest<double>(deviceId);

  return EXIT_SUCCESS;
}
