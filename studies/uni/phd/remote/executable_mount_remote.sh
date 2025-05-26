#!/bin/bash

# Define base directory
base_dir="/home/diego/studies/uni/phd/remote"

SSHFS_CONFIG="$HOME/.ssh/config"
SSH_KEY="$HOME/.ssh/id_ed25519_tornado.pub"
COMMON_OPTS="-o IdentityFile=${SSH_KEY} \
             -o reconnect \
             -o ServerAliveInterval=15 \
             -o ServerAliveCountMax=3"

# Define remote:local mount points
declare -A mounts=(
  [gpu_build]="/home/dbr25/gpu_build"
  [MFEM]="/home/dbr25/MFEM"
  [MFEM\-benchmark]="/home/dbr25/MFEM-benchmark"
)

for name in "${!mounts[@]}"; do
  remote_path="${mounts[$name]}"
  local_path="${base_dir}/${name}"

  # Check and create local mount point if needed
  if [ ! -d "$local_path" ]; then
    echo "Creating local directory: $local_path"
    mkdir -p "$local_path"
  fi

  echo "Mounting ${remote_path} to ${local_path}"
  sshfs -F "${SSHFS_CONFIG}" ${COMMON_OPTS} \
    tornado:"${remote_path}" \
    "${local_path}"
done
