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

my $include = File::Find::Rule->new()->file()->name( '*.pl', '*.pm', '*.t' );

## no critic (ProhibitLongChainsOfMethodCalls)
my $exclude = File::Find::Rule->new()->directory()->name( 'Mardem-RefactoringPerlCriticPolicies' )->prune()->discard();

my $search = File::Find::Rule->new()->or( $include, $exclude );

my @files = $search->in( abs_path( $THISDIR ) );

foreach my $filepath ( @files ) {
    say q{};
    say 'Test: ' . $filepath;

    my $failure = system 'perlcritic', '--profile', abs_path( $THISDIR ) . '/.perlcriticrc', '--verbose', '9',
        $filepath;

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

}

__END__

#-----------------------------------------------------------------------------

=pod

=encoding utf8

=head1 NAME

run-60-perl-critic.pl

=head1 DESCRIPTION

Helper script to run perl-critic on all files.

=head1 AUTHOR

mardem1 <>

=head1 COPYRIGHT

Copyright (c) 2022 All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. The full text of this license
can be found in the LICENSE file included with this module.

=cut
