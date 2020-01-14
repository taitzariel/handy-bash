portforward() {
  local ssh_connect_cmd=$1
  local local_port=$2
  local forward_host=$3
  local forward_port=$4
  local local_connect_cmd="${@:5}"

  local logfile=~/tmp/ssh.log

  echo "port forwarding localhost:$local_port to ${forward_host}:${forward_port}" >&2
  local connected=ready
  $ssh_connect_cmd -tt -L ${local_port}:${forward_host}:${forward_port} "echo ${connected}; bash -l" >  ${logfile} 2>&1 &

  cleanuptrap

  echo "waiting for ssh client to connect..." >&2
  until grep ${connected} ${logfile} >/dev/null
  do
    sleep .5
  done
  echo "connected to ssh server" >&2

  echo "running:" >&2
  echo "$local_connect_cmd" >&2
  $local_connect_cmd
}

cleanuptrap() {
  local pid
  pid=`echo $!`
  echo "trapping process ${pid}" >&2
  cleanup() {
    local pid=$1
    echo "terminating process ${pid}" >&2
    kill "${pid}"
  }
  trap "cleanup $pid" EXIT
}