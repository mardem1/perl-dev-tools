#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use Perl::Critic;

Readonly::Scalar my $POLICY_NAME => 'Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt';

use Test::More;

plan 'tests' => 3;

#####

{
    my $pc = Perl::Critic->new( '-profile' => 'NONE', '-only' => 1, '-severity' => 1, '-force' => 0 );
    $pc->add_policy( '-policy' => $POLICY_NAME, '-params' => {} );

    my $code = <<'END_OF_STRING';
END_OF_STRING

    my @violations = $pc->critique( \$code );
    ok !@violations, 'empty code nothing found';
}

#####

{
    my $pc = Perl::Critic->new( '-profile' => 'NONE', '-only' => 1, '-severity' => 1, '-force' => 0 );
    $pc->add_policy( '-policy' => $POLICY_NAME, '-params' => {} );

    my $code = <<'END_OF_STRING';
        returns;
END_OF_STRING

    my @violations = $pc->critique( \$code );
    ok !@violations, 'returns not found';
}

#####

{
    my $pc = Perl::Critic->new( '-profile' => 'NONE', '-only' => 1, '-severity' => 1, '-force' => 0 );
    $pc->add_policy( '-policy' => $POLICY_NAME, '-params' => {} );

    my $code = <<'END_OF_STRING';
        return;
END_OF_STRING

    my @violations = $pc->critique( \$code );
    ok !!@violations, 'return found';
}

#####

done_testing();
