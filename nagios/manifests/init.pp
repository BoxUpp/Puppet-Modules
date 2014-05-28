#  Class: nagios
#
#  Install and configure nagios with nsca  
#
#  Parameters
#
#  [*$node_hostname*]
#  Define hostname for node you want to monitor.
#
#  [*$nagios_hostname*]
#  Define hostname of the server where nagios will be installed.
#
#  [*$node_alias*]
#  Define alias name for node you want to monitor.
#
#  [*$nagios_alias*]
#  Define alias name of the server where nagios will be installed.
#
#  [*$node_ip*]
#  Define IP for node  you want to monitor.
#
#  [*$nagios_ip*]
#   Define IP for server where nagios will be installed.
#
#  [*$node_grp_name*]
#  Define group name for node you want to monitor.
#
#  [*$nagios_grp_name*]
#  Define group name of the server where nagios will be installed.
#
#  [*$node_grp_alias*]
#   Define alias group name for node you want to monitor.
#
#  [*$nagios_grp_alias*]
#  Define alias group name of the server where nagios will be installed.
#
#  [*$source_path*]
#  The is the directory from  where the nagios module will get its setup files and configurations.
# 
#  
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/
class nagios  
		(
		# Define hostname for node you want to monitor.
		$node_hostname		= hiera ('nagios::node_hostname',	'puppet.vagrant.tomcat.com'	),
		# Define hostname of the server where nagios will be installed.
		$nagios_hostname	= hiera('nagios::nagios_hostname',	'puppet.vagrant.nagios.com' ),
		# Define alias name for node you want to monitor.
		$node_alias			= hiera('nagios::node_alias',		'tomcat' ),
		# Define alias name of the server where nagios will be installed.
		$nagios_alias		= hiera('nagios::nagios_alias',		'nagios' ),
		# Define IP for node  you want to monitor.
		$node_ip			= hiera ('nagios::node_ip',    	'192.168.111.24'),
		# Define IP for server where nagios will be installed.
		$nagios_ip			= hiera ('nagios::nagios_ip',    	'192.168.111.23'),
		# Define group name for node you want to monitor.
		$node_grp_name		= hiera ('nagios::node_grp_name',	'tomcat-server'	),
		# Define group name of the server where nagios will be installed.
		$nagios_grp_name	= hiera('nagios::nagios_grp_name',	'nagios-server' ),
		# Define alias group name for node you want to monitor.
		$node_grp_alias		= hiera('nagios::node_grp_alias',	'tomcat-server' ),
		# Define alias group name of the server where nagios will be installed.
		$nagios_grp_alias	= hiera('nagios::nagios_grp_alias','nagios-server' ),
		# Define nagios modules source path
		$source_path 		= hiera('nagios::source_path',		'/vagrant/modules/nagios/files' ),
		)

	{
	
	Exec { path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',] }
	
		package { 'epel-release-6-8.noarch':
			provider => 'rpm',
			ensure   => installed,
			source   => "http://mirror-fpt-telecom.fpt.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm";
       	}
		
		package { 'httpd':
			ensure => installed,
			require => Package['epel-release-6-8.noarch'];
		}
	
	
		package { 'net-snmp':
			ensure  => installed,
			require => Package['httpd'];
		}

		package { 'xinetd':
			ensure  => installed,
			require => Package['net-snmp'];
		}
		
		package { 'nagios':
			ensure  => installed,
			require => Package['xinetd'];
		}
		
		package { 'nsca':
			ensure  => installed,
			require => Package['nagios'];
		}

		package { 'nsca-client':
            		ensure  => installed,
            		require => Package['nsca'];
        	}
	
		package { 'nagios-plugins-all':
			ensure  => installed,
			require => Package['nsca'];
		}
	
		package { 'nrpe':
			ensure  => installed,
			require => Package['nsca'];
		}					
			   
		file { "/etc/nagios/objects/commands.cfg":
			source => "$source_path/commands.cfg",
			mode    => '0664',
			owner   => nagios,
			group   => nagios,
			backup 	=> false,
            		require => Package["nrpe"];
         	} 
		 
		file { "/etc/nagios/objects/localhost.cfg":
			mode    => '0664',
			owner   => nagios,
			group   => nagios,
			content => template('nagios/localhost.cfg.erb'),
			backup  => false,
       			require => File[ "/etc/nagios/objects/commands.cfg" ];
        	} 
		 
		file { "/etc/nagios/objects/templates.cfg":
			source => "$source_path/templates.cfg",
			mode    => '0664',
			owner   => nagios,
			group   => nagios,
			backup 	=> false,
           		require =>File[ "/etc/nagios/objects/localhost.cfg" ];
        	} 
	      
	   
		service { "nagios":
			enable  => true,
			ensure  => running, 
			require =>  Package['nrpe'];
		}
		
		service { "nsca":
			enable  => true,
			ensure  => running,
			require => Package['nrpe'];
        	}
       	
		service { "nrpe":
			enable  => true,
       			ensure  => running,
       			require => Package['nrpe'];        
        	}

        	service { "httpd":
            		enable  => true,
            		ensure  => running,
            		require => Package['nrpe'];
        	}

		service { "iptables":
			enable  => true,
			ensure  => stopped,
			require => Package['nrpe'];
        	}   
	   
	}
