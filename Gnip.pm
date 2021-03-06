=head1 NAME
Gnip
=head1 DESCRIPTION
This class provides convenience methods for accessing the Gnip servers.
=head2 FUNCTIONS
The following functions are exported by default
=begin html
<HR>
=end html
=cut
package Gnip;
use strict;
use GnipHelper;

=head3 C<new($username, $password, $publisher)>
Initialize a Gnip object
=head4 Parameters
=over 4 
=item * <$username> (string) - The Gnip account username
=item * <$password> (string) - The Gnip account password
=back
=begin html
<HR>
=end html
=cut
sub new 
{
    my ($class, $username, $password) = @_;
    my $self = {
        _helper => new GnipHelper($username, $password),
    };
    bless $self, $class;
    return $self;
}

=head3 C<publish($publisher_name, $activity)>
This method takes in an activities XML document and sends it to the Gnip server.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The publisher of the data collection
=item * <$activity_xml> (string) - XML document formatted to Gnip schema <activities/> type
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub publish
{
   my ($self, $publisher_name, $activity_xml) = @_;
   my $url = $self->{_helper}->GNIP_BASE_URL . "/publishers/" . $publisher_name . "/activity";
   return $self->{_helper}->doHttpPost($url, $activity_xml);
}

=head3 C<get_publisher($publisher_name, $scope)>
This method takes in a publisher name and xml file and updates it
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The publisher of the data collection
=item * <$scope> (string) - scope of request (my, gnip, public)
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub get_publisher
{
   my ($self, $publisher_xml, $scope) = @_;
   my $url = $self->{_helper}->GNIP_BASE_URL . "/" . $scope . "/publishers/" . $publisher_name . ".xml";
   return $self->{_helper}->doHttpGet($url);
}


=head3 C<get_publishers>
This method takes in an xml publisher file and creates a new publisher
=head4 Parameters
=over 4 
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub get_publishers
{
   my ($self) = @_;
   my $url = $self->{_helper}->GNIP_BASE_URL . "/my/publishers.xml";
   return $self->{_helper}->doHttpGet($url);
}


=head3 C<create_publisher($publisher_xml)>
This method takes in an xml publisher file and creates a new publisher
=head4 Parameters
=over 4 
=item * <$publisher_xml> (string) - XML document formatted to Gnip schema <publisher/> type
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub create_publisher
{
   my ($self, $publisher_xml) = @_;
   my $url = $self->{_helper}->GNIP_BASE_URL . "/my/publishers/";
   return $self->{_helper}->doHttpPost($url, $publisher_xml);
}

=head3 C<update_publisher($publisher_name, $publisher_xml)>
This method takes in a publisher name and xml file and updates it
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The publisher of the data collection
=item * <$publisher_xml> (string) - XML document formatted to Gnip schema <publisher/> type
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub update_publisher
{
   my ($self, $publisher_name, $publisher_xml) = @_;
   my $url = $self->{_helper}->GNIP_BASE_URL . "/my/publishers/" . $publisher_name . ".xml";
   return $self->{_helper}->doHttpPut($url, $publisher_xml);
}


=head3 C<delete_rule($publisher_name, $filter_name, $rule_type, $rule_value, $scope)>
This method finds a particular rule on a publisher's filter
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The publisher of the data collection
=item * <$filter_name> (string) - The name of the filter to look for the rule
=item * <$rule_type> (string) - The type of the rule being sought
=item * <$rule_value> (string) - The value of the rule being sought
=item * <$scope> (string) - scope of request (my, gnip, public)
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub get_rule
{
    my ($self, $publisher_name, $filter_name, $rule_type, $rule_value, $scope) = @_;
    my $url = $self->{_helper}->GNIP_BASE_URL . "/" . $scope . "/publishers/" . $publisher_name . "/filters/" . $filter_name . "/rules.xml?type=" . $rule_type . "&value=" . $rule_value;
    return $self->{_helper}->doHttpGet($url);
}

