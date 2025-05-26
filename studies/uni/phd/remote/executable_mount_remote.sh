#!/bin/bash

# degfine base directories
base_dir="/home/diego/studies/uni/phd/remote"

SSHFS_CONFIG="$HOME/.ssh/config"
SSH_KEY="$HOME/.ssh/id_ed25519_tornado.pub"
COMMON_OPTS="-o IdentityFile=${SSH_KEY} \
             -o reconnect \
             -o ServerAliveInterval=15 \
             -o ServerAliveCountMax=3"

# Mount GPU build directory
sshfs -F "${SSHFS_CONFIG}" ${COMMON_OPTS} \
  tornado:/home/dbr25/gpu_build \
  ${base_dir}/gpu_build

# Mount MFEM directory
sshfs -F "${SSHFS_CONFIG}" ${COMMON_OPTS} \
  tornado:/home/dbr25/MFEM \
  {$base_dir}/MFEM
