set xrange [-0.5:9.5]
set term aqua title 'Gnuplot' font 'HiraMinPro-W3, 16' size 1280 960 enhanced
plot "37.dat" using 0:2:xtic(1) with boxes notitle