=head3 C<delete_rule($publisher_name, $filter_name, $rule_type, $rule_value, $scope)>
This method deletes a rule from the specified publisher's filters
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The publisher of the data collection
=item * <$filter_name> (string) - The name of the filter from which the rule is being removed
=item * <$rule_type> (string) - The type of the rule being removed
=item * <$rule_value> (string) - The value of the rule being removed
=item * <$scope> (string) - scope of request (my, gnip, public)
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub delete_rule
{
    my ($self, $publisher_name, $filter_name, $rule_type, $rule_value, $scope) = @_;
    my $url = $self->{_helper}->GNIP_BASE_URL . "/" . $scope . "/publishers/" . $publisher_name . "/filters/" . $filter_name . "/rules.xml?type=" . $rule_type . "&value=" . $rule_value;
    return $self->{_helper}->doHttpDelete($url);
}

=head3 C<add_batch_rules($publisher_name, $filter_name, $rules_xml, $scope)>
This method adds a batch of rules to a publisher's filter
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The publisher of the data collection
=item * <$filter_name> (string) - The name of the filter to which the rules are being added
=item * <$rules_xml> (string) - XML document formatted to Gnip schema <rules/> type
=item * <$scope> (string) - scope of request (my, gnip, public)
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub add_batch_rules
{
    my ($self, $publisher_name, $filter_name, $rules_xml, $scope) = @_;
    my $url = $self->{_helper}->GNIP_BASE_URL . "/" . $scope . "/publishers/" . $publisher_name . "/filters/" . $filter_name . "/rules.xml";
    return $self->{_helper}->doHttpPut($url, $rules_xml);
}

=head3 C<get_activities($name, $publisher_name, $filter_name, $date_and_time)>
Gets all of the activities for a publisher.  If $date_and_time is passed in, it 
will be used to reference an activity bucket; this value
must be provided in UTC format.  Otherwise, the "current" bucket will be used.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The name of the publisher
=item * <$date_and_time> (long) - (optional) The UTC formatted date and time of the bucket.  
                                  If not provided, this will default to "current".
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub get_activities
{
   my ($self, $publisher_name, $date_and_time) = @_;

   my $when = "current";
   if ($date_and_time) 
   {
	  $when = $self->{_helper}->buildTimeString($date_and_time);
   }

   my $url = $self->{_helper}->GNIP_BASE_URL . 
		"/publishers/" . $publisher_name . "/activity/" . $when . ".xml";

   return $self->{_helper}->doHttpGet($url);
}

=head3 C<get_notifications($name, $publisher_name, $date_and_time)>
Gets all of the notifications for a publisher.  If $date_and_time is passed in, it 
will be used to reference an activity bucket; this value
must be provided in UTC format.  Otherwise, the "current" bucket will be used.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The name of the publisher
=item * <$date_and_time> (long) - (optional) The UTC formatted date and time of the bucket.  
                                  If not provided, this will default to "current".
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub get_notifications
{
   my ($self, $publisher_name, $date_and_time) = @_;

   my $when = "current";
   if ($date_and_time) 
   {
	  $when = $self->{_helper}->buildTimeString($date_and_time);
   }

   my $url = 
	$self->{_helper}->GNIP_BASE_URL . "/publishers/" . $publisher_name . "/notification/" . $when . ".xml";

   return $self->{_helper}->doHttpGet($url);
}

=head3 C<create_filter($publisher_name, $filter_xml)>
Creates a new filter on the publisher with the provided name.  This method takes a 
filter XML document formatted according to the <filters> element in Gnip.xsd.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The name of the publisher on which to create this filter.
=item * <$filter_xml> (string) - The XML for a <filters/> document that describes the Filter to create.
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub create_filter
{
   my ($self, $publisher_name, $filter_xml) = @_;

   my $url = $self->{_helper}->GNIP_BASE_URL.'/publishers/'.$publisher_name.'/filters.xml';

   return $self->{_helper}->doHttpPost($url, $filter_xml);
}

