#!/bin/bash

LOCAL_HOME="/home/diego"
BASE_DIR="${LOCAL_HOME}/studies/uni/phd/remote"

# List of directories to unmount
mounts=(
  "gpu_build"
  "MFEM"
  "MFEM-benchmark"
)

for name in "${mounts[@]}"; do
  local_path="${BASE_DIR}/${name}"

  if mountpoint -q "$local_path"; then
    echo "Unmounting $local_path"
    fusermount -u "$local_path"
  else
    echo "$local_path is not mounted"
  fi
done
