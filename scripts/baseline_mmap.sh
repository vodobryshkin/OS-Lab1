time ./out/graph_traverse_mmap 1 graph-rand.bin
time ./out/graph_traverse_mmap 1 graph-seq.bin

time ./out/graph_traverse_mmap --no-cache 1 graph-rand.bin
time ./out/graph_traverse_mmap --no-cache 1 graph-seq.bin

time ./out/graph_traverse_mmap --write 1 graph-rand.bin
time ./out/graph_traverse_mmap --write 1 graph-seq.bin

time ./out/graph_traverse_mmap --write --no-cache 1 graph-rand.bin
time ./out/graph_traverse_mmap --write --no-cache 1 graph-seq.bin