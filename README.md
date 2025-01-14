# -Analyze-and-Monitor-System-Performance-under-Load
## Simulating and analyzing system performance under heavy load
## Building a docker container simulating heavy cpu, memory and i/o usage
The following command appends the content of a Dockerfile and creates it for the building of the docker container
```sh
cat << EOF > Dockerfile
FROM  ubuntu:latest

RUN apt update
RUN apt install  procps
RUN apt install stress

CMD [ "vmstat" ]
EOF

docker build -t monitor .
```
The `docker build -t monitor .` builds a docker image from a Dockerfile in the current directory with the name `monitor`
## memners: celine,christian,cho ju-nine
### Running the the docker container
The following command runs the docker container from the `monitor` image we just created;
```sh
docker run -itd --rm --name monitor  monitor bash
```

The `. ./monitor2.sh &` command sources the monitor2.sh script but runs it in the background.

## Putting the container under stress condition
The following command runs heavy resource usage processes to stress the container 
```sh
docker exec monitor stress --cpu 1 --io 1 --vm 1 --vm-bytes 600M --timeout 10s --verbose
```
with;
- CPU Stress: The --cpu 1 option specifies that one  CPU core should be stressed.
- I/O Stress: The --io 1 option specifies that one I/O-bound process should be stressed.
- Virtual Memory Stress: The --vm 1 option specifies that one virtual memory allocator process should be stressed, with --vm-bytes 600M allocating 600 megabytes of virtual memory for the test.
- Timeout: The --timeout 10s option sets the test duration to 60 seconds.
- Verbose Output: The --verbose option enables detailed output during the test, providing more information about the stress test’s progress and results.
﻿
## Analyzing system resource consumption
The monitor2.sh script of that runs in the background records snapshots of system resource usage by the container which is under stress.

```sh
 docker stats --no-stream  | grep monitor -C 2| cat  >> logfile
```
The above command records a snapshot of the cpu and memory usage pipes the result to the grep command to grep `monitor` which is the name of the docker container we are currently working with and redirects the output to the `logfile` 

```sh
vmstat >> logfile
```
The vmstat command outputs memory usage of the docker container environment and the result is appended to the logfile for more analysis.
