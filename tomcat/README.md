#tomcat

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with tomcat](#setup)
    * [What tomcat affects](#what-tomcat-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tomcat](#beginning-with-tomcat)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The tomcat module installs the apache-tomcat-7.0.53 with jdk and sets $JAVA_HOME path

##Module Description

The tomcat module handles installing, configuring, and running tomcat across a range of operating systems and distributions.

##Setup

###What tomcat affects

* tomcat package.
* java package.
* configures $JAVA_HOME path.

###Beginning with tomcat

`include 'tomcat'` is enough to get you up and running.  If you wish to pass in
parameters Setsing which servers to use, then:

```puppet
node "tomcat.vagrant.com" 
    {
        include tomcat 
    }
```

##Usage

All interaction with the tomcat module can do be done through the main tomcat class.
This means you can simply toggle the options in `tomcat` to have full functionality of the module.


###Parameters

The following parameters are available in the tomcat module:

####`source_path`

The is the directory from  where the tomcat module will get its setup files.

####`java_version`

The parameter checks version of java i.e java 1.7  or java 1.8.

####`java_dir`

The is the base directory on which java is deployed.

####`platform`

This parameter takes input from the user to check machine `platform` i.e x86 bit or x64 bit.

####`env_path`

The is the parameter which sets java path.

####`tomcat_version`

Sets tomcat version which you want to install.

####`tomcat_path`

Sets tomcat path.

####`javaDownloadURI`

Sets java download url.



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
