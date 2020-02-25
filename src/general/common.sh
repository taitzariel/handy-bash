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

wait_for_file_to_contain() {
  local search_pattern=$1
  local filename=$2
  until grep "${search_pattern}" ${filename} >/dev/null
  do
    sleep .5
  done
}

kill_and_wait() {
  local pid=$1
  log "killing process $pid"
  if kill $pid; then
    log "waiting for $pid to terminate"
    while ps -p $pid >/dev/null; do
      sleep .1
    done
  fi
}

wait_for_port_to_listen() {
  local port=$1
  log "waiting for port $port to be listened on"
  while netstat -lnt | awk '$4 ~ /:'$port'$/ {exit 1}'; do
    sleep .5
  done
}
