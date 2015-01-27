#!/usr/bin/perl
use strict;
use warnings;
use Unicorn;
use Jenkins::API;
use List::Util 1.41 qw/all/;

my $url = shift;
my $user = shift;
my $auth_token = shift;

my $args = { base_url => $url };
if($user && $auth_token)
{
    $args->{api_key} = $user;
    $args->{api_pass} = $auth_token;
}
my $u = Unicorn->new();
my $api = Jenkins::API->new($args);
unless($api->check_jenkins_url)
{
    $u->clear;
    $u->show;
    exit 1;
}
my $view_list = $api->current_status({ extra_params => { tree => 'views[name]' }});
my @views = grep { $_ ne 'All' } map { $_->{name} } @{$view_list->{views}};
my $ok = 1;
for my $view (@views)
{
    my $view_jobs = $api->view_status($view, { extra_params => { tree => 'jobs[name,color]' }});
    # don't fail for aborted jobs.
    my $view_ok = all { $_ =~ /^(blue|aborted)/ } map { $_->{color} } @{$view_jobs->{jobs}};
    $ok = $ok && $view_ok;
}

$u->set_brightness(0.1);

my @pixels;
if($ok)
{
    # green light
    @pixels = (
      0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0,
      0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0,
      0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0,
      0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0,
      0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0,
      0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0,
      0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0,
      0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0
    );
}
else
{
    # red cross
    @pixels = (255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 
     0, 0, 255, 0, 0,
     255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0,
     0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0,
     255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0,
     255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0);
}

$u->set_all_pixels(@pixels);
$u->show;

