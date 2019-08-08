# Notes

## Compiling tcpdump

```shell
export CC=/usr/local/bin/afl-clang-fast
export CXX=/usr/local/bin/afl-clang-fast++
cd ./libpcap
./configure --prefix=$(pwd)/..
make
make install
cd ../tcpdump
make distclean
./configure --prefix=$(pwd)/..
make
make install
```

## Making initial corpus

Gather a bunch of pcaps in `seeds` folder.
```shell
find ./tcpdump/tests -type f -iname "*.pcap" | xargs cp -t ./seeds
sync
```

Then use the afl-cmin tool to minimize the corpus but still cover the same code paths:
```shell
afl-cmin -i seeds -o corpus.cmin -- ./sbin/tcpdump -ner @@
```

When it's done, use the afl-tmin tool on each file in the corpus.cmin:
```shell
screen -S tmin                # Depending on the size and number of files, it might take a while
cd corpus.cmin
for i in *; do afl-tmin -i $i -o ../corpus.cmin.tmin/$i -- ../sbin/tcpdump -ner @@; done
```

## Launching AFL

```shell
sudo -s
echo core >/proc/sys/kernel/core_pattern
cd /sys/devices/system/cpu
echo performance | tee cpu*/cpufreq/scaling_governor
exit
./launcher.sh
```

## Monitoring the instances

```shell
screen -x afl-whatsup
Every 10.0s: afl-whatsup -s ./results                   Sun Feb 19 10:23:04 2017

status check tool for afl-fuzz by <lcamtuf@google.com>

Summary stats
=============

       Fuzzers alive : 6
      Total run time : 0 days, 0 hours
         Total execs : 0 million
    Cumulative speed : 3232 execs/sec
       Pending paths : 2549 faves, 5890 total
  Pending per fuzzer : 424 faves, 981 total (on average)
       Crashes found : 0 locally unique
```

## TShark

### Compile tshark with afl-clang-fast

```shell
cd wireshark
git checkout -b tshark_fuzzing master       # fix the version you're fuzzing
export CC=/usr/local/bin/afl-clang-fast
export CXX=/usr/local/bin/afl-clang-fast++
./autogen.sh
./configure --enable-wireshark=no --with-qt=no --with-gtk=no --enable-static=yes --with-libpcap=../libpcap
make
```