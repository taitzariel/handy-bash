#from https://kvz.io/blog/2013/11/21/bash-best-practices/

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace #uncomment this to debug

#from https://unix.stackexchange.com/questions/48533/exit-shell-script-from-a-subshell
set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR
