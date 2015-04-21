#!/usr/bin/perl
use strict;
use warnings;
use Jenkins;

my $url = shift;
my $user = shift;
my $auth_token = shift;

my $args = { base_url => $url };
if($user && $auth_token)
{
    $args->{api_key} = $user;
    $args->{api_pass} = $auth_token;
}
my $api = Jenkins->new($args);
unless($api->is_alive)
{
    print "OFF\n";
    exit 1;
}
my $ok = $api->success_check;
print $ok ? "OK" : "FAIL";
print "\n";

