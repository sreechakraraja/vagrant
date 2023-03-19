#!/bin/bash

if grep -q 'opts' /home/krishna/Vagrant/machine/Vagrantfile; then
    echo "yes"
else
    echo "no"
fi

if [ -f /home/krishna/Vagrant/machine/Vagrantfile ]; then
    echo "yes"
else
    echo "no"
fi