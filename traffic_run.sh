#!/bin/bash

echo "This Script calls service operation in a continuous loop"
echo -n "Hit enter to start"
read
i=1
RES_FILES=callmix-results*.bin
\rm -f callmix-results*.bin
for XFACTOR in 10 20 30
do
RATE=$(( 1  * $XFACTOR ))
DURATION=2s
echo "starting traffic at rate :$RATE"
kubectl -n default exec http-client -- bash -c "/tmp/vegeta attack -duration=$DURATION  -rate=$RATE -targets=/tmp/targets.txt |tee /tmp/callmix-results-$i.bin |/tmp/vegeta report --every 100ms --type=hist[0ms,75ms,100ms,150ms,200ms] "
i=$((i+1))
done
kubectl -n default exec http-client -- bash -c "cd /tmp;tar -cvf reports.tar *.bin"; kubectl cp default/http-client:/tmp/reports.tar  /tmp/reports.tar
