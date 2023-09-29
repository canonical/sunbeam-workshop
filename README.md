# Overview

This project provides a quick and easy way to set Ubuntu machines
ontop of OpenStack to build into a MicroStack/OpenStack Sunbeam
based cloud.

Each machine will have two network ports (one configured) and three
attached block devices for use with Ceph.

'runme' assumes:

a) terraform is installed (snap install terraform --classic)
b) access details for openstack are contained in ${HOME}/openrc

A keypair is created as part of the setup and written to ${HOME}/.ssh/id\_rsa.

Instances are named sunbeam0, sunbeam1, sunbeam2 and should be
hostname resolvable with the same project network (hint: use a bastion instance).
