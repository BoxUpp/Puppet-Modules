#  Class: haproxy
#
#  Install and configure haproxy for tomcat with default ssl certificates 
#
#  Parameters
#
#  [*$sourcefile*]
#  The is the directory from  where the haproxy module will get its setup files and configurations
#  
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/

class haproxy  

		 #Define your source diectory path here.
		(
			$sourcefile = '/vagrant/modules/haproxy/files',
		)

	{

		package { 'epel-release-6-8.noarch':
				provider => 'rpm',
				ensure   => installed,
				source   => "http://mirror-fpt-telecom.fpt.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm";
       		} 

	 	package { 'wget':
				ensure => installed,
				require => Package['epel-release-6-8.noarch'];
		}

		package { 'openssl-devel':
				ensure  => installed,
				require => Package['wget'];
		}

		package { 'pcre-devel':
				ensure  => installed,
				require => Package['openssl-devel'];
		}

		package { 'haproxy-1.5-dev19.el6.x86_64':
				provider => 'rpm',
				ensure   => installed,
				source   => "$sourcefile/haproxy-1.5-dev19.el6.x86_64.rpm",		 
		}

		file { "/etc/haproxy/haproxy.cfg":
				require => Package['haproxy-1.5-dev19.el6.x86_64'],
				backup  => false,
				source  => "$sourcefile/haproxy.cfg",				    
        	}


		file {"/etc/ssl":
				ensure  => directory,
				mode    => 644,
				require => File["/etc/haproxy/haproxy.cfg"];
        	}

		file {"/etc/ssl/certs/":
				ensure  => directory,
				mode    => 644,
				require => File["/etc/ssl"];
        	}

		file {"/etc/ssl/certs/server.pem":
				ensure  => directory,
				mode    => 644,
                		owner 	=> root, 
				group 	=> root,
				backup 	=> false,  
				require => File["/etc/ssl/certs/"],
				source  => "$sourcefile/server.pem",
        	}


		service { "iptables":
				enable  => true,
				ensure  => stopped,
				require => File["/etc/ssl/certs/server.pem"];
        	}
        
        
         	exec { "start_haproxy":                        
                		command => "/etc/init.d/haproxy start",
                		require => File["/etc/ssl/certs/server.pem"];
                
         	}
         	
         }
        
