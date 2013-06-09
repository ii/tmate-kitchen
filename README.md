Tmate Kitchen
=============

---

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

2. Make sure you have the latest RVM:

        curl -L https://get.rvm.io | bash -s stable

3. Install Ruby:

        rvm install ruby-1.9.3-p392

4. Reload your shell (exit and come back).

5. Run the bootstrap script:

        ./bootstrap.sh

  Note: Do not type anything in the VM window during the creation of the base VM
  image, it may break the installation procedure.

This will:

* Download the ubuntu 12.04 ISO and create the base VM image (only for dev)
* Install vim-config, zsh-config, tmux-config (and keep them updated)
* Install the basic sys admin tools (htop, sysstat, iftop, ...)
* Install the tmate sources

---

Google Play Crawler Kitchen is released under the MIT license.
