#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Test::More;

plan 'tests' => 4;

BEGIN {
    my $error_txt = "Bail out!\n";

    use_ok( 'RPS::Util' )
        || print $error_txt;

    use_ok( 'Perl::Critic::Policy::PRS::ProhibitConditionComplexity' )
        || print $error_txt;

    use_ok( 'Perl::Critic::Policy::PRS::ProhibitBlockComplexity' )
        || print $error_txt;

    use_ok( 'Perl::Critic::Policy::PRS::ProhibitLargeSub' )
        || print $error_txt;
}

diag( "\nTesting Perl::Critic::Policy::PRS::ProhibitConditionComplexity $RPS::Util::VERSION, Perl $], $^X" );

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitConditionComplexity $Perl::Critic::Policy::PRS::ProhibitConditionComplexity::VERSION, Perl $], $^X"
);

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitBlockComplexity $Perl::Critic::Policy::PRS::ProhibitBlockComplexity::VERSION, Perl $], $^X"
);

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitBlockComplexity $Perl::Critic::Policy::PRS::ProhibitLargeSub::VERSION, Perl $], $^X"
);
