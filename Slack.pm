package RT::Extension::Slack; 

use HTTP::Request::Common qw(POST); 
use LWP::UserAgent; 
use JSON; 

sub Notify { 
	my %args = @_; 
	my $payload = { 
		username => 'Mr. RT', 
		channel	=>	'#request-tracker',
		icon_emoji => ':ghost:', 
		text => 'I have forgotten to say something', 
	}; 
	my $service_webhook; 


	foreach (keys %args) { 
		$payload->{$_} = $args{$_}; 
	} 
	if (!$payload->{text}) { 
		return; 
	} 
	my $payload_json = encode_json($payload); 

	$service_webhook = RT->Config->Get('SlackWebhookURL'); 
	if (!$service_webhook) { 
		return; 
	} 

	my $ua = LWP::UserAgent->new; 
	$ua->timeout(10); 

	$RT::Logger->info('Pushing notification to Slack: '. $payload_json); 
	my $r = POST($service_webhook, 
	[ 'payload' => $payload_json ]); 

	my $response = $ua->request($r); 
	if ($response->is_success) { 
		return;
	} else { 
		$RT::Logger->error('Failed to push notification to Slack ('. 
		$response->code .': '. $response->message .')'); 
	} 
} 

1; 
