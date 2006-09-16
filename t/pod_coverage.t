#!/usr/bin/perl
# $Id: pod_coverage.t,v 1.1.1.1 2006/09/16 08:14:07 comdog Exp $

use Test::More;
eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD coverage" if $@;
all_pod_coverage_ok();  