#!/usr/bin/gnuplot

set term postscript eps enhanced

set style data lines
set style line 1  linetype -1 linewidth 3 lc rgb "#005197"
set style line 2  linetype -1 linewidth 3 lc rgb "#000000"
set style line 3  linetype -1 linewidth 3 lc rgb "#00D317"
set style line 4  linetype -1 linewidth 3 lc rgb "#971c00"
set style line 5  linetype -1 linewidth 3 lc rgb "#000000"
set style increment user

set size 0.7, 0.7
set border linewidth 1.5
set format x "10^{%L}"

set yrange [0:150]
set key top left Left reverse
set grid lw 3
set ylabel "Bandwidth (GB/sec)"
set logscale x

set xlabel "Vector Size"
set output "vector-addition-bw.eps"

f(x) =        3 * 8 * x / 208e9
g(x) = 5e-6 + 3 * 8 * x / 208e9

set title "Memory Bandwidth for x = y + z in Double Precision"
plot 'result-k20m.txt' using 1:2 with linesp pt 9 ps 3.0 title "NVIDIA Tesla K20m"

set yrange [1e-6:1e-3]
set logscale y
set format y "10^{%L}"
set title "Execution Time for x = y + z in Double Precision"


set output "vector-addition-time-1.eps"
plot 'result-k20m.txt' using 1:($3/10) with linesp pt 9 ps 3.0 title "NVIDIA Tesla K20m"

set output "vector-addition-time-2.eps"
plot 'result-k20m.txt' using 1:($3/10) with linesp pt 9 ps 3.0 title "NVIDIA Tesla K20m", \
     f(x) title "Bandwidth Limit" with lines lt 1 lw 2 lc rgb "#000000"

set output "vector-addition-time-3.eps"
plot 'result-k20m.txt' using 1:($3/10) with linesp pt 9 ps 3.0 title "NVIDIA Tesla K20m", \
     f(x) title "Bandwidth Limit" with lines lt 1 lw 2 lc rgb "#000000", \
     g(x) title "Bandwidth + Latency Limit" with lines lt 1 lw 2 lc rgb "#FF0000"

set xrange [1e2:1e7]
set output "vector-addition-time-0.eps"
plot f(x) title "Bandwidth Limit" with lines lt 1 lw 2 lc rgb "#000000"

