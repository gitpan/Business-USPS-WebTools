#!/usr/bin/perl
# $Id: prereq.t,v 1.1.1.1 2006/09/16 08:14:07 comdog Exp $

use Test::More;
eval "use Test::Prereq";
plan skip_all => "Test::Prereq required to test dependencies" if $@;
prereq_ok();
																																														   