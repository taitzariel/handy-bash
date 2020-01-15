rootdir=`dirname "$(readlink -f "$0")"`
. ${rootdir}/../general/common.sh

portforward() {
  local ssh_connect_cmd=$1
  local forward_host=$2
  local forward_port=$3
  local local_connect_cmd="${@:4}"

  local logfile=/tmp/ssh.log
  local connected=ready

  local listen_port
  listen_port=`find_free_port`

  log "port forwarding localhost:$listen_port to ${forward_host}:${forward_port}"
  $ssh_connect_cmd -tt -L ${listen_port}:${forward_host}:${forward_port} "echo ${connected}; bash -l" >  ${logfile} 2>&1 &

  local pid=`echo $!`
  cleanuptrap $pid

  log "waiting for ssh client to connect..."
  until grep ${connected} ${logfile} >/dev/null
  do
    sleep .5
  done
  log "connected to ssh server"

  port=$listen_port #cmd should contain $port
  verboserun "$local_connect_cmd"
}
