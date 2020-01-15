log() {
  echo "$@" >&2
}

verboserun() {
  local cmd="$@"
  log "running:"
  eval "log $cmd"
  eval "${cmd}"
}

cleanuptrap() {
  local pid=$1
  log "trapping process ${pid}"
  cleanup() {
    local pid=$1
    log "terminating process ${pid}"
    kill "${pid}"
  }
  trap "cleanup $pid" EXIT
}

find_free_port() {
  echo $(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()');
}
