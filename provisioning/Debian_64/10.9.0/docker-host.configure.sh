#!/usr/bin/env pwsh

vm_max_map_count=${vm_max_map_count:=262144}
sudo sysctl -w vm.max_map_count=$vm_max_map_count
