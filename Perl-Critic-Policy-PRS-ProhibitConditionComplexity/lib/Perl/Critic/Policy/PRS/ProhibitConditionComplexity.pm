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

Readonly::Array my @BLOCK_SEARCH_KEYWORD => qw(if unless do while until for);

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
        {   name            => 'max_mccabe',
            description     => 'The maximum complexity score allowed.',
            default_string  => '2',
            behavior        => 'integer',
            integer_minimum => 1,
        },
    );
}

sub _keyword_in_searchlist
{
    my ($keyword) = @_;

    my $found = first { $_ eq $keyword } @BLOCK_SEARCH_KEYWORD;

    return $found;
}

sub _search_for_block_keyword
{
    my ($elem) = @_;

    my $word_search    = $elem->sprevious_sibling;
    my $content_search = q{};

    if ( ref $word_search ) {
        $content_search = $word_search->content;
    }

    my $i = 1;

    while ( !_keyword_in_searchlist($content_search) ) {
        if ( $i >= $MAX_KEYWORD_LOOKUP_DEPTH ) {
            last;    # recurse abort!
        }

        my $sprevious;

        if ( ref $word_search ) {
            $sprevious = $word_search->sprevious_sibling;

            if ( $sprevious && $sprevious != $word_search ) {
                $word_search    = $sprevious;
                $content_search = $word_search->content;
            }
            else {
                last;
            }
        }
        else {
            last;
        }

        $i++;
    }

    my ($block_keyword) = _keyword_in_searchlist($content_search);

    return $block_keyword;
}

sub violates
{
    my ( $self, $elem, $doc ) = @_;

    my $score = calculate_mccabe_of_main($elem);
    if ( $score <= $self->{_max_mccabe} ) {
        return;
    }

    my $block_keyword = _search_for_block_keyword($elem);
    if ( !$block_keyword ) {
        return;
    }

    my $desc = qq<"${block_keyword}" condition has a high complexity score ($score)>;
    return $self->violation( $desc, $EXPL, $elem );
}

1;
