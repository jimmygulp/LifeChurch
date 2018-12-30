#!/usr/bin/perl

use feature qw(say);
use Mojo::UserAgent;
use Mojo::IOLoop;
use Switch;
 
my $OSBHost = "172.16.32.151";
my $OBSPort = "4444"; 

# Open WebSocket to echo service
my $ua = Mojo::UserAgent->new;
my $request = $ARGV[0];
my $action;

switch ($request) {
	case "start" { $action = "StartStreaming"; }
	case "stop"  { $action = "StopStreaming"; }
	case "list"  { $action = "GetSceneList"; }
	case "live"  { $action = "SetCurrentScene\", \"scene-name\": \"Live"; }
	case "black"  { $action = "SetCurrentScene\", \"scene-name\": \"Black"; }
	case "video"  { $action = "SetCurrentScene\", \"scene-name\": \"Video"; }
	else         { $action = "GetStreamingStatus"; }
}

$ua->websocket('ws://$OBSHost:$OBSPort' => sub {
  my ($ua, $tx) = @_;
 
  # Check if WebSocket handshake was successful
  say 'WebSocket handshake failed!' and return unless $tx->is_websocket;
 
  # Wait for WebSocket to be closed
  $tx->on(finish => sub {
    my ($tx, $code, $reason) = @_;
    say "WebSocket closed with status $code.";
  });
 
  # Close WebSocket after receiving one message
  $tx->on(message => sub {
    my ($tx, $msg) = @_;
    say "WebSocket message: $msg";
    $tx->finish;
  });
 
  # Send a message to the server
  my $message = '{"request-type": "' . $action . '","message-id": "1"}';
	say $message;
  $tx->send($message);
});
 
# Start event loop if necessary
Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
