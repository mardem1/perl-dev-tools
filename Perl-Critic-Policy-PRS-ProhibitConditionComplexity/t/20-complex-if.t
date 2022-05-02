#!perl

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use Test::More;

use Perl::Critic;
use Perl::Critic::Utils qw{ :severities };

Readonly::Scalar my $POLICY_NAME => 'Perl::Critic::Policy::PRS::ProhibitConditionComplexity';

plan tests => 1;

{
    my $pc = Perl::Critic->new(
        -profile  => 'NONE',
        -only     => 1,
        -severity => 1,
        -force    => 0
    );

    $pc->add_policy( -policy => $POLICY_NAME );

    my $code = q~
~;

    my @violations = $pc->critique( \$code );
    ok !@violations;
}

done_testing();
