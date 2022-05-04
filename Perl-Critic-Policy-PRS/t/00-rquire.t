#!perl

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Test2::V0;
use Test2::Tools::Exception qw/lives/;

plan tests => 1;

ok( lives {
        require Perl::Critic::Policy::PRS::ProhibitConditionComplexity;
    }
);

done_testing();
