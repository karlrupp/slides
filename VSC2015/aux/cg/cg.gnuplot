#!/usr/bin/gnuplot

set term postscript eps enhanced

set size ratio 0.7 0.65,0.65
set border linewidth 1.5

set logscale x
set logscale y
set yrange [1e-5:1e-2]
set format x "10^{%L}"
set format y "10^{%L}"
set key samplen 6 spacing 2.0
set key top left Left reverse
set grid lw 3
set ylabel "Execution Time (sec)"

f(x) = 8 * 10e-6 + 2 * 20e-6 + (7+2+3+3+2+3) * 8 * x / 208e9

set title "Time per CG Iteration - NVIDIA K20m"

set output "cg-k20m-0.eps"
plot 'k20m.txt' using 1:2 with linesp lc rgb "#000000" lt 1 lw 3 pt 9 ps 2.0 title "BLAS-based, CSR"

set output "cg-k20m-1.eps"
plot 'k20m.txt' using 1:2 with linesp lc rgb "#000000" lt 1 lw 3 pt 9 ps 2.0 title "BLAS-based, CSR", \
     f(x) title "Bandwidth + Latency Limit" with lines lt 1 lw 2 lc rgb "#000000"


set output "cg-k20m-3.eps"
plot 'k20m.txt' using 1:2 with linesp lc rgb "#000000" lt 1 lw 3 pt 9 ps 2.0 title "BLAS-based", \
     f(x) title "Bandwidth + Latency Limit" with lines lt 1 lw 2 lc rgb "#000000", \
     'k20m.txt' using 1:7 with linesp lc rgb "#0000AA" lt 5 lw 3 pt 7 ps 2.0 title "Pipelined"


