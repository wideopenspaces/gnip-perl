=head1 NAME
GnipHelper - Common functionality used to communicate with Gnip.
=head1 DESCRIPTION
This module provides basic, shared functionality for communicating with Gnip.
=head2 FUNCTIONS
The following functions are exported by this module.
=begin html
<HR>
=end html
=cut
package GnipHelper;
use strict;
use LWP::Debug; # qw(+ conns);
use LWP::UserAgent;
use DateTime;
use DateTime::Format::Strptime;

use constant GNIP_BASE_URL => 'https://prod.gnipcentral.com';
use constant GNIP_USER_AGENT_HEADER => "Gnip-Client-Perl/2.0";

=head3 C<new($username, $password)>
Initialize a GnipHelper instance
=head4 Parameters
=over 4 
=item * C<$username> (string) - The Gnip account username (an e-mail address)
=item * C<$password> (string) - The Gnip account password
=back
=begin html
<HR>
=end html
=cut
sub new 
{
    my ($class, $username, $password) = @_;
    my $self = {
        _username => $username,
        _password  => $password
    };
    bless $self, $class;
    return $self;
}

=head3 C<doHttpGet($url)>
Does an HTTP GET request using the passed in URL and returns the response from the server.
=head4 Parameters
=over 4
=item * C<$url> (string) - The URL to GET
=back
Returns a string representing the HTTP response.  If the request is successful, 
return the response body; otherwise, return the status line.
=begin html
<HR>
=end html
=cut
sub doHttpGet
{
	# todo: return the response code
   my ($self, $url) = @_;

   my $agent = LWP::UserAgent->new;
   my $request = HTTP::Request->new(GET => $url);
   $agent->agent(GNIP_USER_AGENT_HEADER);
   $request->authorization_basic($self->{_username}, $self->{_password});
   my $response = $agent->request($request);

   my $content = $response->status_line;
   if ($response->is_success) {
      $content = $response->content;
   }

  return ($content, $response->code);
}

=head3 C<doHttpPost($url, $data)>
Does a request using HTTP POST using the provided URL sending the data in the body.  
If the request was successful, the response body content is returned; otherwise,
the status line is returned.  The POST is sent with Content-Type set to 
application/xml.
=head4 Parameters
=over 4
=item * C<$url> (string) - The POST URL
=item * C<$data> (string) - The data sent with the POST
=back
Returns a string representing the HTTP response.  If the request is successful, 
return the response body; otherwise, return the status line.
=begin html
<HR>
=end html
=cut
sub doHttpPost 
{
   my ($self, $url, $data) = @_;

   my $agent = LWP::UserAgent->new;
   my $request = HTTP::Request->new(POST => $url);
   $agent->agent(GNIP_USER_AGENT_HEADER);
   $request->authorization_basic($self->{_username}, $self->{_password});
   $request->content_type('application/xml');
   $request->content($data);

   my $response = $agent->request($request);

   my $content = $response->status_line;
   if ($response->is_success) {
      $content = $response->content;
   }

  return ($content, $response->code);
}


=head3 C<doHttpPut($url, $data)>
Does a request using HTTP PUT using the provided URL sending the data in the body.  
If the request was successful, the response body content is returned; otherwise,
the status line is returned.  The PUT is sent with Content-Type set to 
application/xml.
=head4 Parameters
=over 4
=item * C<$url> (string) - The PUT URL
=item * C<$data> (string) -  The data sent with the PUT
=back
Returns a string representing the HTTP response.  If the request is successful, 
return the response body; otherwise, return the status line.
=begin html
<HR>
=end html
=cut
sub doHttpPut
{
   my ($self, $url, $data) = @_;
   return doHttpPost($self, $url.';edit', $data)
}

=head3 C<doHttpDelete($url)>
Does a request using HTTP DELETE using the provided URL sending the data in the body.  
If the request was successful, the response body content is returned; otherwise,
the status line is returned.  The PUT is sent with Content-Type set to 
application/xml.
=head4 Parameters
=over 4
=item * C<$url> (string) - The DELETE URL
=back
Returns a string representing the HTTP response.  If the request is successful, 
return the response body; otherwise, return the status line.
=begin html
<HR>
=end html
=cut
sub doHttpDelete
{
   my ($self, $url) = @_;
   return doHttpPost($self, $url.';delete', ' ')
}

=head3 C<roundTimeToNearestBucketBorder($theTime)>
Rounds the time passed in down to the previous minute mark.
=head4 Parameters
=over 4
=item * C<$theTime> (long) - The time to round
=back
Returns a long containing the rounded time
=begin html
<HR>
=end html
=cut
sub roundTimeToNearestBucketBorder
{
   my ($self, $theTime) = @_;

   my $dateTime = DateTime->from_epoch(epoch => $theTime);

   my $min = $dateTime->minute();
   my $newMin = $min - ($min % 1);

   $dateTime->set(minute => $newMin);
   $dateTime->set(second => 0);

   return $dateTime->epoch();
}

=head3 C<syncWithGnipClock($theTime)>
This method gets the current time from the Gnip server, gnipTimeets the current local 
time and determines the difference between the two. It then adjusts the passed in time to 
account for the difference.
=head4 Parameters
=over 4
=item * C<$theTime> (long) - The time to adjust
=back
Returns a long containing the adjusted time
=begin html
<HR>
=end html
=cut
sub syncWithGnipClock 
{
   my ($self, $theTime) = @_;

   # Do HTTP HEAD request
   my $agent = LWP::UserAgent->new;
   my $request = HTTP::Request->new(HEAD => GNIP_BASE_URL);
   my $response = $agent->request($request);

   my $localTime = time();
   my $formatter = DateTime::Format::Strptime->new( pattern => '%a, %d %b %Y %H:%M:%S %Z' );
   my $gnipTime = ($formatter->parse_datetime($response->header('Date')))->epoch();
   my $timeDelta = $gnipTime - $localTime;

   return $theTime + $timeDelta;
}

=head3 C<timeToString($theTime)>
Converts the time passed in to a string of the form YYYYMMDDHHMM.
=head4 Parameters
=over 4
=item * C<$theTime> (long) - The time to convert
=back
Returns a string containing the converted time
=begin html
<HR>
=end html
=cut
sub timeToString
{
   my ($self, $theTime) = @_;

   my $formatter = DateTime::Format::Strptime->new( pattern => '%Y%m%d%H%M' );

   return DateTime->from_epoch( epoch => $theTime, formatter => $formatter );
}

=head3 C<buildTimeString($theTime)>
Create a time string that can be passed to Gnip when referencing an activity or notification bucket.
=head4 Parameters
=over 4
=item * C<$time> (long) - The time whose bucket to reference; if absent, defaults to the current system time.
=back
Returns a string containing the converted time formatted for use referencing an activity or notification bucket.
=begin html
<HR>
=end html
=cut
sub buildTimeString
{
	my ($self, $date_and_time);
	
	if(undef == $date_and_time) 
	{
	    $date_and_time = time();	
	}
	
	my $correctedTime = $self->{_helper}->syncWithGnipClock($date_and_time);
    my $roundedTime = $self->{_helper}->roundTimeToNearestBucketBorder($correctedTime);
    return $self->{_helper}->timeToString($roundedTime);    
}

1;