rootdir=`dirname "$(readlink -f "$0")"`
. ${rootdir}/../general/common.sh

portforward() {
  local ssh_connect_cmd=$1
  local local_port=$2
  local forward_host=$3
  local forward_port=$4
  local local_connect_cmd="${@:5}"

  local logfile=~/tmp/ssh.log

  log "port forwarding localhost:$local_port to ${forward_host}:${forward_port}"
  local connected=ready
  $ssh_connect_cmd -tt -L ${local_port}:${forward_host}:${forward_port} "echo ${connected}; bash -l" >  ${logfile} 2>&1 &

  cleanuptrap

  log "waiting for ssh client to connect..."
  until grep ${connected} ${logfile} >/dev/null
  do
    sleep .5
  done
  log "connected to ssh server"

  log "running:"
  log "$local_connect_cmd"
  $local_connect_cmd
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
