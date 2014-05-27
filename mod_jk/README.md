#Mod_Jk for Apache Tomcat-Cluster

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with Mod_Jk](#setup)
    * [What Mod_Jk affects](#what-Mod_Jk-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with Mod_Jk](#beginning-with-Mod_Jk)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The Mod_Jk module installs the Tomcat cluster using apache and tomcat connector mod_jk.

##Module Description

The Mod_Jk module handles installing, configuring, and running apache and tomcat connector mod_jk across a range of operating systems and distributions.

##Architecture

This module uses following architecture 

![Architecture](http://www.boxupp.com/assets/img/Tomcat-cluster-diagram.png)

##Setup

###What Mod_Jk affects

* Install mod_jk module for apache.
* Configures httpd.conf.
* configures worker.properties file.

###Beginning with Mod_Jk

`include 'Mod_Jk'` is enough to get you up and running.  If you wish to pass in
parameters Setsing which servers to use, then:

```puppet
node "Tomcat-Cluster.vagrant.com" 
    {
        include mod_jk 
    }
```

##Usage

All interaction with the Mod_Jk module can do be done through the main mod_jk class.
This means you can simply toggle the options in `mod_jk` to have full functionality of the module.


###Parameters

The following parameters are available in the Mod_Jk module:

####`source_path`

The is the directory from  where the Mod_Jk module will get its setup files.

####`mod_jk_version`

Specify mod_jk version which you want to install  

####`download_url`

Specify mod_jk download url.

####`download_dir`

Specify mod_jk download path

####`node1_ip`

Specify the ip for node1 of apache tomcat.

####`node2_ip`

Specify the ip for node2 of apache tomcat.


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
