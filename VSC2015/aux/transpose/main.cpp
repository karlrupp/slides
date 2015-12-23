

#include <map>
#include <vector>
#include <iostream>
#include <algorithm>

#include "viennacl/compressed_matrix.hpp"
#include "viennacl/vector.hpp"
#include "viennacl/io/matrix_market.hpp"
#include "viennacl/tools/timer.hpp"

#include <boost/interprocess/containers/flat_map.hpp>

void do_nothing(viennacl::compressed_matrix<double> & B);
void do_nothing(std::vector<std::map<unsigned int, double> > & B);
void do_nothing(std::vector<boost::container::flat_map<unsigned int, double> > & B);

void print_median(std::vector<double> & exec_times)
{
  std::sort(exec_times.begin(), exec_times.end());
  std::cout << exec_times[exec_times.size()/2] << "   ";
}

template<typename NumericT>
void run_map_map(std::vector<std::map<unsigned int, NumericT> > const & A)
{
  std::vector<std::map<unsigned int, NumericT> > B(A.size());

  //viennacl::tools::timer timer;
  //timer.start();
  for (std::size_t i=0; i<A.size(); ++i)
    for (typename std::map<unsigned int, NumericT>::const_iterator it = A[i].begin(); it != A[i].end(); ++it)
      B[it->first][i] = it->second;

  do_nothing(B);

  //std::cout << "Time for STL->STL: " << timer.get() << std::endl;
}

template<typename NumericT>
void run_map_csr(std::vector<std::map<unsigned int, NumericT> > const & A)
{
  std::size_t B_nnz = 0;

  for (std::size_t i = 0; i < A.size(); ++i)
    B_nnz += A[i].size();

  // initialize datastructures for B:
  viennacl::compressed_matrix<NumericT> B(A.size(), A.size(), B_nnz);

  NumericT     * B_elements   = viennacl::linalg::host_based::detail::extract_raw_pointer<NumericT>(B.handle());
  unsigned int * B_row_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(B.handle1());
  unsigned int * B_col_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(B.handle2());

  // prepare uninitialized B_row_buffer:
  for (std::size_t i = 0; i < B.size1(); ++i)
    B_row_buffer[i] = 0;

  //
  // Stage 1: Compute pattern for B
  //
  for (std::size_t row = 0; row < A.size(); ++row)
  {
    for (typename std::map<unsigned int, NumericT>::const_iterator it = A[row].begin(); it != A[row].end(); ++it)
      B_row_buffer[it->first] += 1;
  }

  // Bring row-start array in place using inclusive-scan:
  unsigned int offset = B_row_buffer[0];
  B_row_buffer[0] = 0;
  for (std::size_t row = 1; row < B.size1(); ++row)
  {
    unsigned int tmp = B_row_buffer[row];
    B_row_buffer[row] = offset;
    offset += tmp;
  }
  B_row_buffer[B.size1()] = offset;

  //
  // Stage 2: Fill with data
  //

  std::vector<unsigned int> B_row_offsets(B.size1()); //number of elements already written per row

  for (std::size_t row = 0; row < A.size(); ++row)
  {
    for (typename std::map<unsigned int, NumericT>::const_iterator it = A[row].begin(); it != A[row].end(); ++it)
    {
      unsigned int col_in_A = it->first;
      unsigned int B_nnz_index = B_row_buffer[col_in_A] + B_row_offsets[col_in_A];
      B_col_buffer[B_nnz_index] = row;
      B_elements[B_nnz_index] = it->second;
      ++B_row_offsets[col_in_A];
    }
  }

  do_nothing(B);
}

template<typename NumericT>
void run_csr_map(viennacl::compressed_matrix<NumericT> const & A)
{
  NumericT     const * A_elements   = viennacl::linalg::host_based::detail::extract_raw_pointer<NumericT>(A.handle());
  unsigned int const * A_row_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(A.handle1());
  unsigned int const * A_col_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(A.handle2());

  // initialize datastructures for B:
  std::vector<std::map<unsigned int, NumericT> > B(A.size2());

  for (std::size_t row = 0; row < A.size1(); ++row)
  {
    //std::cout << "Row " << row << ": ";
    unsigned int row_start = A_row_buffer[row];
    unsigned int row_stop  = A_row_buffer[row+1];

    for (unsigned int nnz_index = row_start; nnz_index < row_stop; ++nnz_index)
      B[A_col_buffer[nnz_index]][row] = A_elements[nnz_index];
  }

  do_nothing(B);
}

template<typename NumericT>
void run_csr_flat(viennacl::compressed_matrix<NumericT> const & A)
{
  NumericT     const * A_elements   = viennacl::linalg::host_based::detail::extract_raw_pointer<NumericT>(A.handle());
  unsigned int const * A_row_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(A.handle1());
  unsigned int const * A_col_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(A.handle2());

  // initialize datastructures for B:
  std::vector<boost::container::flat_map<unsigned int, NumericT> > B(A.size2());

  for (std::size_t row = 0; row < A.size1(); ++row)
  {
    //std::cout << "Row " << row << ": ";
    unsigned int row_start = A_row_buffer[row];
    unsigned int row_stop  = A_row_buffer[row+1];

    B[row].reserve(8);
    for (unsigned int nnz_index = row_start; nnz_index < row_stop; ++nnz_index)
      B[A_col_buffer[nnz_index]][row] = A_elements[nnz_index];
  }

  do_nothing(B);
}

