#!/bin/bash

cmd=$(basename $BASH_SOURCE)

source ~/.config/proxy.conf #proxy_url, noproxy_values defined there
proxy_keys=(http_proxy HTTP_PROXY https_proxy HTTPS_PROXY)
noproxy_keys=(no_proxy NO_PROXY)

setproxyenv() {
	for i in ${proxy_keys[@]}; do
		echo "export ${i}=$proxy_url"
	done
	for i in ${noproxy_keys[@]}; do
		echo "export ${i}=$noproxy_values"
	done
}

unsetproxyenv() {
	all_keys=( "${proxy_keys[@]}" "${noproxy_keys[@]}" )
	for i in ${all_keys[@]}; do
		echo "unset ${i}"
	done
}

$cmd || echo "don't understand what you want"
