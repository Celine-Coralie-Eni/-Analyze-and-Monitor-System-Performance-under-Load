#!/bin/bash
cat << EOF > Dockerfile
FROM  ubuntu:latest

RUN apt update
RUN apt install  procps
RUN apt install stress

CMD [ "vmstat" ]
EOF

docker build -t monitor .

docker run -itd --rm --name monitor  monitor bash
. ./monitor2.sh &
docker exec monitor stress --cpu 1 --io 1 --vm 1 --vm-bytes 600M --timeout 10s --verbose
