# $Id: WebTools.pm,v 1.1.1.1 2006/09/16 08:14:07 comdog Exp $
package Business::USPS::WebTools;
use strict;

use Carp qw(croak);

use subs qw();
use vars qw($VERSION);

$VERSION = '0.10_01';

=head1 NAME

Business::USPS::WebTools - This is the description

=head1 SYNOPSIS

	use Business::USPS::WebTools;

=head1 DESCRIPTION

*** THIS IS ALPHA SOFTWARE ***

This is the base class for the WebTools web service from the US Postal
Service. The USPS offers several services, and this module handles the
parts common to all of them: making the request, getting the response,
parsing error reponses, and so on. The interesting stuff happens in
one of the subclasses which implement a particular service. So far,
the only subclass in this distribution is 
C<Business::USPS::WebTools::AddressVerification>.

=over

=cut

my $LiveServer = "testing.shippingapis.com";
my $TestServer = "testing.shippingapis.com";

=item new( ANONYMOUS_HASH )

Make the web service object. Pass is an anonymous hash with these keys:

	UserID		the user id provided by the USPS
	Password	the password provided by the USPS
	Testing		true or false, to select the right server
	
If you don't pass the UserID or Password entries, C<new> looks in the
environment variables USPS_WEBTOOLS_USERID and USPS_WEBTOOLS_PASSWORD.

If C<new> cannot find both the User ID and the Password, it croaks.

=cut

sub new
	{
	my( $class, $args ) = @_;
	
	my $user_id = $args->{UserID} || $ENV{USPS_WEBTOOLS_USERID} ||
		croak "No user ID for USPS WebTools!";

	my $password = $args->{Password} || $ENV{USPS_WEBTOOLS_PASSWORD} ||
		croak "No password for USPS WebTools!";
	
	$args->{UserID}   = $user_id;
	$args->{Password} = $password;
	$args->{testing}  = $args->{Testing} || 0;
	$args->{live}     = ! $args->{Testing};
	
	bless $args, $class;
	}

sub _testing { $_[0]->{testing} }
sub _live    { $_[0]->{live}    }

=item userid

Returns the User ID for the web service. You need to get this from the 
US Postal Service.

=item password

Returns the Password for the web service. You need to get this from the 
US Postal Service.

=item url

Returns the URL for the request to the web service. So far, all requests
are GET request with all of the data in the query string.

=item response

Returns the response from the web service. This is the slightly modified
response. So far it only fixes up line endings and normalizes some error
output for inconsistent responses from different physical servers.

=cut

sub userid   { $_[0]->{UserID} }
sub password { $_[0]->{Password} }

sub url      { $_[0]->{url}      }
sub response { $_[0]->{response} }

sub _api_host
	{
	my $self = shift;
	
	if( $self->_testing ) { $TestServer }
	elsif( $self->_live ) { $LiveServer }
	else                  { die "Am I testing or live?" }
	}

sub _api_path { "/ShippingAPITest.dll" }

sub _make_url
	{
	my( $self, $hash ) = @_;
	
	$self->{url} = qq|http://| . $self->_api_host . $self->_api_path .
		"?" . $self->_make_query_string( $hash );
	}
	
sub _make_request
	{
	my( $self, $url ) = @_;
	require LWP::Simple;
	
	$self->{error} = undef;
	
	$self->{response} = LWP::Simple::get( $self->url );
	$self->{response} =~ s/\015\012/\n/g;

	$self->is_error;
	
	use Data::Dumper;
#	print STDERR "In _make_request:\n" . Dumper( $self ) . "\n";	
	
	$self->{response};
	}

=item is_error

Returns true if the response to the last request was an error, and false
otherwise.

If the response was an error, this method sets various fields in the
object:

	$self->{error}{number}      
	$self->{error}{source}      
	$self->{error}{description} 
	$self->{error}{help_file}   
	$self->{error}{help_context}

=cut

sub is_error
	{
	my $self = shift;
	
	return 0 unless $self->response =~ "<Error>";
	
	$self->{error} = {};
	
	# Apparently not all servers return this string in the 
	# same way. Some have SOL and some have SoL
	$self->{response} =~ s/SOLServer/SOLServer/ig; 
	
	( $self->{error}{number}       ) = $self->response =~ m|<Number>(-?\d+)</Number>|g;
	( $self->{error}{source}       ) = $self->response =~ m|<Source>(.*?)</Source>|g;
	( $self->{error}{description}  ) = $self->response =~ m|<Description>(.*?)</Description>|g;
	( $self->{error}{help_file}    ) = $self->response =~ m|<HelpFile>(.*?)</HelpFile>|ig;
	( $self->{error}{help_context} ) = $self->response =~ m|<HelpContext>(.*?)</HelpContext>|ig;
	
	1;
	}

=back	

=head1 SEE ALSO

The WebTools API is documented on the US Postal Service's website:

http://www.usps.com/webtools/htm/Address-Information.htm

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2006, brian d foy, All Rights Reserved.

You may redistribute this under the same terms as Perl itself.

=cut

1;
