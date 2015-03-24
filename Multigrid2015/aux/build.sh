#!/bin/bash

gnuplot plot.gnuplot
for f in `ls *.eps`; do epstopdf $f; done
for f in `ls *.pdf`; do mv $f ../figures/; done
rm *.eps

