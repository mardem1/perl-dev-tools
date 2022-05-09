#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Test2::V0;
use Test2::Tools::Exception qw/lives/;

plan 'tests' => 7;

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

ok( lives {
        require Perl::Critic::Policy::PRS::ProhibitManyConditionsInSub;
    }
);

ok( lives {
        require Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt;
    }
);

done_testing();

__END__

#-----------------------------------------------------------------------------

=pod

=encoding utf8

=head1 NAME

00-rquire.t

=head1 DESCRIPTION

Test-Script

=head1 AUTHOR

mardem1 <>

=head1 COPYRIGHT

Copyright (c) 2022 All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. The full text of this license
can be found in the LICENSE file included with this module.

=cut
