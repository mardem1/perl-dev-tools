#!perl

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Test::More;

plan tests => 1;

BEGIN {
    use_ok('Perl::Critic::Policy::PRS::ProhibitConditionComplexity')
        || print "Bail out!\n";
}

diag(
    "Testing Perl::Critic::Policy::PRS::ProhibitConditionComplexity $Perl::Critic::Policy::PRS::ProhibitConditionComplexity::VERSION, Perl $], $^X"
);
