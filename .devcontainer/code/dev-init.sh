#!/bin/bash
# Fix cache ownership on named volumes, and join the host device groups when
# this container was started with /dev/kvm, a render node, or the Docker socket.
set -euo pipefail

user=${BLACKBURN_DEV_USER:-vscode}
chown -R "$user:$user" "/go/pkg/mod" "/home/$user/.cache" "/home/$user/.pub-cache"

ensure_group() {
  local node=$1 fallback=$2 gid name
  [[ -e $node ]] || return 0
  gid=$(stat -c %g "$node")
  [[ $gid -eq 0 ]] && return 0
  name=$(awk -F: -v g="$gid" '$3==g {print $1; exit}' /etc/group)
  if [[ -z ${name:-} ]]; then
    name=$fallback
    if getent group "$name" >/dev/null; then
      name="${fallback}${gid}"
    fi
    groupadd -g "$gid" "$name"
  fi
  usermod -aG "$name" "$user"
}

ensure_group /dev/kvm kvmhost
ensure_group /dev/dri/renderD128 renderhost
ensure_group /var/run/docker.sock dockerhost
