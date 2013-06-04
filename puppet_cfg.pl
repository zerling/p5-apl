#!/usr/bin/perl -w
#use strict;

%cfg = ();

sub defConf {
	$cfg{ServerAdmin}            =   'zeus@olympus.gr';
	$cfg{ServerName}             =   'mount.olympus.gr';
	$cfg{KeepAlive}              =   'on';
	$cfg{MaxKeepAliveRequests}   =   '70';
	$cfg{KeepAliveTimeout}       =   '5';
	$cfg{MaxClients}             =   '200';
	$cfg{MaxRequestsPerChild}    =   '3000';
	$cfg{sites}                  = [
                                       {
                                         VirtualHost  =>  '192.168.1.76',
                                         ServerAdmin  =>  'root@tantalus.gr',
                                         DocumentRoot =>  '/var/www/html',
                                         ServerName   =>  'www.tantalus.gr',
                                         ServerAlias  =>  'tantalus.gr',
                                         ErrorLog     =>  '/var/log/httpd/tantalus/error_log',
                                         CustomLog    =>  '/var/log/httpd/tantalus/access_log common',
                                       },
                                       {
                                         VirtualHost  =>  '192.168.1.77',
                                         ServerAdmin  =>  'root@ixion.gr',
                                         DocumentRoot =>  '/var/www/html',
                                         ServerName   =>  'www.ixion.gr',
                                         ServerAlias  =>  'ixion.gr',
                                         ErrorLog     =>  '/var/log/httpd/ixion/error_log',
                                         CustomLog    =>  '/var/log/httpd/ixion/access_log common',
                                       },
                                       ];
}

defConf;