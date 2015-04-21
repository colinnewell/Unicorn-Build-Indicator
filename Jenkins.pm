package Jenkins;

use strict;
use warnings;
use Jenkins::API;
use List::Util 1.41 qw/all/;

sub new
{
    my $class = shift;
    return bless {
        api => Jenkins::API->new(@_),
    }, $class;
}

sub is_alive
{
    my $self = shift;
    return $self->{api}->check_jenkins_url;
}

sub success_check
{
    my $self = shift;
    # this only checks your views for jobs.
    # it ignores any jobs not in views.
    # that allowed me to ignore inconvenient failures
    # without anything fancy.
    my $view_list = $self->{api}->current_status({ extra_params => { tree => 'views[name]' }});
    my @views = grep { $_ ne 'All' } map { $_->{name} } @{$view_list->{views}};
    my $ok = 1;
    for my $view (@views)
    {
        my $view_jobs = $self->{api}->view_status($view, {
                extra_params => {
                    tree => 'jobs[name,color,lastBuild[number],lastStableBuild[number]]',
                    depth => 1,
                }
            }
        );
        my $view_ok = all { $_ } map {
            $_->{lastStableBuild} && $_->{lastBuild} &&
            $_->{lastStableBuild}->{number} eq $_->{lastBuild}->{number}
        } @{$view_jobs->{jobs}};
        $ok = $ok && $view_ok;
    }
    return $ok;
}

1;

