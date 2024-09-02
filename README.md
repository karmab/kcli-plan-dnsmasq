## Purpose

This repository provides a plan which deploys an installer vm where:
- openshift-install and oc are downloaded
- dnsmasq, and radvd are set to provide services in a dedicated network, either on ipv4 or ipv6

## Why

This provides a way to quickly set a dhcp/dns server in an isolated network 

## Requirements

### For kcli

- kcli installed (for rhel/centos/fedora, look [here](https://kcli.readthedocs.io/en/latest/#package-install-method))
- a supported kcli provider, such as libvirt or vsphere/esx

## Fake ipv6 network

For testing purposes, you can deploy a libvirt isolated network using the provided side plan:

```
kcli create plan -f fake_network.yml fakeipv6
```

## Launch

Prepare a valid parameter file with the information needed

Call the resulting file `kcli_parameters.yml` to avoid having to specify it in the creation command.

Then you can launch deployment with:

```
kcli create plan -P dnsmasq_network=fakeipv6
```

## Parameters

|Parameter                 |Default Value      |
|--------------------------|-------------------|
|dhcp_hosts_number         |253                |
|disk_size                 |80                 |
|dnsmasq_cidr              |2620:52:0:1307::/64|
|dnsmasq_network           |                   |
|dnsmasq_nic               |eth1               |
|domain                    |karmalabs.com      |
|external_installer_gateway|None               |
|external_installer_ip     |None               |
|external_installer_mask   |None               |
|external_network          |baremetal          |
|extra_disks               |[]                 |
|image                     |centos9stream      |
|installer_wait            |False              |
|launch_steps              |True               |
|macs                      |[]                 |
|memory                    |32768              |
|networkwait               |30                 |
|numcpus                   |16                 |
|pool                      |default            |
|rhnregister               |True               |
