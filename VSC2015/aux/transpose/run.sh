#!/bin/bash

g++ main.cpp nothing.cpp -I/export/development/ViennaCL/viennacl-dev/ -O3 -DNDEBUG -o transpose

echo "Size, STL->STL, STL->CSR, CSR->STL, CSR->Flat, CSR->CSR"

./transpose matrices/poisson2d_225.mtx
./transpose matrices/poisson2d_961.mtx
./transpose matrices/poisson2d_3969.mtx
./transpose matrices/poisson2d_16129.mtx
./transpose matrices/poisson2d_65025.mtx
./transpose matrices/poisson2d_261121.mtx
./transpose matrices/poisson2d_1046529.mtx



