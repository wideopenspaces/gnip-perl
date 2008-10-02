#!/usr/bin/perl
use Gnip;
use Getopt::Long;

if(@ARGV > 0) {
	GetOptions('user=s' => \$TEST_USERNAME, 'pass=s' => \$TEST_PASSWORD, 'publisher=s' => \$TEST_PUBLISHER);
}
else {
	print "Usage:\n  perl GnipTester.pl -user <username> -pass <password> -publisher <publisher_name>\n";
	exit 1;
}

print "Testing Gnip's Perl convenience library\n";

my $gnip = new Gnip($TEST_USERNAME, $TEST_PASSWORD);

my $numFailed = 0;
my $numPassed = 0;
my $response = "";

my $formatter = DateTime::Format::Strptime->new( pattern => '%Y-%m-%dT%H:%M:%S.000Z' );
my $currentTimeString =  DateTime->from_epoch( epoch => time(), formatter => $formatter );

my $activity = 
	'<activities>'.
	'  <activity at="' . $currentTimeString . '" action="update" actor="joe"/>'.
	'</activities>';

($response) = $gnip->publish($TEST_PUBLISHER, $activity);
if(-1 == index($response, 'Success')) {
   print "FAIL - Test of publish() failed!!\n";
   print "--- Response = " . $response . "\n";
   $numFailed += 1;
}
else {
    print "pass - Test of publish() passed\n";
    $numPassed += 1;
}

($response) = $gnip->get_notifications($TEST_PUBLISHER);
if(-1 == index($response, $currentTimeString)) {
    print "FAIL - Test of get() failed!!\n";
    print "--- Response = " . $response . "\n";
    $numFailed += 1;
}
else {
    print "pass - Test of get() passed\n";
    $numPassed += 1;
}

$filter_xml = 
	'<filter name="perltestfilter" fullData="true">'.
	'  <rule type="actor" value="me"/>'.
	'</filter>';
	
($response) = $gnip->create_filter($TEST_PUBLISHER, $filter_xml);
if(-1 == index($response, 'Success')) {
    print "FAIL - Test of create_filter() failed!!\n";
    print "--- Response = " . $response . "\n";
    $numFailed += 1;
}
else {
    print "pass - Test of create_filter() passed\n";
    $numPassed += 1;
}

($response) = $gnip->find_filter($TEST_PUBLISHER, "perltestfilter");
if(-1 == index($response, 'perltestfilter')) {
    print "FAIL - Test of find_filter() failed!!\n";
    print "--- Response = " . $response . "\n";
    $numFailed += 1;
}
else {
    print "pass - Test of find_filter() passed\n";
    $numPassed += 1;
}

$updatedFilterXml = 
	'<filter name="perltestfilter" fullData="true">'.
      ' <rule type="actor" value="me"/>'.
      ' <rule type="actor" value="you"/>'.
    '</filter>';

($response) = $gnip->update_filter($TEST_PUBLISHER, "perltestfilter", $updatedFilterXml);
if(-1 == index($response, 'Success')) {
    print "FAIL - Test of update_filter() failed!!\n";
    print "--- Response = " . $response . "\n";
    $numFailed += 1;
}
else {
    print "pass - Test of update_filter() passed\n";
    $numPassed += 1;
}

($response) = $gnip->get_filter_activities($TEST_PUBLISHER, "perltestfilter");
if(-1 == index($response, '<activities')) {
    print "FAIL - Test of get_filter() failed!!\n";
    print "--- Response = " . $response . "\n";
    $numFailed += 1;
}
else {
    print "pass - Test of get_filter_activities() passed\n";
    $numPassed += 1;
}

($response) = $gnip->delete_filter($TEST_PUBLISHER, "perltestfilter");
if(-1 == index($response, 'Success')) {
    print "FAIL - Test of delete_filter() failed!!\n";
    print "--- Response = " . $response . "\n";
    $numFailed += 1;
}
else {
    print "pass - Test of delete_filter() passed\n";
    $numPassed += 1;
}

print "\n" . $numPassed . " tests passed, " . $numFailed . " tests failed\n";