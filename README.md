# RT-Extension-Slack
This module is designed for *Request Tracker 4* integrating with *Slack* webhooks. It was modified from Maciek's original code which was posted on RT's mailing list. His original code is [found here](http://www.gossamer-threads.com/lists/rt/users/128413#128413)

## Installation on Debian/Ubuntu
    sudo mkdir -p /usr/share/request-tracker4/lib/RT/Extension
    cd /opt
    git clone https://github.com/andrewwippler/RT-Extension-Slack.git
    cd RT-Extension-Slack
    sudo cp Slack.pm //usr/share/request-tracker4/lib/RT/Extension/Slack.pm
Edit your **/etc/request-tracker4/RT_SiteConfig.d/50-debconf** to include the following:
    
    Set($SlackWebhookURL, "slack-hook-url");
Regenerate your **RT_SiteConfig.pm** and restart your webserver

    sudo update-rt-siteconfig
    sudo systemctl reload apache2.service
    
## Usage
In your scripts, add any overriding code:

    my $text = "New ticket <http://my-rt.tld/Ticket/Display.html?id=" . $self->TicketObj->Id . "|" . $self->TicketObj->Id . "> from " . $self->TicketObj->RequestorAddresses . ": " . $self->TicketObj->Subject;
    RT::Extension::Slack::Notify(icon_emoji => ':heavy_exclamation_mark:', text => $text); 

Defaults can be set by editing **/usr/share/request-tracker4/lib/RT/Extension/Slack.pm**
