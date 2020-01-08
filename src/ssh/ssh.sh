portforward() {
  local local_port=$1
  local forward_host=$2
  local forward_port=$3
  local local_connect_cmd="${@:4}"

  source ~/.config/ssh.cfg #for ssh config such as ssh_identity_file
  local logfile=~/tmp/ssh.log

  echo "port forwarding localhost:$local_port to ${forward_host}:${forward_port} via ${ssh_host}:${ssh_port}" >&2
  local connected=ready
  ssh -i $ssh_identity_file -p $ssh_port ${ssh_user}@${ssh_host} -tt -L ${local_port}:${forward_host}:${forward_port} "echo ${connected}; bash -l" >  ${logfile} 2>&1 &

  local ssh_pid
  ssh_pid=`echo $!`
  echo "ssh pid ${ssh_pid}" >&2

  echo "waiting for ssh client to connect..." >&2
  until grep ${connected} ${logfile} >/dev/null
  do
    sleep .5
  done
  echo "connected to ssh server" >&2

  echo "running:" >&2
  echo "$local_connect_cmd" >&2
  $local_connect_cmd || echo "exited with code $?" >&2

  echo "terminating ssh process ${ssh_pid}" >&2
  kill "${ssh_pid}"
}
