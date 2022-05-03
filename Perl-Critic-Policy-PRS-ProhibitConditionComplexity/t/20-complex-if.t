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

plan tests => 10;

#####

sub get_perl_critic_object {
    my @configs = @_;

    my $pc = Perl::Critic->new(
        -profile  => 'NONE',
        -only     => 1,
        -severity => 1,
        -force    => 0
    );

    $pc->add_policy( -policy => $POLICY_NAME, @configs );

    return $pc;
}

#####

{
    my $pc = get_perl_critic_object();

    my $code = q~
~;

    my @violations = $pc->critique( \$code );
    ok !@violations, 'empty code block ok';
}

#####

{
    my $pc = get_perl_critic_object( -params => { max_mccabe => 1 } );

    my $code = q~
		if(1) {
			return $x;
		}
    ~;

    my @violations = $pc->critique( \$code );

    ok !@violations, 'if(1) no violation';
}

#####

{
    my $pc = get_perl_critic_object( -params => { max_mccabe => 1 } );

    my $code = q~
		if(1==1) {
			return $x;
		}
    ~;

    my @violations = $pc->critique( \$code );

    ok !@violations, 'if(1==1) no violation';
}

#####

{
    my $pc = get_perl_critic_object( -params => { max_mccabe => 1 } );

    my $code = q~
		if(!1) {
			return $x;
		}
    ~;

    my @violations = $pc->critique( \$code );

    ok !@violations, 'if(!1) no violation';
}

#####

{
    my $pc = get_perl_critic_object( -params => { max_mccabe => 1 } );

    my $code = q~
		if( ! 1 && 1 ) {
			return $x;
		}
    ~;

    my @violations = $pc->critique( \$code );

    ok @violations, 'violation with logical and';
}

#####

{
    my $pc = get_perl_critic_object( -params => { max_mccabe => 2 } );

    my $code = q~
		if( ! 1 && 1 ) {
			return $x;
		}
    ~;

    my @violations = $pc->critique( \$code );

    ok !@violations, 'no violation with logical and when mcc 2 allowed';
}

#####

{
    my $pc = get_perl_critic_object();

    my $code = q~
        if( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = $pc->critique( \$code );

    ok !!@violations, 'complex if mcc value reached';

    my $correct_text = 0;

    if (@violations) {
        my Perl::Critic::Violation $violation = $violations[0];
        $correct_text = $violation->description() =~ /condition-block .* complexity score \(3\)/io;

    }

    ok $correct_text, 'descript correct mcc value 3 not allowd';
}

#####

{
    my $pc = get_perl_critic_object( -params => { max_mccabe => 4 } );

    my $code = q~
        if( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = $pc->critique( \$code );
    ok !@violations, 'no violation if mcc value 3 allowed limit 4';
}

#####

{
    my $pc = get_perl_critic_object();

    my $code = q~
        while( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = $pc->critique( \$code );

    ok !!@violations, 'complex while mcc value reached';
}

#####

done_testing();
