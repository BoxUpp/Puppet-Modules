#  Class: mod_jk
#
#  Install and configure mod_jk with java  
#
#  Parameters
#
#  [*$source_path*]
#  The is the directory from  where the mod_jk module will get its setup files and configurations
# 
#  [*$mod_jk_version*]
#  Specify mod_jk version which you want to install  
# 
#  [*$download_url*]
#  Specify mod_jk download url  
#
#  [*$download_dir*]
#  Specify mod_jk download path  
#
#  [*$node1_ip*]
#  Specify ip for node1
#
#  [*$node2_ip*]
#  Specify ip for node2
#  
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/

class mod_jk 
		(
		# Define mod_jk download url 
		$download_url	= hiera	('mod_jk::download_url', 	'http://archive.apache.org/dist/tomcat/tomcat-connectors/jk/') ,
		# Define mod_jk version 
		$mod_jk_version	= hiera ('mod_jk::mod_jk_version',	'tomcat-connectors-1.2.40-src.tar.gz'),
		# Define mod_jk file 
		$mod_jk_file    = hiera ('mod_jk::mod_jk_file', 	'tomcat-connectors-1.2.40-src'),
		# Define mod_jk download dir
		$download_dir	= hiera ('mod_jk::download_dir',	'/opt'	),
		# Define mod_jk modules source path
		$source_path 	= hiera('mod_jk::source_path',		'/vagrant/modules/mod_jk/files' ),
		# Define IP for node1
		$node1_ip	= hiera ('mod_jk::node1_ip',    	'192.168.111.23'),
		# Define IP for node2
		$node2_ip	= hiera ('mod_jk::node2_ip',    	'192.168.111.24'),
		)
		{
			Exec { path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',] }
			 
			package { 'epel-release-6-8.noarch':
        			 provider => 'rpm',
        			 ensure => installed,
                		source => "http://mirror-fpt-telecom.fpt.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm";
				}
						
			 package { 'httpd':
                		ensure => installed,
                		require => Package['epel-release-6-8.noarch'],
				}
				
			package { 'httpd-devel':
				ensure => installed,
                		require => Package['httpd'],
				}
			
			package { 'wget':
				ensure => installed,
                		require => Package['httpd-devel'],
				}
				
			package { 'gcc':
				ensure => installed,
                		require => Package['wget'],
				}
			
			package { 'gcc-c++':
				ensure => installed,
                		require => Package['gcc'],
				}
			
			package { 'make':
				ensure => installed,
                		require => Package['gcc-c++'],
                       
				}
				
			package { 'libtool':
				ensure => installed,
                		require => Package['make'],
				}
			
			exec { 'get_modjk_installer':
				cwd     => $download_dir,
				command => "wget '${download_url}/${mod_jk_version}'",
				unless 	=> "test -e ${mod_jk_version}",
				timeout => 1200,
				require => Package['libtool'],
            
			}
			
			exec { "extract_modjk":
				cwd	=> "$download_dir",
				command => "tar xzf '${mod_jk_version}'",
				unless 	=> "test -e ${mod_jk_file}",
				require => Exec['get_modjk_installer'],
			}

			exec { "copy_configure":
				cwd	=> "${download_dir}/${mod_jk_file}/native",
				command => "cp configure configure.sh",
				unless => "test -e configure.sh",
				require => Exec['extract_modjk'],
				
			}				
		
			exec { "install_modjk":
				cwd	=> "${download_dir}/${mod_jk_file}/native",
				command => "sh configure.sh --with-apxs=/usr/sbin/apxs",
				unless => "test -e /etc/httpd/modules/mod_jk.so",
				require => Exec['copy_configure'],
				
			}	
			
			exec { "make_modjk":
				cwd	=> "${download_dir}/${mod_jk_file}/native",
				command => "make",
				unless => "test -e /etc/httpd/modules/mod_jk.so",
				require => Exec['install_modjk'],
			}	
			
			exec { "make_install_modjk":
				cwd	=> "${download_dir}/${mod_jk_file}/native",
				command => "make install",
				unless => "test -e /etc/httpd/modules/mod_jk.so",
				require => Exec['make_modjk'],	
				
			}

			exec {"modjk_configure":
				command => "cat $source_path/modjk.conf >> /etc/httpd/conf/httpd.conf ",
				unless  => "grep '/etc/httpd/conf/workers.properties' /etc/httpd/conf/httpd.conf",
				require => Exec['make_install_modjk'],
			}
			
			file { "/etc/httpd/conf/workers.properties":
				mode    => '0460',
				owner   => root,
				group   => root,
				content => template('mod_jk/workers.properties.erb'),
				backup  => false,
				require => Exec["modjk_configure"];
			 
			}
			
			exec { "Open80":
				command => "iptables -I INPUT -p tcp --dport 80 -j ACCEPT",
				require => File["/etc/httpd/conf/workers.properties"];
			}
			
			exec { "start_httpd":
				command => "/etc/init.d/httpd restart",
				require =>  Exec["Open80"];
			}
			
					
		}	
			
		
		
		
		
		
		
