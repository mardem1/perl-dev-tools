#!perl
use 5.010;
use strict;
use warnings;
use Test::More;

plan tests => 9;

BEGIN {
    use_ok( 'Mardem::RefactoringPerlCriticPolicies' )                     || print "Bail out!\n";
    use_ok( 'Mardem::RefactoringPerlCriticPolicies::Util' )               || print "Bail out!\n";
    use_ok( 'Perl::Critic::Policy::Mardem::ProhibitBlockComplexity' )     || print "Bail out!\n";
    use_ok( 'Perl::Critic::Policy::Mardem::ProhibitBlockComplexity' )     || print "Bail out!\n";
    use_ok( 'Perl::Critic::Policy::Mardem::ProhibitConditionComplexity' ) || print "Bail out!\n";
    use_ok( 'Perl::Critic::Policy::Mardem::ProhibitLargeBlock' )          || print "Bail out!\n";
    use_ok( 'Perl::Critic::Policy::Mardem::ProhibitLargeSub' )            || print "Bail out!\n";
    use_ok( 'Perl::Critic::Policy::Mardem::ProhibitManyConditionsInSub' ) || print "Bail out!\n";
    use_ok( 'Perl::Critic::Policy::Mardem::ProhibitReturnBooleanAsInt' )  || print "Bail out!\n";
}

diag( "Testing Mardem::RefactoringPerlCriticPolicies $Mardem::RefactoringPerlCriticPolicies::VERSION, Perl $], $^X" );
