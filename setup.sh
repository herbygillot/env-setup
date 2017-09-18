#!/usr/bin/env bash

ANSIBLE_PLAYBOOK=${ANSIBLE_PLAYBOOK:-"ansible-playbook"}
SCRIPT_DIR="$( cd `dirname $0`; pwd -P )"
ANSIBLE_ARGS="-c local --ask-become-pass"

export ANSIBLE_TAGS=""


_abort() {
  # Abort and exit with error
  echo "ERROR: $* - Aborting"
  exit 1
}


_add_tag() {
  # Add an Ansible tag to filter on roles or tasks
  if [ -z "$1" ]; then
      return
  fi

  if [ -n "$ANSIBLE_TAGS" ]; then
      ANSIBLE_TAGS="${ANSIBLE_TAGS},$1"
  else
      ANSIBLE_TAGS="$1"
  fi
}


install_prereqs() {
  # Install Ansible and other pre-requisites
  if ( which apt-get > /dev/null ); then
    sudo apt-get install python-pip python-dev || _abort
    sudo pip install ansible || _abort
  fi
}


show_help() {
  # Print help message to standard out
  cat <<HELPEOF

    $0 - set up applications, user directories and dotfiles

    USAGE:

      $0 [-adr] [-- <args>]

      Any arguments specified in <args> are passed to ansible-playbook

    OPTIONS:

      -a      Only configure applications

      -d      Only configure dotfiles

      -r      Only configure directories

HELPEOF
}


while getopts ":adrh?" opt; do
  case $opt in
    a) # configure applications
        _add_tag applications
        ;;
    d) # configure dotfiles
        _add_tag dotfiles
        ;;
    r) # configure directories
        _add_tag directories
        ;;
    \?|h)
        show_help
        exit 0
        ;;
  esac
done


shift $((OPTIND-1))


# Add any specified tags to the ansible-playbook options
if [ -n "${ANSIBLE_TAGS}" ]; then
  ANSIBLE_ARGS="${ANSIBLE_ARGS} -t ${ANSIBLE_TAGS}"
fi


if ! ( which "${ANSIBLE_PLAYBOOK}" > /dev/null ); then
  install_prereqs
fi


ANSIBLE_COMMAND="${ANSIBLE_PLAYBOOK}
  ${SCRIPT_DIR}/playbooks/site.yml
  ${ANSIBLE_ARGS}
  $@"


${ANSIBLE_COMMAND}
