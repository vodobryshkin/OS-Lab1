time ./out/graph_traverse 1 graph-rand.bin
time ./out/graph_traverse 1 graph-seq.bin

time ./out/graph_traverse --no-cache 1 graph-rand.bin
time ./out/graph_traverse --no-cache 1 graph-seq.bin

time ./out/graph_traverse --write 1 graph-rand.bin
time ./out/graph_traverse --write 1 graph-seq.bin

time ./out/graph_traverse --write --no-cache 1 graph-rand.bin
time ./out/graph_traverse --write --no-cache 1 graph-seq.bin