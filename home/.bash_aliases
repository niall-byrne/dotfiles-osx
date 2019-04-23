# ----------------------------------------------------------------
# Bash Aliases - Cross Platform Aliases and Source Logic
# ----------------------------------------------------------------

# Networking
alias n.online="ping -c 3 8.8.8.8"

# Vagrant
alias b.status='vagrant global-status'

# Editing
alias v.alias="vi ~/.bash_aliases"
alias v.alias_osx="vi ~/.bash_aliases.osx"
alias v.env="vi ~/.bash_env"
alias v.path="vi ~/.bash_path"
alias v.profile="vi ~/.bash_profile"
alias v.rc="vi ~/.bashrc"

# File Utils
alias f.clean="find . -name '.DS_Store'  -exec rm {} \;"

# Column Manipulation Shortcuts
for i in {1..10}; do alias "a$i"="awk '{ print $`echo ${i}` }'"; done
for i in {1..10}; do alias "c$i"="cut -d, -f`echo ${i}`"; done

# White Space Remover
function trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

# SSL Shortcuts
function s.date() {
	PORT=${2:-443}	
	HOST=${1}	
	echo | openssl s_client -servername $HOST -connect $HOST:$PORT 2>/dev/null | openssl x509 -noout -dates
}

# Docker Shortcuts

function d.quickey() {
	docker run -it --name quickey $1 sh
}

function d.rm() {
	containers="$(docker ps -qa)"
	[[ -z ${containers} ]] && echo "No containers to remove." && return 1
	docker rm ${containers}
}

function d.rmi() {
	images="$(docker images -q)"
	[[ -z ${images} ]] && echo "No images to remove." && return 1
	docker rmi ${images}
}

function d.clean() {
	images="$(docker images | grep none | awk '{print $3}')"
	[[ -z ${images} ]] && echo "No images to remove." && return 1
	docker rmi ${images}
}

function d.stop() {
	containers="$(docker ps -q)"
	[[ -z ${containers} ]] && echo "No containers to stop." && return 1
        docker stop ${containers}
}


function d.status() {
        docker ps -a
}


function d.kill() {
	containers="$(docker ps -q)"
	[[ -z ${containers} ]] && echo "No containers to stop." && return 1
        docker kill ${containers}
}

# Load Platform Specific Alias Files
case ${PLATFORM} in
*Darwin*)
    [[ -f ~/.bash_aliases.osx ]] && source ~/.bash_aliases.osx
    ;;
*Linux*)
    [[ -f ~/.bash_aliases.linux ]] && source ~/.bash_aliases.linux
    ;;
*)
    echo "WARNING: Cannot set environment for this unknown platform."
    ;;
esac

function instant_tmux() {
   tmux new -s instant
   
   tmux new-window -t instant "ssh byrnen@redshift-bridge.adm.beinstant.net" 
   tmux rename-window -t instant:1 redshift-bridge


}

alias push-ansible-mgmt='./pushAnsible.sh byrnen mgmt2.mgmt.beinstant.net'
alias push-ansible-dev='./pushAnsible.sh byrnen mgmt-dev.mgmt.beinstant.net'
alias vault-ansible-prd='ansible/scripts/vault.sh ansible/group_vars/tag_env_prd/vault'
alias vault-ansible-adm='ansible/scripts/vault.sh ansible/group_vars/tag_env_adm/vault'
alias vault-ansible-dev='ansible/scripts/vault.sh ansible/group_vars/tag_env_dev/vault'
alias vault-ansible-win='ansible/scripts/vault.sh ansible/group_vars/tag_platform_windows/vault'

alias kc=kubectl
