use strict;
use warnings;
use HTTP::Request::Common qw(POST); 
use LWP::UserAgent; 
use JSON; 
package RT::Extension::Slack;

our $VERSION = '0.01';

=head1 NAME

RT-Extension-Slack - Integration with Slack webhooks

=head1 DESCRIPTION

This module is designed for *Request Tracker 4* integrating with *Slack* webhooks. It was modified from Maciek's original code which was posted on RT's mailing list. His original code is [found here](http://www.gossamer-threads.com/lists/rt/users/128413#128413)

=head1 RT VERSION

Works with RT 4.2.0

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

If you are using RT 4.2 or greater, add this line:

    Plugin('RT::Extension::Slack');

For RT 4.0, add this line:

    Set(@Plugins, qw(RT::Extension::Slack));

or add C<RT::Extension::Slack> to your existing C<@Plugins> line.

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

Andrew Wippler E<lt>andrew.wippler@gmail.comE<gt>

=head1 BUGS

All bugs should be reported via email to

    L<bug-RT-Extension-Slack@rt.cpan.org|mailto:bug-RT-Extension-Slack@rt.cpan.org>

or via the web at

    L<rt.cpan.org|http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-Slack>.

=head1 LICENSE AND COPYRIGHT

The MIT License (MIT)

Copyright (c) 2015 Andrew Wippler

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



=cut
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
