log() {
  echo "$@" >&2
}

verboserun() {
  local cmd=$1
  log "running:"
  log "$cmd"
  $cmd
}

cleanuptrap() {
  local pid
  pid=`echo $!`
  log "trapping process ${pid}"
  cleanup() {
    local pid=$1
    log "terminating process ${pid}"
    kill "${pid}"
  }
  trap "cleanup $pid" EXIT
}
