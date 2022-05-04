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

plan tests => 15;

#####

sub _get_perl_critic_object
{
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

sub _check_perl_critic
{
    my ( $code_ref, $max_mccabe ) = @_;

    my @params = ();
    if ($max_mccabe) {
        @params = ( -params => { max_mccabe => $max_mccabe } );
    }

    my $pc = _get_perl_critic_object(@params);

    return $pc->critique($code_ref);
}

#####

sub _get_description_from_violations
{
    my @violations = @_;

    my $desc = "";

    if (@violations) {
        my Perl::Critic::Violation $violation = shift @violations;
        my $tmp = $violation->description();

        if ($tmp) {
            $desc = $tmp;
        }
    }

    return $desc;
}

#####

{
    my $code = q~
~;

    my @violations = _check_perl_critic( \$code );
    ok !@violations, 'empty code block ok';
}

#####

{
    my $code = q~
		if(1) {
			return $x;
		}
    ~;

    my @violations = _check_perl_critic( \$code );

    ok !@violations, 'if(1) no violation';
}

#####

{
    my $code = q~
		if(1==1) {
			return $x;
		}
    ~;

    my @violations = _check_perl_critic( \$code, 1 );

    ok !@violations, 'if(1==1) no violation';
}

#####

{
    my $code = q~
		if(!1) {
			return $x;
		}
    ~;

    my @violations = _check_perl_critic( \$code, 1 );

    ok !@violations, 'if(!1) no violation';
}

#####

{
    my $code = q~
		if( ! 1 && 1 ) {
			return $x;
		}
    ~;

    my @violations = _check_perl_critic( \$code, 1 );

    ok @violations, 'violation with logical and';
}

#####

{
    my $code = q~
		if( ! 1 && 1 ) {
			return $x;
		}
    ~;

    my @violations = _check_perl_critic( \$code, 2 );

    ok !@violations, 'no violation with logical and when mcc 2 allowed';
}

#####

{
    my $code = q~
        if( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = _check_perl_critic( \$code );

    ok !!@violations, 'complex if mcc value reached';

    my $correct_text = _get_description_from_violations(@violations) =~ /"if" condition .* complexity score \(3\)/io;

    ok $correct_text, 'descript correct mcc value 3 not allowd';
}

#####

{
    my $code = q~
        if( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = _check_perl_critic( \$code, 4 );
    ok !@violations, 'no violation if mcc value 3 allowed limit 4';
}

#####

{
    my $code = q~
        unless( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = _check_perl_critic( \$code );

    ok !!@violations, 'complex unless mcc value reached';
}

#####

{
    my $code = q~
        while( 1 == 0 && 2 == 3 || 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = _check_perl_critic( \$code );

    ok !!@violations, 'complex while mcc value reached';
}

#####

{
    my $code = q~
        until( 1==1 || 2 == 3 && 4 == 6 ) {
            print 'test not reached';
        }
~;

    my @violations = _check_perl_critic( \$code );

    ok !!@violations, 'complex until mcc value reached';
}

#####

{
    my $code = q~
        do {
            print 'test not reached';
        } while( 1 == 0 && 2 == 3 || 4 == 6 );
~;

    my @violations = _check_perl_critic( \$code );

    ok !!@violations, 'complex do-while mcc value reached';
}

#####

{
    my $code = q~
        for( my $i = 0; $i < 10 && 1 == 0 && 2 == 3 || 4 == 6 ; $i++) {
            print 'test not reached';
        }
~;

    my @violations = _check_perl_critic( \$code );

    ok !!@violations, 'complex for mcc value reached';

    my $correct_text = _get_description_from_violations(@violations) =~ /"for" condition .* complexity score \(\d+\)/io;

    ok $correct_text, 'violation description correct with for';
}

#####

done_testing();
