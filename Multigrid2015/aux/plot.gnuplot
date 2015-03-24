set terminal postscript enhanced color eps
#unset logscale y

set style data lines
set style line 1  linetype -1 linewidth 3 lc rgb "#000000"
set style line 2  linetype  2 linewidth 3 lc rgb "#000000"
set style line 3  linetype -1 linewidth 3 lc rgb "#0000AA"
set style line 4  linetype  2 linewidth 3 lc rgb "#0000AA"
set style line 5  linetype -1 linewidth 3 lc rgb "#00AA00"
set style line 6  linetype  2 linewidth 3 lc rgb "#00AA00"
set style line 7  linetype -1 linewidth 3 lc rgb "#AA0000"
set style line 8  linetype  2 linewidth 3 lc rgb "#AA0000"
set style line 9  linetype -1 linewidth 3 lc rgb "#970093"
set style line 10 linetype -1 linewidth 3 lc rgb "#970600"
set style line 11 linetype -1 linewidth 3 lc rgb "#976d00"
set style line 12 linetype -1 linewidth 3 lc rgb "#002697"
set style line 13 linetype -1 linewidth 3 lc rgb "#008f97"
#set style line 14 linetype -1 linewidth 3 lc rgb "#000597"
#set style line 15 linetype -1 linewidth 3 lc rgb "#000597"
set style increment user

set logscale x
set logscale y

set size 0.7,0.7
set border lw 2

set key top left
set grid
#set xrange[3000:300000]
set yrange[0.001:100]
set xlabel "Unknowns"
set ylabel "Time (sec)"
set pointsize 1.5
set title "Total Solver Execution Times"

set format x "10^%L"

set output "amg-vs-pure-full-1.eps"
plot 'cpu.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, CPU", \
     'cpu.txt'   using 1:($11)   with linesp pt 2 title "CG, CPU"
set output "amg-vs-pure-full-2.eps"
plot 'cpu.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, CPU", \
     'cpu.txt'   using 1:($11)   with linesp pt 2 title "CG, CPU", \
     'phi.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, MIC", \
     'phi.txt'   using 1:($11)   with linesp pt 2 title "CG, MIC"

set output "amg-vs-pure-full-3.eps"
plot 'cpu.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, CPU", \
     'cpu.txt'   using 1:($11)   with linesp pt 2 title "CG, CPU", \
     'phi.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, MIC", \
     'phi.txt'   using 1:($11)   with linesp pt 2 title "CG, MIC", \
     'k20.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, K20", \
     'k20.txt'   using 1:($11)   with linesp pt 2 title "CG, K20"

set output "amg-vs-pure-full-4.eps"
plot 'cpu.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, CPU", \
     'cpu.txt'   using 1:($11)   with linesp pt 2 title "CG, CPU", \
     'phi.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, MIC", \
     'phi.txt'   using 1:($11)   with linesp pt 2 title "CG, MIC", \
     'k20.txt'   using 1:($2+$4) with linesp pt 2 title "CG+OP, K20", \
     'k20.txt'   using 1:($11)   with linesp pt 2 title "CG, K20", \
     'w9100.txt' using 1:($2+$4) with linesp pt 2 title "CG+OP, W9100", \
     'w9100.txt' using 1:($11)   with linesp pt 2 title "CG, W9100"

#######

set output "cpu-setup.eps"
set title "Solver Setup Time 2x INTEL Xeon E5-2620 v2"
plot 'cpu.txt'   using 1:($2) with linesp ls 7 pt 2 title "CG+OP", \
     'cpu.txt'   using 1:($6) with linesp ls 8 pt 2 title "CG+AGG"

set output "cpu-cycle.eps"
set title "Solver Cycle Time 2x INTEL Xeon E5-2620 v2"
plot 'cpu.txt'   using 1:($4) with linesp ls 7 pt 2 title "CG+OP", \
     'cpu.txt'   using 1:($8) with linesp ls 8 pt 2 title "CG+AGG"


