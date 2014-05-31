#  Class: jboss
#
#  Install and configure jboss with java  
#
#  Parameters
#
#  [*$source_path*]
#  The is the directory from  where the jboss module will get its setup files and configurations
# 
#  [*$java_version*]
#  The parameter checks version of java i.e java 1.6  or java 1.7
# 
#  [*$java_dir*]
#  The is the base directory on which java is deployed.
# 
#  [*$platform*]
#  This parameter takes input from the user to check machine platform i.e x86 bit or x64 bit.
# 
#  [*$env_path*]
#  This the parameter which sets java path.
# 
#  [*$jboss_version*]
#  Specify jboss version which you want to install  
# 
#  [*$jboss_base_path*]
#  Specify jboss base path 
#
#  [*$jboss_machine_ip*]
#  Specify Ip of the machine where  jboss will be installed
# 
#  [*$javaDownloadURI*]
#  Specify java download url  
#  
#  Authors
#
#  Boxupp Team <http://boxupp.com/>
#
#  Copyright
#  Copyright © 2014-2015 Paxcel Technologies (p) Ltd
#  site : http://paxcel.net/   http://boxupp.com/

 class jboss		
 			(
			#Define java_version here 
			$java_version 		= hiera('jboss::java_version',	'7' ),
			#Define java_dir here 
			$java_dir  		= hiera('jboss::java_dir', 	'/usr/java' ),
			$use_cache    		= hiera('jboss::use_cache',   	false ),
			#Define OS platform here
			$platform     		= hiera('jboss::platform',   	'x64' ),
			# Define your source diectory path here.
			$source_path 		= hiera('jboss::source_path',	'/vagrant/modules/jboss/files' ),
			# Define your environment variable diectory path here.
			$env_path  		= hiera('jboss::env_path',	'/etc/profile.d/java.sh'),
			#Define jboss_version here 
			$jboss_version		= hiera('jboss::jboss_version', '7'),			
			# Define  jboss diectory path here.
			$jboss_base_path 	= hiera('jboss::jboss_base_path','/usr/jboss'),
			# Define Ip of the machine where  jboss will be installed
			$jboss_machine_ip	= hiera('jboss::jboss_machine_ip','192.168.111.24'),
			) {

    		# Setting default exec path for this module
		Exec { path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',] }
	
		file {"$java_dir":
            		ensure 	=> directory,
            		owner 	=> root, 
			group 	=> root,						
        		}

		case $platform {
			'x64': {
				$plat_filename = 'x64'
			}
			'x86': {
            	$plat_filename = 'i586'
			}
    		default: {
            	fail("Unsupported platform: ${platform}.  Implement me?")
			}
		}
	
    		case $java_version {
        	'7': {
            		$javaDownloadURI = "http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-${plat_filename}.tar.gz"
				$java_home = "${java_dir}/jdk1.7.0"
			}
        	'6': {
			$javaDownloadURI = "https://edelivery.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-${plat_filename}.bin"
				$java_home = "${java_dir}/jdk1.6.0_45"
			}
		default: {
			fail("Unsupported version: ${version}.  Implement me?")
			}	
		}
		
		$installerFilename = inline_template('<%= File.basename(@javaDownloadURI) %>')

		if ( $use_cache ){
			notify { 'Using local cache for oracle java': }
				
		file { "${java_dir}/${installerFilename}":
			source  => "puppet:///modules/jdk_oracle/${installerFilename}",
		}
		
		exec { 'get_jdk_installer':
			cwd     => $java_dir,
			creates => "${java_dir}/jdk_from_cache",
			command => 'touch jdk_from_cache',
			require => File["${java_dir}/jdk-${java_version}-linux-x64.tar.gz"],
		}
		} else {
		exec { 'get_jdk_installer':
			cwd     => $java_dir,
			creates => "${java_dir}/${installerFilename}",
			command => "wget -c --no-cookies --no-check-certificate --header \"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com\" --header \"Cookie: oraclelicense=accept-securebackup-cookie\" \"${javaDownloadURI}\" -O ${installerFilename}",
			timeout => 600,
				
		}
		file { "${java_dir}/${installerFilename}":
			owner 	=> root, 
			group 	=> root,
			mode    => '0755',
			require => Exec['get_jdk_installer'],
		}
		}

		# Java 7 comes in a tarball so just extract it.
		if ( $java_version == '7' ) {
		exec { 'extract_jdk7':
			cwd     => "${java_dir}/",
			command => "tar -xf ${installerFilename}",
			creates => $java_home,
			require => File["${java_dir}/${installerFilename}"],
		}
		}
		# Java 6 comes as a self-extracting binary
		if ( $java_version == '6' ) {
		exec { 'extract_jdk6':
			cwd     => "${java_dir}/",
			command => "${java_dir}/${installerFilename}",
			creates => $java_home,
			require => File["${java_dir}/${installerFilename}"],
		}
		}	
		if ( $java_version == '7' ) {
		exec { "set_java_home7":
			command => "echo 'export JAVA_HOME=${java_home}'>> ${env_path}",
			unless  => "grep 'JAVA_HOME=${java_home}' ${env_path}",
			require => Exec["extract_jdk7"],
		}
		}
		if ( $java_version == '7' ) {
		exec { "java_path7":
			command => "echo 'export PATH=\$JAVA_HOME/bin:\$PATH' >> ${env_path}",
			unless  => "grep 'export PATH=\$JAVA_HOME/bin:\$PATH' ${env_path}",
			require => Exec["set_java_home7"],
		}
		}
			
		if ( $java_version == '6' ) {
		exec { "set_java_home6":
			command => "echo 'export JAVA_HOME=${java_home}'>> ${env_path}",
			unless  => "grep 'JAVA_HOME=${java_home}' ${env_path}",
			require => Exec["extract_jdk6"],
		}
		}
		if ( $java_version == '6' ) {
		exec { "java_path6":
			command => "echo 'export PATH=\$JAVA_HOME/bin:\$PATH' >> ${env_path}",
			unless  => "grep 'export PATH=\$JAVA_HOME/bin:\$PATH' ${env_path}",
			require => Exec["set_java_home6"],
		}
		}
		if ( $java_version == '7' ) {
		exec { "set_env7":
			command => "bash -c 'source ${env_path}'",
			require => Exec["java_path7"];
		}
		}	
		if ( $java_version == '6' ) {
		exec { "set_env6":
			command => "bash -c 'source ${env_path}'",
			require => Exec["java_path6"];
		}
		}	
		file {"${jboss_base_path}":
            		ensure 	=> directory,
            		owner 	=> root, 
			group 	=> root,
			require => File["${java_dir}/${installerFilename}"],
		}
			
		package { 'epel-release-6-8.noarch':
			provider => 'rpm',
			ensure   => installed,
			source   => "http://mirror-fpt-telecom.fpt.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm",
			require	 => File["${jboss_base_path}"],
		}
		
		package { 'unzip':
			ensure => installed,
			require => Package['epel-release-6-8.noarch'];
		}
	
		case $jboss_version {
		'7': {
        		 $jbossDownloadURI 	= "http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip"
        		 $web_home 		= "${jboss_base_path}/jboss-as-7.1.1.Final"
			 $jboss_file_name	= "jboss-as-7.1.1.Final"
		}
		'6': {
			$jbossDownloadURI 	= "http://download.jboss.org/jbossas/6.1/jboss-as-distribution-6.1.0.Final.zip"
			$web_home 		= "${jboss_base_path}/jboss-6.1.0.Final"
			$jboss_file_name	= "jboss-as-distribution-6.1.0.Final"
		}
		default: {
            		fail("Unsupported java_version: ${jboss_version}.  Implement me?")
			}
		}	
			
		if ( $jboss_version in [ '7', '6' ] ) {	
		exec { 'get_jboss':
            		cwd     => $jboss_base_path,
            		command => "wget ${jbossDownloadURI}",
			unless  => "test -e ${jboss_file_name}.zip",
            		timeout => 600,
			require => Package['unzip'];
		}
		}
			
		if ( $jboss_version in [ '7', '6' ] ) {
		exec { 'extract_jboss':
            		cwd => "${jboss_base_path}/",
            		command => "unzip ${jboss_file_name}.zip",
            		creates => $web_home,
			unless  => "test -e ${jboss_file_name}",
            		require => Exec['get_jboss'],
		}
		}
		if ( $jboss_version == '7' ) {
		file { "${web_home}/standalone/configuration/standalone.xml":
			mode    => '0664',
			owner   => root,
			group   => root,
			content => template('jboss/standalone.xml.erb'),
			backup  => false,
			require => Exec['extract_jboss'],
		} 
		}
		
		if ( $jboss_version == '7' ) {
			file { "/etc/init.d/jboss":
			mode    => '777',
			owner   => root,
			group   => root,
			content => template('jboss/jboss7init.erb'),
			backup  => false,
			require => File["${web_home}/standalone/configuration/standalone.xml"];
		} 
		}
		
		if ( $jboss_version == '6' ) {
		file { "/etc/init.d/jboss":
			mode    => '777',
			owner   => root,
			group   => root,
			content => template('jboss/jboss6init.erb'),
			backup  => false,
			require => Exec['extract_jboss'],
		} 
		}
		
		service { "iptables":
            		enable => true,
            		ensure => stopped,
            		require =>File["/etc/init.d/jboss"];
        	}
					
	}	
