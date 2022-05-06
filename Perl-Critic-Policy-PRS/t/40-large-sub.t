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

plan 'tests' => 2;

#####

sub _get_perl_critic_object
{
    my $pc = Perl::Critic->new(
        '-profile'  => 'NONE',
        '-only'     => 1,
        '-severity' => 1,
        '-force'    => 0
    );

    $pc->add_policy( '-policy' => $POLICY_NAME );

    return $pc;
}

#####

sub _check_perl_critic
{
    my ( $code_ref ) = @_;

    my $pc = _get_perl_critic_object();

    return $pc->critique($code_ref);
}

#####

{
    my $code = <<'END_OF_STRING';
        # empty code
END_OF_STRING

    my @violations = _check_perl_critic( \$code );

    ok !@violations, 'no violation with empty code';
}

#####

{
    my $code = <<'END_OF_STRING';
        sub my_test {
            # empty sub
        }
END_OF_STRING

    my @violations = _check_perl_critic( \$code );

    ok !@violations, 'no violation with empty sub';
}

#####

done_testing();
