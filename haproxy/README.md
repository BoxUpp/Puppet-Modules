#haproxy

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with haproxy](#setup)
    * [What haproxy affects](#what-haproxy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with haproxy](#beginning-with-haproxy)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Dependencies - ssl cerrtificate ](#Dependencies)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The haproxy module installs the haproxy-1.5-dev19.el6.x86_64 with default ssl certicicates provided in this module.

##Module Description

The haproxy module handles installing, configuring, and running haproxy with ssl across a range of operating systems and distributions

##Setup

###What haproxy affects

* haproxy package.
* configures ssl on haproxy.
* configures haproxy as service.

###Beginning with haproxy

`include 'haproxy'` is enough to get you up and running.  If you wish to pass in
parameters Setsing which servers to use, then:

```puppet
node "haproxy.vagrant.com" 
    {
        include haproxy 
    }
```

##Usage

All interaction with the haproxy module can do be done through the main haproxy class.
This means you can simply toggle the options in `haproxy` to have full functionality of the module.


###Parameters

The following parameters are available in the haproxy module:

####`sourcefile`

The is the directory from  where the haproxy module will get its setup files.


##Dependencies

####`ssl cerrtificate`

To generate your own ssl certificates please follow the following links

[http://grahamc.com/blog/openssl-madness-how-to-create-keys-certificate-signing-requests-authorities-and-pem-files/](http://grahamc.com/blog/openssl-madness-how-to-create-keys-certificate-signing-requests-authorities-and-pem-files/)

##Limitations

This module has been built on and tested against Puppet 2.7 and higher.

The module has been tested on:

* RedHat Enterprise Linux 5/6
* CentOS 5/6


##Development

Puppet Labs modules on the Puppet Forge are open projects, and community
contributions are essential for keeping them great. We can’t access the
huge number of platforms and myriad of hardware, software, and deployment
configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our
modules work in your environment. There are a few guidelines that we need
contributors to follow so that we can have a chance of keeping on top of things.

You can read the complete module contribution guide [on the Puppet Labs wiki.](http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing)

###Contributors

The list of contributors can be found at: [https://github.com/BoxUpp/Puppet-Modules/graphs](https://github.com/BoxUpp/Puppet-Modules/graphs)

##Sites
####site :[http://paxcel.net/](http://paxcel.net/) 
####site :[http://boxupp.com/](http://boxupp.com/)
