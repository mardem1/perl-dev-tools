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

plan tests => 3;

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
    ok !@violations , 'empty code block ok';
}

{
    my $pc = Perl::Critic->new(
        -profile  => 'NONE',
        -only     => 1,
        -severity => 1,
        -force    => 0
    );

    $pc->add_policy( -policy => $POLICY_NAME );

    my $code = q~
        if( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = $pc->critique( \$code );
    ok !!@violations , 'complex if mcc value 3 not allowd limit 2' ;
}

{
    my $pc = Perl::Critic->new(
        -profile  => 'NONE',
        -only     => 1,
        -severity => 1,
        -force    => 0
    );

    $pc->add_policy( -policy => $POLICY_NAME , -params => { max_mccabe => 4 } );

    my $code = q~
        if( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = $pc->critique( \$code );
    ok !@violations , 'complex if mcc value 3 allowed limit 4';
}

done_testing();
