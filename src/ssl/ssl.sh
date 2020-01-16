rootdir=`dirname "$(readlink -f "$0")"`
. ${rootdir}/../general/common.sh

sslencrypt() {
  local ssl_host=$1
  local ssl_port=$2
  local local_connect_cmd="${@:3}"

  local listen_port
  listen_port=`find_free_port`

  log "forwarding localhost:$listen_port to ssl endpoint ${ssl_host}:${ssl_port}"
  local logfile=/tmp/stunnel.log
  local conf=/tmp/stunnelconf
  stunnelconf $listen_port $ssl_host $ssl_port $logfile> $conf
  stunnel $conf 2>&1 &

  local pid=`echo $!`
  cleanuptrap $pid
 
  log "waiting for stunnel to initialize..."
  wait_for_file_to_contain 'Cron thread initialized' ${logfile}
  log "stunnel ready"

  local port=$listen_port #cmd should contain $port
  verboserun "$local_connect_cmd"
}

stunnelconf() {
  local listen_port=$1
  local ssl_host=$2
  local ssl_port=$3
  local logfile=$4
  cat <<eof
fips = no
pid =
debug = 7 
delay = yes
options = NO_SSLv3
output = ${logfile}
log = overwrite
foreground = quiet
[ssl-cli]
  client = yes
  accept = 127.0.0.1:$listen_port
  connect = ${ssl_host}:${ssl_port}
eof
}
