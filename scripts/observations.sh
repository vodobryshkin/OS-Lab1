set -euo pipefail

N="${1:-20}"
ITERATIONS="${2:-1}"
CPU="${3:-0}"
GRAPH="${4:-graph-seq.bin}"
OUTPUT="${5:-observations_$(date +%Y%m%d_%H%M%S).tsv}"

export LC_ALL=C

if [[ ! "$N" =~ ^[1-9][0-9]*$ ]] || [[ ! "$ITERATIONS" =~ ^[1-9][0-9]*$ ]]; then
    echo "N and ITERATIONS must be positive integers" >&2
    exit 1
fi

if [[ ! -f "$GRAPH" ]]; then
    echo "Graph file not found: $GRAPH" >&2
    exit 1
fi

if [[ ! -x ./out/graph_traverse ]] || [[ ! -x ./out/graph_traverse_mmap ]]; then
    echo "Build graph_traverse and graph_traverse_mmap first" >&2
    exit 1
fi

if [[ -e "$OUTPUT" ]]; then
    echo "Output file already exists: $OUTPUT" >&2
    exit 1
fi

TEMP_FILE="$(mktemp)"
trap 'rm -f "$TEMP_FILE"' EXIT

printf 'round\tposition\tprogram\tmode\tgraph\titerations\tcpu\twall_s\tuser_s\tsys_s\tinvoluntary_context_switches\tvoluntary_context_switches\tminor_page_faults\tmajor_page_faults\n' > "$OUTPUT"

taskset -c "$CPU" ./out/graph_traverse "$ITERATIONS" "$GRAPH" >/dev/null
taskset -c "$CPU" ./out/graph_traverse --write "$ITERATIONS" "$GRAPH" >/dev/null
taskset -c "$CPU" ./out/graph_traverse_mmap "$ITERATIONS" "$GRAPH" >/dev/null
taskset -c "$CPU" ./out/graph_traverse_mmap --write "$ITERATIONS" "$GRAPH" >/dev/null
sync

measure() {
    local round="$1"
    local position="$2"
    local program="$3"
    local mode="$4"
    local binary="$5"
    local args=()

    if [[ "$mode" == "write" ]]; then
        args+=(--write)
    fi

    sync
    /usr/bin/time -f '%e\t%U\t%S\t%c\t%w\t%R\t%F' -o "$TEMP_FILE" \
        taskset -c "$CPU" "$binary" "${args[@]}" "$ITERATIONS" "$GRAPH" >/dev/null

    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t' \
        "$round" "$position" "$program" "$mode" "$GRAPH" "$ITERATIONS" "$CPU" >> "$OUTPUT"
    cat "$TEMP_FILE" >> "$OUTPUT"

    printf '%d/%d  %s  %s\n' "$round" "$N" "$program" "$mode"
}

programs=(graph_traverse graph_traverse graph_traverse_mmap graph_traverse_mmap)
modes=(read write read write)
binaries=(./out/graph_traverse ./out/graph_traverse ./out/graph_traverse_mmap ./out/graph_traverse_mmap)

for ((round = 1; round <= N; round++)); do
    start=$(((round - 1) % 4))

    for ((position = 1; position <= 4; position++)); do
        index=$(((start + position - 1) % 4))
        measure "$round" "$position" "${programs[$index]}" "${modes[$index]}" "${binaries[$index]}"
    done
done

echo "$OUTPUT"
