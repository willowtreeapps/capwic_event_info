#! /usr/bin/perl
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use JSON;
#use Data::Dumper;


sub waitForTrigger() {
	my $URL = 'https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/teamawesome.json';

	my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
	my $header = HTTP::Request->new(GET => $URL);
	my $request = HTTP::Request->new('GET', $URL, $header);
	while(1) {
		my $response = $ua->request($request);
	
		if ($response->is_success){
			print $response->as_string;
			my $json = from_json($response->decoded_content);
			#print Dumper $json;
			#Customize this to fit the output of the other team!
			if($json->{'alanisawesome'}{'run'}) {
				runEvent();
				#Break out of the while loop
				last;
			} else {
				#Do nothing since we're waiting on new information
			}
		}elsif ($response->is_error){
			print "Error:$URL\n";
			print $response->error_as_HTML;
			#break out of the while loop as something is wrong
			last;
		}
		
		#Sleep for 5 seconds so we don't run for too long
		sleep(5);
	}
}

sub runEvent() {
	print "WE'RE A GO\n";
}

#This is the start of the script - we just wait for the trigger which will run the event
#For dev just replace this call with runEvent
waitForTrigger();