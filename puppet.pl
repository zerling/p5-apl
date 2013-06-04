#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;
require 'puppet_cfg.pl';

our %cfg;
my @confItems = qw (ServerAdmin ServerName KeepAlive MaxKeepAliveRequests KeepAliveTimeout MaxClients MaxRequestsPerChild);
my $uninst = '';
GetOptions ('u|uninst' => \$uninst);
######################################################################################################### 
sub httpdInst {
	chomp (my @rpms = `rpm -q httpd`);
	if ($?) {
		`yum install httpd -y`;
		print "inst ok\n" if !$?;
	}	
}
sub httpdUninst {
	if ($uninst){
		`yum remove httpd -y`;
		print "uninst ok\n" if !$?;
	}
}
sub sytemTest {
	die "error: Red Hat Enterprise Linux is required" if (!-f '/etc/redhat-release');
}
sub httpdConfEdit {
	my $confFile = '/etc/httpd/conf/httpd.conf';
	#my $confFile = 'a.txt';
	my @lines;
	
	open (HCONFIN, "<$confFile") or die "cannot open $confFile\n";
	while (<HCONFIN>){
		chomp;
		REGULAR:
		foreach my $item (@confItems){
			if (s/^#?$item .*/$item $cfg{$item}/) {
				print $_, "\n";
				last REGULAR;
			}
		}
		push @lines, $_;
	}
	close HCONFIN;
	my $str = join ("\n", @lines);
	$str =~ s/#?<(VirtualHost) .*?>.*?<\/\1>\n?//sg;
	$str =~ s/(\n)#?NameVirtualHost .*\n/$1/sg;
	foreach my $vhHash (@{$cfg{sites}}){
		my $vhost = 
"<VirtualHost ${\$vhHash->{VirtualHost}}>
	ServerAdmin ${\$vhHash->{ServerAdmin}}
	DocumentRoot ${\$vhHash->{DocumentRoot}}
	ServerName ${\$vhHash->{ServerName}}
	ServerAlias ${\$vhHash->{ServerAlias}}
	ErrorLog ${\$vhHash->{ErrorLog}}
	CustomLog ${\$vhHash->{CustomLog}}
</VirtualHost>
";
		$str .= "NameVirtualHost ${\$vhHash->{VirtualHost}}\n";
		$str .= $vhost
	}
	@lines = split "\n", $str;
	open (HCONFOUT, ">$confFile") or die "cannot open $confFile for writing\n";
	print HCONFOUT $str;
	close HCONFOUT;
}
sub dirStructure {
	foreach my $vhHash ( @{$cfg{sites}} ){
		if ($vhHash->{CustomLog} =~ /(\/[\/\w]+)/){
			mkdir (dirname $1);
		}
		if ($vhHash->{CustomLog} =~ /(\/[\/\w]+)/){
			mkdir (dirname $1);
		}
	}
}
sub confTest {
	`apachectl configtest`;
	die "error: conf file httpd.conf check failed" if ($?);
}
sub startService {
	`service httpd restart`;
	warn "warn: httpd service start error" if ($?);
}
######################################################################################################### 
httpdUninst;
httpdInst;
sytemTest;
httpdConfEdit;
confTest;
dirStructure;
startService;

