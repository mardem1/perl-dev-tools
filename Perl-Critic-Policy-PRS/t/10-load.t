#!perl

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Test::More;

plan tests => 2;

BEGIN {
    my $error_txt = "Bail out!\n";

    use_ok('Perl::Critic::Policy::PRS::ProhibitConditionComplexity')
        || print $error_txt;

    use_ok('Perl::Critic::Policy::PRS::ProhibitBlockComplexity')
        || print $error_txt;
}

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitConditionComplexity $Perl::Critic::Policy::PRS::ProhibitConditionComplexity::VERSION, Perl $], $^X"
);

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitBlockComplexity $Perl::Critic::Policy::PRS::ProhibitBlockComplexity::VERSION, Perl $], $^X"
);