=head3 C<delete_filter($publisher_name, $filter_name)>
Deletes an existing filter from the Gnip server, based on the name of the filter.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The name of the publisher from which to delete this filter.
=item * <$filter_name> (string) - The name of the filter to delete
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub delete_filter
{
   my ($self, $publisher_name, $filter_name) = @_;

   my $url = $self->{_helper}->GNIP_BASE_URL."/publishers/".$publisher_name."/filters/".$filter_name.".xml";

   return $self->{_helper}->doHttpDelete($url);
}

=head3 C<find_filter($publisher_name, $filter_name)>
Find a filter XML document on Gnip given the name of a publisher and filter.
=head4 Parameters
=over 4
=item * <$publisher_name> (string) - The name of the publisher on which to find this filter
=item * <$filter_name> (string) - The name of the filter to find
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub find_filter
{
   my ($self, $publisher_name, $filter_name) = @_;

   my $url = $self->{_helper}->GNIP_BASE_URL . "/publishers/".$publisher_name."/filters/".$filter_name.".xml";

   return $url . "\n";

   return $self->{_helper}->doHttpGet($url);
}

=head3 C<update_filter($publisher_name, $filter_name, $filter_xml)>
Updates an existing filter on the Gnip server given a publisher name, filter name, and 
XML document conforming to the <filters/> element in Gnip.xsd.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The name of the publisher whose filter to update
=item * <$filter_name> (string) - The name of the filter to update
=item * <$filter_xml> (string) - The filter XML document
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub update_filter
{
   my ($self, $publisher_name, $filter_name, $filter_xml) = @_;

   my $url = 
	$self->{_helper}->GNIP_BASE_URL . "/publishers/" . $publisher_name . "/filters/" . $filter_name . ".xml";

   return $self->{_helper}->doHttpPut($url, $filter_xml);
}

=head3 C<get_filter_activities($name, $publisher_name, $filter_name, $date_and_time)>
Gets all of the activities for a specific filter from a publisher.  If
$date_and_time is passed in, it will be used to reference an activity bucket; this value
must be provided in UTC format.  Otherwise, the "current" bucket will be used.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The name of the publisher whose filter to check.
=item * <$filter_name> (string) - The name of the filter to check.
=item * <$date_and_time> (long) - (optional) The UTC formatted date and time of the bucket.  
                                  If not provided, this will default to "current".
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub get_filter_activities
{
    my ($self, $publisher_name, $filter_name, $date_and_time) = @_;
	
    my $when = "current";
    if ($date_and_time) 
    {
	  $when = $self->{_helper}->buildTimeString($date_and_time);
    }

   my $url = $self->{_helper}->GNIP_BASE_URL."/publishers/".$publisher_name."/filters/".$filter_name."/activity/".$when.".xml";

   return $self->{_helper}->doHttpGet($url);
}

=head3 C<get_filter_notifications($name, $publisher_name, $filter_name, $date_and_time)>
Gets all of the notifications for a specific filter from a publisher.  If
$date_and_time is passed in, it will be used to reference an activity bucket; this value
must be provided in UTC format.  Otherwise, the "current" bucket will be used.
=head4 Parameters
=over 4 
=item * <$publisher_name> (string) - The name of the publisher whose filter to check.
=item * <$filter_name> (string) - The name of the filter to check.
=item * <$date_and_time> (long) - (optional) The UTC formatted date and time of the bucket.  
                                  If not provided, this will default to "current".
=back
Returns an array of items from the HTTP response in the form ($content, $response_code).
=begin html
<HR>
=end html
=cut
sub get_filter_notifications
{
    my ($self, $publisher_name, $filter_name, $date_and_time) = @_;
	
    my $when = "current";
    if ($date_and_time) 
    {
	  $when = $self->{_helper}->buildTimeString($date_and_time);
    }

   my $url = $self->{_helper}->GNIP_BASE_URL."/publishers/".$publisher_name."/filters/".$filter_name."/notification/".$when.".xml";

   return $self->{_helper}->doHttpGet($url);
}

1;