set output "cpu-full.eps"
set title "Total Solver Time 2x INTEL Xeon E5-2620 v2"
plot 'cpu.txt'   using 1:($2+$4) with linesp ls 7 pt 2 title "CG+OP", \
     'cpu.txt'   using 1:($6+$8) with linesp ls 8 pt 2 title "CG+AGG", \
     'cpu.txt'   using 1:($11)   with linesp pt 2 title "CG"


#######

set output "mic-setup.eps"
set title "Solver Setup Time INTEL Xeon Phi"
plot 'phi.txt'   using 1:($2) with linesp ls 7 pt 2 title "CG+OP", \
     'phi.txt'   using 1:($6) with linesp ls 8 pt 2 title "CG+AGG"

set output "mic-cycle.eps"
set title "Solver Cycle Time INTEL Xeon Phi"
plot 'phi.txt'   using 1:($4) with linesp ls 7 pt 2 title "CG+OP", \
     'phi.txt'   using 1:($8) with linesp ls 8 pt 2 title "CG+AGG"


set output "mic-full.eps"
set title "Total Solver Time INTEL Xeon Phi"
plot 'phi.txt'   using 1:($2+$4) with linesp ls 7 pt 2 title "CG+OP", \
     'phi.txt'   using 1:($6+$8) with linesp ls 8 pt 2 title "CG+AGG", \
     'phi.txt'   using 1:($11)   with linesp pt 2 title "CG"

######

set output "k20-setup.eps"
set title "Solver Setup Time NVIDIA Tesla K20"
plot 'k20.txt'   using 1:($2) with linesp ls 7 pt 2 title "CG+OP", \
     'k20.txt'   using 1:($6) with linesp ls 8 pt 2 title "CG+AGG"

set output "k20-cycle.eps"
set title "Solver Cycle Time NVIDIA Tesla K20"
plot 'k20.txt'   using 1:($4) with linesp ls 7 pt 2 title "CG+OP", \
     'k20.txt'   using 1:($8) with linesp ls 8 pt 2 title "CG+AGG"

set output "k20-full.eps"
set title "Total Solver Time NVIDIA Tesla K20"
plot 'k20.txt'   using 1:($2+$4) with linesp ls 7 pt 2 title "CG+OP", \
     'k20.txt'   using 1:($6+$8) with linesp ls 8 pt 2 title "CG+AGG", \
     'k20.txt'   using 1:($11)   with linesp pt 2 title "CG"


######
     
set output "w9100-setup.eps"
set title "Solver Setup Time AMD FirePro W9100"
plot 'w9100.txt'   using 1:($2) with linesp ls 7 pt 2 title "CG+OP", \
     'w9100.txt'   using 1:($6) with linesp ls 8 pt 2 title "CG+AGG"

set output "w9100-cycle.eps"
set title "Solver Cycle Time AMD FirePro W9100"
plot 'w9100.txt'   using 1:($4) with linesp ls 7 pt 2 title "CG+OP", \
     'w9100.txt'   using 1:($8) with linesp ls 8 pt 2 title "CG+AGG"

set output "w9100-full.eps"
set title "Total Solver Time AMD FirePro W9100"
plot 'w9100.txt'   using 1:($2+$4) with linesp ls 7 pt 2 title "CG+OP", \
     'w9100.txt'   using 1:($6+$8) with linesp ls 8 pt 2 title "CG+AGG", \
     'w9100.txt'   using 1:($11)   with linesp pt 2 title "CG"


#######

set yrange [1:10000]

set output "iters.eps"
set title "Solver Iterations"
set ylabel "Iterations"
plot 'w9100.txt'   using 1:($3) with linesp ls 1 pt 2 title "CG+OP", \
     'w9100.txt'   using 1:($7) with linesp ls 2 pt 2 title "CG+AGG", \
     'w9100.txt'   using 1:($10) with linesp ls 3 pt 2 title "CG"

######

set yrange [1:10]

unset logscale y
set output "levels.eps"
set title "Multigrid Levels"
set ylabel "Levels"
plot 'w9100.txt'   using 1:($5) with linesp ls 1 pt 2 title "CG+OP", \
     'w9100.txt'   using 1:($9) with linesp ls 2 pt 2 title "CG+AGG"