template<typename NumericT>
void run_csr_csr(viennacl::compressed_matrix<NumericT> const & A)
{
  NumericT     const * A_elements   = viennacl::linalg::host_based::detail::extract_raw_pointer<NumericT>(A.handle());
  unsigned int const * A_row_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(A.handle1());
  unsigned int const * A_col_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(A.handle2());

  // initialize datastructures for B:
  viennacl::compressed_matrix<NumericT> B(A.size2(), A.size1(), A.nnz(), viennacl::traits::context(A));

  NumericT     * B_elements   = viennacl::linalg::host_based::detail::extract_raw_pointer<NumericT>(B.handle());
  unsigned int * B_row_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(B.handle1());
  unsigned int * B_col_buffer = viennacl::linalg::host_based::detail::extract_raw_pointer<unsigned int>(B.handle2());

  // prepare uninitialized B_row_buffer:
  for (std::size_t i = 0; i < B.size1(); ++i)
    B_row_buffer[i] = 0;

  //
  // Stage 1: Compute pattern for B
  //
  for (std::size_t row = 0; row < A.size1(); ++row)
  {
    unsigned int row_start = A_row_buffer[row];
    unsigned int row_stop  = A_row_buffer[row+1];

    for (unsigned int nnz_index = row_start; nnz_index < row_stop; ++nnz_index)
      B_row_buffer[A_col_buffer[nnz_index]] += 1;
  }

  // Bring row-start array in place using inclusive-scan:
  unsigned int offset = B_row_buffer[0];
  B_row_buffer[0] = 0;
  for (std::size_t row = 1; row < B.size1(); ++row)
  {
    unsigned int tmp = B_row_buffer[row];
    B_row_buffer[row] = offset;
    offset += tmp;
  }
  B_row_buffer[B.size1()] = offset;

  //
  // Stage 2: Fill with data
  //

  std::vector<unsigned int> B_row_offsets(B.size1()); //number of elements already written per row

  for (std::size_t row = 0; row < A.size1(); ++row)
  {
    //std::cout << "Row " << row << ": ";
    unsigned int row_start = A_row_buffer[row];
    unsigned int row_stop  = A_row_buffer[row+1];

    for (unsigned int nnz_index = row_start; nnz_index < row_stop; ++nnz_index)
    {
      unsigned int col_in_A = A_col_buffer[nnz_index];
      unsigned int B_nnz_index = B_row_buffer[col_in_A] + B_row_offsets[col_in_A];
      B_col_buffer[B_nnz_index] = row;
      B_elements[B_nnz_index] = A_elements[nnz_index];
      ++B_row_offsets[col_in_A];
      //B_temp.at(A_col_buffer[nnz_index])[row] = A_elements[nnz_index];
    }
  }

  do_nothing(B);
}

int main(int argc, char **argv)
{
  if (argc < 2)
  {
    std::cout << "Missing argument: Matrix filename" << std::endl;
    return EXIT_FAILURE;
  }

  std::size_t runs = 10;
  std::vector<double> exec_times(runs);

  //std::cout << "Reading matrix..." << std::endl;
  std::vector< std::map<unsigned int, double> > read_in_matrix;
  if (!viennacl::io::read_matrix_market_file(read_in_matrix, argv[1]))
  {
    std::cout << "Error reading Matrix file" << std::endl;
    return EXIT_FAILURE;
  }

  viennacl::compressed_matrix<double> vcl_A;
  viennacl::copy(read_in_matrix, vcl_A);

  viennacl::tools::timer timer;

  //std::cout << "Size, STL->STL, STL->CSR, CSR->STL, CSR->CSR" << std::endl;
  std::cout << read_in_matrix.size() << " ";

  // Benchmark 1: STL to STL
  for (std::size_t i=0; i<runs; ++i)
  { 
    timer.start();
    run_map_map(read_in_matrix);
    exec_times[i] = timer.get();
  }
  print_median(exec_times);  


  // Benchmark 2: STL to CSR
  for (std::size_t i=0; i<runs; ++i)
  { 
    timer.start();
    run_map_csr(read_in_matrix);
    exec_times[i] = timer.get();
  }
  print_median(exec_times);  


  // Benchmark 3: CSR to STL
  for (std::size_t i=0; i<runs; ++i)
  { 
    timer.start();
    run_csr_map(vcl_A);
    exec_times[i] = timer.get();
  }
  print_median(exec_times);  

  // Benchmark 4: CSR to STL
  for (std::size_t i=0; i<runs; ++i)
  { 
    timer.start();
    run_csr_flat(vcl_A);
    exec_times[i] = timer.get();
  }
  print_median(exec_times);  

  // Benchmark 5: CSR to CSR
  for (std::size_t i=0; i<runs; ++i)
  { 
    timer.start();
    run_csr_csr(vcl_A);
    exec_times[i] = timer.get();
  }
  print_median(exec_times);

  std::cout << std::endl;

  return EXIT_SUCCESS;
}
