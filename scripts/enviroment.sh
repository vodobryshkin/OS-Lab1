uptime
top -bn1 | head -20
mpstat -P ALL 1 3

./out/graph_traverse 1 graph-seq.bin >/dev/null
./out/graph_traverse_mmap 1 graph-seq.bin >/dev/null