#!/bin/bash
SESSION="tcpdump"
TARGET="./sbin/tcpdump -ner @@"
# Launch master fuzzer
echo "[+] Launching master..."
screen -dmS $SESSION"000" afl-fuzz -i seeds -o results -M $SESSION"000" -- $TARGET
echo "[+] Done. Waiting 5 seconds before launching slaves"
sleep 5
echo "[+] Launching slaves..."
# Launch slaves
for s in `seq 1 5`;
do
    SESSNAME=$SESSION$s
    screen -dmS $SESSNAME afl-fuzz -i seeds -o results -S $SESSNAME -- $TARGET
    sleep 1
done
echo "[+] Done. Now launching afl-whatsup"
screen -dmS "afl-whatsup" watch -n 10 afl-whatsup -s ./results
echo "[+] Done, now you can monitor all the fuzzers: screen -x afl-whatsup"