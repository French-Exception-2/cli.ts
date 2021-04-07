#!/usr/bin/env bash

max_map_count=${max_map_count:=262144}
sudo sysctl -w vm.max_map_count=$max_map_count

