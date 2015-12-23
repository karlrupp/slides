#!/usr/bin/gnuplot

set term postscript eps enhanced

set style data lines
set style line 1  linetype -1 linewidth 3 lc rgb "#005197"
set style line 2  linetype -1 linewidth 3 lc rgb "#000000"
set style line 3  linetype -1 linewidth 3 lc rgb "#00D317"
set style line 4  linetype -1 linewidth 3 lc rgb "#971c00"
set style line 5  linetype -1 linewidth 3 lc rgb "#000000"
set style increment user

set size 0.8, 0.8
set border linewidth 1.5

#set logscale y
#set format y "10^{%L}"
set yrange [0:150]
set key bottom left Left reverse
set grid lw 3
set ylabel "Bandwidth (GB/sec)"


set xrange [0:31]
set xlabel "Offset"
set output "offset.eps"

set title "Memory Bandwidth with Offsets - Double Precision"
plot 'offsets-gtx470.txt' using 1:2 with linesp pt 9 ps 3.0 title "NVIDIA GeForce GTX 470 (Fermi)", \
     'offsets-k20m.txt' using 1:2 with linesp pt 9 ps 3.0 title "NVIDIA Tesla K20m (Kepler)", \
     'offsets-gtx750ti.txt' using 1:2 with linesp pt 9 ps 3.0 title "NVIDIA GTX 750 Ti (Maxwell)"

set key top right Left reverse
set xrange [1:31]
set xlabel "Stride"
set output "stride.eps"

set title "Memory Bandwidth with Strides - Double Precision"
plot 'strides-gtx470.txt' using 1:2 with linesp pt 9 ps 3.0 title "NVIDIA GeForce GTX 470 (Fermi)", \
     'strides-k20m.txt' using 1:2 with linesp pt 9 ps 3.0 title "NVIDIA Tesla K20m (Kepler)", \
     'strides-gtx750ti.txt' using 1:2 with linesp pt 9 ps 3.0 title "NVIDIA GTX 750 Ti (Maxwell)"

