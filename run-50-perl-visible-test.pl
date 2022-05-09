#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use Path::This qw( $THISDIR );
use Cwd qw( abs_path );
use File::Find::Rule;
use English qw( -no_match_vars );

Readonly::Scalar my $SYSTEM_START_FAILURE     => -1;
Readonly::Scalar my $SYSTEM_CALL_SIGNAL_BIT   => 127;
Readonly::Scalar my $SYSTEM_CALL_COREDUMP_BIT => 127;
Readonly::Scalar my $EXITCODE_OFFSET          => 8;

sub get_only_test_files
{

    ## no critic (ProhibitLongChainsOfMethodCalls)
    my $exclude =
        File::Find::Rule->new()->directory()->name( 'Mardem-RefactoringPerlCriticPolicies' )->prune()->discard();

    my $include_test = File::Find::Rule->new()->file()->name( '*.t' );

    my $search = File::Find::Rule->new()->or( $include_test, $exclude );

    my @files = $search->in( abs_path( $THISDIR ) );

    @files = map { abs_path( $_ ) } @files;

    return @files;
}

sub run_system_visible
{
    my ( @params ) = @_;

    say q{};
    say 'execute ' . ( join q{ }, @params );

    my $failure = system @params;

    if ( $failure ) {
        if ( $SYSTEM_START_FAILURE == $CHILD_ERROR ) {
            say "failed to execute: $ERRNO";
        }
        elsif ( $SYSTEM_CALL_SIGNAL_BIT & $CHILD_ERROR )    ## no critic (ProhibitBitwiseOperators)
        {
            ## no critic (ProhibitBitwiseOperators)
            printf "child died with signal %d, %s coredump\n", ( $SYSTEM_CALL_SIGNAL_BIT & $CHILD_ERROR ),
                ( $SYSTEM_CALL_COREDUMP_BIT & $CHILD_ERROR ) ? 'with' : 'without';
        }
        else {
            printf "child exited with value %d\n", $CHILD_ERROR >> $EXITCODE_OFFSET;
        }
    }

    say q{};

    return !!$failure;
}

sub run_test_visible
{
    my ( $filepath ) = @_;

    my $failure = run_system_visible( 'perl', $filepath );

    return !!$failure;
}

sub main
{
    # set include path for test
    local $ENV{ 'PERL5LIB' } = abs_path( $THISDIR ) . '/Perl-Critic-Policy-PRS/lib';

    my @test_files = get_only_test_files();

    my $failed_files = 0;

    foreach my $filepath ( @test_files ) {
        my $failure = run_test_visible( $filepath );

        if ( $failure ) {
            $failed_files++;
        }
    }

    if ( $failed_files ) {
        say q{};
        say q{};

        say 'ERROR: some files failed: ' . $failed_files;

        say q{};
        say q{};
    }
    else {
        say q{};
        say q{};

        say 'All Successful';

        say q{};
        say q{};
    }

    return;
}

main();

__END__

#-----------------------------------------------------------------------------

=pod

=encoding utf8

=head1 NAME

run-50-perl-visible-test.pl

=head1 DESCRIPTION

Helper script to run all test files with perl to see all the test output.

=head1 AUTHOR

mardem1 <>

=head1 COPYRIGHT

Copyright (c) 2022 All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. The full text of this license
can be found in the LICENSE file included with this module.

=cut
