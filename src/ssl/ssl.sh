rootdir=`dirname "$(readlink -f "$0")"`
. ${rootdir}/../general/common.sh

sslencrypt() {
  local listen_port=$1
  local ssl_host=$2
  local ssl_port=$3
  local local_connect_cmd="${@:4}"

  log "forwarding localhost:$listen_port to ssl endpoint ${ssl_host}:${ssl_port}"
  local stunnelfile=/tmp/stunnelconf
  stunnelconf > $stunnelfile
  stunnel $stunnelfile

  cleanuptrap

  verboserun "$local_connect_cmd"
}

stunnelconf() {
  local listen_port=$1
  local ssl_host=$2
  local ssl_port=$3
  cat <<eof
fips = no
pid =
debug = 7 
delay = yes
options = NO_SSLv2
options = NO_SSLv3
output = /tmp/stunnel.log
log = overwrite
[ssl-cli]
  client = yes
  accept = 127.0.0.1:$listen_port
  connect = ${ssl_host}:${ssl_port}
eof
}
