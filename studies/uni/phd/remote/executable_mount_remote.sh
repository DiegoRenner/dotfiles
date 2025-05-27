#!/bin/bash

# Define base directory
LOCAL_HOME="{$HOME}"
base_dir="/home/diego/studies/uni/phd/remote"

SSHFS_CONFIG="$HOME/.ssh/config"
SSH_KEY="$HOME/.ssh/id_ed25519_tornado.pub"
COMMON_OPTS="-o IdentityFile=${SSH_KEY} \
             -o reconnect \
             -o ServerAliveInterval=15 \
             -o ServerAliveCountMax=3"

# Define remote base directory
remote_base_dir="/home/dbr25"
# Define remote:local mount points
declare -A mounts=(
  [gpu_build]="${remote_base_dir}/gpu_build"
  [MFEM]="${remote_base_dir}/MFEM"
  [MFEM\-benchmark]="${remote_base_dir}/MFEM-benchmark"
  [nektar\-cu\-blas\-mika]="${remote_base_dir}/nektar-cu-blas-mika"
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
