time ./out/graph_traverse 1 graph-rand.bin
time ./out/graph_traverse 1 graph-seq.bin

time ./out/graph_traverse --no-cache 1 graph-rand.bin
time ./out/graph_traverse --no-cache 1 graph-seq.bin

time ./out/graph_traverse --write 1 graph-rand.bin
time ./out/graph_traverse --write 1 graph-seq.bin

time ./out/graph_traverse --write --no-cache 1 graph-rand.bin
time ./out/graph_traverse --write --no-cache 1 graph-seq.bin

strace -c -S calls ./out/graph_traverse 1 graph-seq.bin
strace -c -S calls ./out/graph_traverse --write 1 graph-seq.bin

/usr/bin/time -v ./out/graph_traverse 1 graph-seq.bin
/usr/bin/time -v ./out/graph_traverse --write 1 graph-seq.bin

perf stat -e context-switches,cpu-migrations,page-faults,cache-references,cache-misses \
    ./out/graph_traverse 1 graph-seq.bin

perf stat -e context-switches,cpu-migrations,page-faults,cache-references,cache-misses \
    ./out/graph_traverse --write 1 graph-seq.bin

stress-ng --cpu 4 --timeout 60s &
STRESS_PID=$!
sleep 1
/usr/bin/time -v ./out/graph_traverse 1 graph-seq.bin
kill "$STRESS_PID" 2>/dev/null
wait "$STRESS_PID" 2>/dev/null