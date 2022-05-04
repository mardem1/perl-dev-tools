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

sub keyword_in_searchlist
{
    my ($keyword) = @_;

    my $found = first { $_ eq $keyword } @BLOCK_SEARCH_KEYWORD;

    return $found;
}

sub violates
{
    my ( $self, $elem, $doc ) = @_;

    my $score = calculate_mccabe_of_main($elem);
    if ( $score <= $self->{_max_mccabe} ) {
        return;
    }

    my $word_search    = $elem->sprevious_sibling;
    my $content_search = "";

    $content_search = $word_search->content if ref $word_search;
    for ( my $i = 1; ( $i < 10 ) && !keyword_in_searchlist($content_search); $i++ ) {
        my $tmp = $word_search->sprevious_sibling if ref $word_search;
        if ( $tmp && ref $word_search && $tmp != $word_search ) {
            $word_search    = $tmp;
            $content_search = $word_search->content;
        }
        else {
            last;
        }
    }

    my ($block_keyword) = keyword_in_searchlist($content_search);
    if ( !$block_keyword ) {
        return;
    }

    my $desc = qq<"${block_keyword}" condition has a high complexity score ($score)>;
    return $self->violation( $desc, $EXPL, $elem );
}

1;
