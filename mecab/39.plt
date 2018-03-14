set term aqua title 'Gnuplot' font 'HiraMinPro-W3, 16' size 1280 960 enhanced
set logscale x
set logscale y
plot "39.dat" using 1:2 with boxes notitle
