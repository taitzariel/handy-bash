rootdir=`dirname "$(readlink -f "$0")"`
. ${rootdir}/ssh.sh

ssh_cfg=~/.config/ssh.cfg

usage() {
    programname=$(basename $1)
    echo "Usage: $programname remote_host remote_port command"
    echo "       $programname --ssh-cmd FILE"
    echo "Run a local command with ssh port forwarding."
}

tunnel() {
  if [ $# == 1 ] && ([[ ( $1 == "--help") ||  $1 == "-h" ]]); then
    usage $0
  elif [ $# == 2 ] && [[ ( $1 == "--ssh-cmd" ) ]]; then
    set_ssh_cmd $2
  elif (( $# >= 4 )); then
    local ssh_connect_cmd=`cat $ssh_cfg`
    portforward "$ssh_connect_cmd" "$@"
  else
    usage $0
    exit 1
  fi
}

set_ssh_cmd() {
  local cfg
  cfg=`realpath $1`
  rm $ssh_cfg || echo "no previous config" >&2
  ln -s $cfg $ssh_cfg
}
