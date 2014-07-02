[![Campaign_image](http://www.boxupp.com/assets/img/boxupp-header1.png)](http://www.boxupp.com/free-module.html)
#mysql

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mysql](#setup)
    * [What mysql affects](#what-mysql-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mysql](#beginning-with-mysql)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The mysql module installs and configures mysql
##Module Description

The mysql module handles installing, configuring, and running mysql across a range of operating systems and distributions.

##Setup

###What mysql affects

* installs mysql package.
* configures mysql.

###Beginning with mysql

`include 'mysql'` is enough to get you up and running.  If you wish to pass in
parameters Setsing which servers to use, then:

```puppet
node "mysql.vagrant.com" 
    {
        include mysql 
    }
```

##Usage

All interaction with the mysql module can do be done through the main mysql class.
This means you can simply toggle the options in `mysql` to have full functionality of the module.


###Parameters

The following parameters are available in the mysql module:

####`sourcefile`

The is the directory from  where the mysql module will get its configurations.

####`mysql_logs_dir`

Sets mysql log directory on this path.

####`mysql_download_path`

Sets the directory in which mysql packages will be downloaded.

####`mysql_server_download_url`

Sets the mysql server download url path.
####`mysql_client_download_url`

Sets the mysql client download url.

####`mysql_server_version`

Sets mysql-sever package version.

####`mysql_client_version`

Sets mysql-client package verion

####`mysql_server_package`

Sets  mysql server package name.

####`mysql_client_package`

Sets  mysql client package here.

####`root_password`

Sets mysql root password. 

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
