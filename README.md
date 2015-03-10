
# Installation

* Install [VirtualBox](http://www.virtualbox.org/)
* Install [Vagrant](http://vagrantup.com/) (1.6.5 or newer)
* Clone this repository and update its submodules

```bash
you@workstation$ cd ~
you@workstation$ git clone https://github.com/xclusv/vagrant-boxer-example
you@workstation$ cd vagrant-boxer-example
you@workstation$ git submodule update --init --recursive
```

## Create your new base box and login to it to make sure everything is how you want it

```bash
you@workstation$ cd ~
you@workstation$ cd vagrant-boxer-example/create-box-for-catalog
you@workstation$ vagrant up
```
