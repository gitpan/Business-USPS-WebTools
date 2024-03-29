# $Id: Makefile.PL,v 1.2 2006/09/16 08:40:57 comdog Exp $
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";

WriteMakefile(
	'NAME'	       => 'Business::USPS::WebTools',
	'VERSION_FROM' => 'lib/WebTools.pm',

	'PREREQ_PM'    => {
		'Test::More'     => '0',
		'Hash::AsObject' => '0',
		'Test::Manifest' => 1.14,
		'LWP::Simple'    => '0',
		},

	'PM'           => {
		'lib/WebTools.pm'               => '$(INST_LIBDIR)/WebTools.pm',
		'lib/AddressStandardization.pm' => '$(INST_LIBDIR)/WebTools/AddressStandardization.pm',
		'lib/ZipCodeLookup.pm'          => '$(INST_LIBDIR)/WebTools/ZipCodeLookup.pm',
		'lib/CityStateLookup.pm'        => '$(INST_LIBDIR)/WebTools/CityStateLookup.pm',
		},

	'MAN3PODS'     => {
		'lib/WebTools.pm'               => '$(INST_MAN3DIR)/Business::USPS::WebTools.3',
		'lib/AddressStandardization.pm' => '$(INST_LIBDIR)/Business::USPS::WebTools::AddressStandardization.3',
		'lib/ZipCodeLookup.pm'          => '$(INST_LIBDIR)/Business::USPS::WebTools::ZipCodeLookup.3',
		'lib/CityStateLookup.pm'        => '$(INST_LIBDIR)/Business::USPS::WebTools::CityStateLookup.3',
		},

	clean  => { FILES    => q|Business-USPS-WebTools-*| },

	);
