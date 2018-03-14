set xrange [-0.5:258.5]
set term aqua title 'Gnuplot' font 'HiraMinPro-W3, 16' size 1280 960 enhanced
plot "38.dat" using 1:2 with boxes notitle
