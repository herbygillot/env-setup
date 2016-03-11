### env-setup

Customize the user environment.

Installs applications, user  directories and dotfiles.

##### Requirements

Requires Ansible.  Install using:

` $ sudo pip install -r requirements.txt `

**NOTE**: setup.sh installs Ansible automatically in Debian/Ubuntu environments

##### Usage

Simply run:

`$ ./setup.sh`

##### Details

```
  ./setup.sh - set up applications, user directories and dotfiles

  USAGE:

    ./setup.sh [-adr] [-- <args>]

    Any arguments specified in <args> are passed to ansible-playbook

  OPTIONS:

    -a      Only configure applications

    -d      Only configure dotfiles

    -r      Only configure directories

```
