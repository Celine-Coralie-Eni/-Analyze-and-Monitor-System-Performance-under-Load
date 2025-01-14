#!/bin/bash

        docker stats --no-stream  | grep monitor -C 2| cat  >> logfile
 vmstat >> logfile

