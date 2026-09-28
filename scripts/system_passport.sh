echo "= Паспорт системы"

echo "== Ядро, архитектура"
echo "\`\`\`text"
uname -a
echo "\`\`\`"

echo "== Модель CPU, число ядер/потоков, частоты, флаги (avx, sse и т.д.)"
echo "\`\`\`text"
lscpu
echo "\`\`\`"

echo "== Топология: logical CPU ↔ physical core ↔ socket"
echo "\`\`\`text"
lscpu -e
echo "\`\`\`"

echo "== Размеры кэшей L1/L2/L3"
echo "\`\`\`text"
cat /proc/cpuinfo | grep -i cache
echo "\`\`\`"

echo "== Объём RAM, использование, размер page cache/buffers"
echo "\`\`\`text"
free -h
echo "\`\`\`"

echo "== Модель диска/памяти, тип шины"
echo "\`\`\`text"
sudo lshw -class disk -class memory -short
echo "\`\`\`"

echo "== Тип накопителя (SSD/HDD/NVMe), состояние"
echo "\`\`\`text"
sudo smartctl -a /dev/nvme0n1
echo "\`\`\`"

echo "== 0 = не вращающийся (SSD/NVMe), 1 = HDD"
echo "\`\`\`text"
cat /sys/block/nvme0n1/queue/rotational
echo "\`\`\`"

echo "== Число доступных логических CPU"
echo "\`\`\`text"
nproc
echo "\`\`\`"
