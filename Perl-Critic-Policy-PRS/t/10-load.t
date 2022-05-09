#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Test::More;

plan 'tests' => 7;

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

    use_ok( 'Perl::Critic::Policy::PRS::ProhibitLargeBlock' )
        || print $error_txt;

    use_ok( 'Perl::Critic::Policy::PRS::ProhibitManyConditionsInSub' )
        || print $error_txt;

    use_ok( 'Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt' )
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

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitBlockComplexity $Perl::Critic::Policy::PRS::ProhibitLargeBlock::VERSION, Perl $], $^X"
);

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitBlockComplexity $Perl::Critic::Policy::PRS::ProhibitManyConditionsInSub::VERSION, Perl $], $^X"
);

diag(
    "\nTesting Perl::Critic::Policy::PRS::ProhibitBlockComplexity $Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt::VERSION, Perl $], $^X"
);

done_testing();

__END__

#-----------------------------------------------------------------------------

=pod

=encoding utf8

=head1 NAME

10-load.t

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
