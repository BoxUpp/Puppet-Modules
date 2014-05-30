![Architecture](http://www.boxupp.com/assets/img/jboss.png)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with jboss](#setup)
    * [What jboss affects](#what-jboss-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with jboss](#beginning-with-jboss)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The jboss module handles installing, configuring, and running jboss across a range of operating systems and distributions.



##Module Description

The jboss module installs and configure jboss 6 and 7 with java 1.6 and java 1.7 according to user requirement.

	
##Setup

###What jboss affects

* Installs and configure jboss.
* Configures ip in standalone.xml file according to user requirement.
* Configures init scripit according to user requirement.


###Beginning with jboss

`include 'jboss'` is enough to get you up and running.  If you wish to pass in
parameters Setsing which servers to use, then:

```puppet
node "puppet.vagrant.jboss.com" 
    {
        include jboss 
    }
```

##Usage

All interaction with the jboss module can do be done through the main jboss class.
This means you can simply toggle the options in `jboss` to have full functionality of the module.


###Parameters

The following parameters are available in the jboss module:

####`source_path`

The is the directory from  where the jboss module will get its setup files.

####`java_version`

Specify parameter checks version of java i.e java 1.6  or java 1.7.

####`java_dir`

Specify the base directory on which java is deployed.

####`platform`

Specify  this parameter it takes input from the user to check machine platform i.e x86 bit or x64 bit for java.

####`env_path`

This the parameter which sets java path.

####`jboss_version`

Specify jboss version which you want to install. 

####`jboss_base_path`

Specify jboss base path.

####`jboss_machine_ip`

Specify Ip of the machine where  jboss will be installed.

####`javaDownloadURI`

 Specify java download url.


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
