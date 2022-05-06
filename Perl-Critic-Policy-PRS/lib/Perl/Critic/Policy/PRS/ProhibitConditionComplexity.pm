package Perl::Critic::Policy::PRS::ProhibitConditionComplexity;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use List::Util qw(first);

use Perl::Critic::Utils qw{ :severities :data_conversion :classification };
use Perl::Critic::Utils::McCabe qw{ calculate_mccabe_of_main };

use base 'Perl::Critic::Policy';

Readonly::Scalar my $EXPL => q{Consider refactoring};

# see lib\PPI\Lexer.pm
Readonly::Array my @BLOCK_SEARCH_KEYWORD => qw(IF ELSIF UNLESS WHILE UNTIL FOR FOREACH);

Readonly::Scalar my $MAX_KEYWORD_LOOKUP_DEPTH => 10;

sub default_severity
{
    return $SEVERITY_MEDIUM;
}

sub default_themes
{
    return qw(complexity maintenance);
}

sub applies_to
{
    return ( 'PPI::Structure::Condition', 'PPI::Structure::For' );
}

sub supported_parameters
{
    return (
        {   'name'            => 'max_mccabe',
            'description'     => 'The maximum complexity score allowed.',
            'default_string'  => '2',
            'behavior'        => 'integer',
            'integer_minimum' => 1,
        },
    );
}

sub _keyword_in_searchlist
{
    my ($keyword) = @_;

    $keyword = uc $keyword;

    my $found = first { $_ eq $keyword } @BLOCK_SEARCH_KEYWORD;

    return $found;
}

sub _search_for_block_keyword
{
    my ($elem) = @_;

    if ( !ref $elem ) {
        last;
    }

    my $word_search   = $elem;
    my $block_keyword = q{};

    my $i = 1;

    while ( !$block_keyword ) {
        if ( $i >= $MAX_KEYWORD_LOOKUP_DEPTH ) {
            last;    # recurse abort!
        }

        my $sprevious = $word_search->sprevious_sibling;

        if ( !$sprevious || $sprevious == $word_search ) {
            last;
        }

        if ( !is_hash_key($sprevious) ) {
            $word_search = $sprevious;

            my $content_search = $word_search->content;

            $block_keyword = _keyword_in_searchlist($content_search);
        }

        $i++;
    }

    return $block_keyword;
}

sub violates
{
    my ( $self, $elem, undef ) = @_;

    my $score = calculate_mccabe_of_main($elem);
    if ( $score <= $self->{'_max_mccabe'} ) {
        return;
    }

    my $block_keyword = _search_for_block_keyword($elem);
    if ( !$block_keyword ) {
        $block_keyword = 'no-keyword-found';
    }

    my $desc = qq<"${block_keyword}" condition has a high complexity score ($score)>;
    return $self->violation( $desc, $EXPL, $elem );
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::PRS::ProhibitConditionComplexity

=head1 AFFILIATION

This policy is part of L<Perl::Critic::Policy::PRS|Perl::Critic::Policy::PRS>.

=head1 DESCRIPTION

This Policy approximates the McCabe score within a coditional block "eg if(...)".

See L<http://en.wikipedia.org/wiki/Cyclomatic_complexity>

It should help to find complex conditions, which should be extracted
into subs, to be more testable.

eg. from

  if( $a && $b || $c > 20 ) { ... }

to

  if( _some_test ($a, $b, $c) ) { .. }

  sub _some_test {
    my ($a, $b, $c ) = @_;

    return  $a && $b || $c > 20;
  }

=head1 CONFIGURATION

The maximum acceptable McCabe can be set with the C<max_mccabe>
configuration item. Any block with a McCabe score higher than
this number will generate a policy violation. The default is 2.

An example section for a F<.perlcriticrc>:

  [PRS::ProhibitConditionComplexity]
  max_mccabe = 1

=head1 AUTHOR

mardem1 <>

=head1 COPYRIGHT

Copyright (c) 2022 All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. The full text of this license
can be found in the LICENSE file included with this module.

=cut
