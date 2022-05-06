#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Test2::V0;
use Test2::Tools::Exception qw/lives/;

plan 'tests' => 5;

ok( lives {
        require RPS::Util;
    }
);

ok( lives {
        require Perl::Critic::Policy::PRS::ProhibitConditionComplexity;
    }
);

ok( lives {
        require Perl::Critic::Policy::PRS::ProhibitBlockComplexity;
    }
);

ok( lives {
        require Perl::Critic::Policy::PRS::ProhibitLargeSub;
    }
);

ok( lives {
        require Perl::Critic::Policy::PRS::ProhibitLargeBlock;
    }
);

done_testing();
