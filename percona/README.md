#percona

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with percona](#setup)
    * [What percona affects](#what-percona-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with percona](#beginning-with-percona)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Dependencies - ssl cerrtificate ](#Dependencies)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

##Overview

The puppet module for managing the installation of percona and restoring a mysql percona backup.

##Module Description

This is a puppet module to install percona-backup.A backup utilty tool for  mysql database server.
description 'It automatically restores data from the percona backup folder .Please donot run this 
module in production environment as because it cleans mysql data directory before restoring from 
the backup.

##Setup

###What percona affects

* percona package.
* restores data from percona backup


###Beginning with percona

`include 'percona'` is enough to get you up and running.  If you wish to pass in
parameters Setsing which servers to use, then:

```puppet
node "mysql.vagrant.com" 
    {
        include percona 
    }
```

##Usage

All interaction with the percona module can do be done through the main percona class.
This means you can simply toggle the options in `percona` to have full functionality of the module.


###Parameters

The following parameters are available in the percona module:

####`backup_dir`

The is the directory from  where the percona application will restore database.


##Dependencies

####`mysql`

In order to install and restore backup two things are needed 

*mysql
*backup directory containg mysql percona backup

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
