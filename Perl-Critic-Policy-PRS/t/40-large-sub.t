#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;

use Perl::Critic;

use Test::More;

Readonly::Scalar my $POLICY_NAME => 'Perl::Critic::Policy::PRS::ProhibitLargeSub';

plan 'tests' => 1;

#####

{
    my $pc = Perl::Critic->new( '-profile' => 'NONE' , '-only' => 1 , '-severity' => 1 , '-force' => 0 );
    $pc->add_policy( '-policy' => $POLICY_NAME );

    my $code = <<'END_OF_STRING';
        sub my_test {
            # empty sub
        }
END_OF_STRING

    my @violations = $pc->critique( \$code );

    ok !@violations, 'no violation with empty sub';
}

#####

done_testing();
