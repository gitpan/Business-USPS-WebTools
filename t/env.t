#!/usr/bin/perl
# $Id: env.t,v 1.1.1.1 2006/09/16 08:14:07 comdog Exp $

use Test::More;

use Test::More tests => 1;

print "Bail out! You need to set the USPS_WEBTOOLS_USERID and
USPS_WEBTOOLS_PASSWORD environment variables to test these
modules. If you don't know about these, see http://www.usps.com/webtools/"
	unless( defined $ENV{USPS_WEBTOOLS_USERID} 
		and defined $ENV{USPS_WEBTOOLS_PASSWORD} );

pass();