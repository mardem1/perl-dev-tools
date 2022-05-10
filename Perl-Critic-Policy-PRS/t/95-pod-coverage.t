#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Cwd qw( getcwd abs_path );
use Path::This qw( $THISDIR );
use Test::More;
use English qw( -no_match_vars );

my $cwd_dir      = abs_path( getcwd() );
my $expected_dir = abs_path( $THISDIR . '/../' );

if ( !$ENV{ 'RELEASE_TESTING' } ) {
    plan 'skip_all' => 'Author tests not required for installation';
}
#elsif ( $cwd_dir ne $expected_dir )
#{
#    BAIL_OUT "current working directory must be - $expected_dir !";
#}
else {
    # Ensure a recent version of Test::Pod::Coverage
    my $min_tpc = 1.08;                         ## no critic (ProhibitMagicNumbers)
    local $EVAL_ERROR = undef;
    eval "use Test::Pod::Coverage $min_tpc";    ## no critic (ProhibitStringyEval,RequireCheckingReturnValueOfEval)
    if ( $EVAL_ERROR ) {
        plan 'skip_all' => "Test::Pod::Coverage $min_tpc required for testing POD coverage";
    }

    # Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
    # but older versions don't recognize some common documentation styles
    my $min_pc = 0.18;                   ## no critic (ProhibitMagicNumbers)
    local $EVAL_ERROR = undef;
    eval "use Pod::Coverage $min_pc";    ## no critic (ProhibitStringyEval,RequireCheckingReturnValueOfEval)
    if ( $EVAL_ERROR ) {
        plan 'skip_all' => "Pod::Coverage $min_pc required for testing POD coverage";
    }

    chdir $expected_dir;

    all_pod_coverage_ok();

    chdir $cwd_dir;
}

done_testing();

__END__

#-----------------------------------------------------------------------------

=pod

=encoding utf8

=head1 NAME

95-pod-coverage.t

=head1 DESCRIPTION

Test-Script

=head1 AUTHOR

mardem1 <>

=head1 COPYRIGHT

Copyright (c) 2022 All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. The full text of this license
can be found in the LICENSE file included with this module.

=cut
