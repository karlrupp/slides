

set terminal postscript eps color enhanced #font 'CourierBold,14'



set style line 1 lt 1 lw 3 ps 2 pt 13 lc rgb "#000000"
set style line 2 lt 1 lw 3 ps 2 pt 5  lc rgb "#008800"
set style line 3 lt 1 lw 3 ps 2 pt 7  lc rgb "#0000BB"
set style line 4 lt 1 lw 3 ps 2 pt 9  lc rgb "#EE7700"
set style line 5 lt 1 lw 3 ps 2 pt 11 lc rgb "#AA0000"


set size 0.8
set size ratio 0.6

set xlabel "Matrix Size"
set ylabel "Execution Time"

set grid
set key bottom right Left reverse
set logscale y
set format y "10^{%T}"
set logscale x
set format x "10^{%T}"
set yrange [1e-6:10]

# 5 nnz/row, sizeof(double), read + write, divide by 10 GB/sec memory bandwidth
f(x) = 5 * (8 + 4) * x * 2 / 10e9

set title "Sparse Matrix Transposition"

set output "transpose-1.eps"
plot \
 "results.txt" using 1:2 title "STL->STL"  ls 1 lw 3 with linespoints

set output "transpose-2.eps"
plot \
 "results.txt" using 1:2 title "STL->STL"  ls 1 lw 3 with linespoints, \
 "results.txt" using 1:3 title "STL->CSR"  ls 2 lw 3 with linespoints

set output "transpose-3.eps"
plot \
 "results.txt" using 1:2 title "STL->STL"  ls 1 lw 3 with linespoints, \
 "results.txt" using 1:3 title "STL->CSR"  ls 2 lw 3 with linespoints, \
 "results.txt" using 1:4 title "CSR->STL"  ls 3 lw 3 with linespoints

set output "transpose-4.eps"
plot \
 "results.txt" using 1:2 title "STL->STL"  ls 1 lw 3 with linespoints, \
 "results.txt" using 1:3 title "STL->CSR"  ls 2 lw 3 with linespoints, \
 "results.txt" using 1:4 title "CSR->STL"  ls 3 lw 3 with linespoints, \
 "results.txt" using 1:5 title "CSR->Flat" ls 4 lw 3 with linespoints

set output "transpose-5.eps"
plot \
 "results.txt" using 1:2 title "STL->STL"  ls 1 lw 3 with linespoints, \
 "results.txt" using 1:3 title "STL->CSR"  ls 2 lw 3 with linespoints, \
 "results.txt" using 1:4 title "CSR->STL"  ls 3 lw 3 with linespoints, \
 "results.txt" using 1:5 title "CSR->Flat" ls 4 lw 3 with linespoints, \
 "results.txt" using 1:6 title "CSR->CSR"  ls 5 lw 3 with linespoints

set output "transpose-6.eps"
plot \
 "results.txt" using 1:2 title "STL->STL"  ls 1 lw 3 with linespoints, \
 "results.txt" using 1:3 title "STL->CSR"  ls 2 lw 3 with linespoints, \
 "results.txt" using 1:4 title "CSR->STL"  ls 3 lw 3 with linespoints, \
 "results.txt" using 1:5 title "CSR->Flat" ls 4 lw 3 with linespoints, \
 "results.txt" using 1:6 title "CSR->CSR"  ls 5 lw 3 with linespoints, \
 f(x) title "Bandwidth Limit" with lines lt 1 lw 2 lc rgb "#000000"


