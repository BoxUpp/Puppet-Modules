#Nagios with nsca for Monitoring Java Application Logs

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with nagios](#setup)
    * [What nagios affects](#what-nagios-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nagios](#beginning-with-nagios)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The nagios module handles installing, configuring, and running nagios across a range of operating systems and distributions.



##Module Description

The nagios module installs and configure nagios with nsca which monitors application logs through nagios.In order to
monitor logs of your application please add following files at you Java class path and define IP of nagios server at log4j.xml
this files are available on files directory of this module.

	1.log4j.xml
	2.log4j-1.2.16.jar
	3.NagiosAppender-1.0.1-SNAPSHOT.jar
	4.NagiosIncludeExcludeFilters.properties
	5.nsca_send_clear.cfg

##Architecture

This module uses following architecture 

![Architecture](http://www.boxupp.com/assets/img/nagios.png)

##Setup

###What nagios affects

* Installs and configure nagios with nsca.
* Configures localhost.cfg file according to your requuirement.


###Beginning with nagios

`include 'nagios'` is enough to get you up and running.  If you wish to pass in
parameters Setsing which servers to use, then:

```puppet
node "puppet.vagrant.nagios.com" 
    {
        include nagios 
    }
```

##Usage

All interaction with the nagios module can do be done through the main nagios class.
This means you can simply toggle the options in `nagios` to have full functionality of the module.


###Parameters

The following parameters are available in the nagios module:

####`source_path`

The is the directory from  where the nagios module will get its setup files.

####`node_hostname`

Specify hostname for node you want to monitor.

####`node_alias`

Specify alias name for node you want to monitor.

####`nagios_alias`

Specify alias name of the server where nagios will be installed.

####`node_ip`

Specify IP for node  you want to monitor.

####`nagios_ip`

Specify IP for server where nagios will be installed.

####`node_grp_name`

Specify group name for node you want to monitor.

####`nagios_grp_name`

Specify group name of the server where nagios will be installed.

####`node_grp_alias`

Specify alias group name for node you want to monitor.

####`nagios_grp_alias`

Specify alias group name of the server where nagios will be installed.

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
