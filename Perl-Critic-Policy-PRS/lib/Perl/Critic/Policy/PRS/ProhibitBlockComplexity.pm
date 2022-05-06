package Perl::Critic::Policy::PRS::ProhibitBlockComplexity;

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

Readonly::Array my @BLOCK_SEARCH_KEYWORD =>
    qw(SUB IF UNLESS WHILE UNTIL DO FOR FOREACH EVAL SORT MAP GREP BEGIN UNITCHECK CHECK INIT END PACKAGE);

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
    return 'PPI::Structure::Block';
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
    my ( $self, $elem, $doc ) = @_;

    my $score = calculate_mccabe_of_main($elem);
    if ( $score <= $self->{'_max_mccabe'} ) {
        return;
    }

    my $block_keyword = _search_for_block_keyword($elem);
    if ( !$block_keyword ) {
        $block_keyword = 'no-keyword-found';
    }

    if ( 'SUB' eq $block_keyword ) {
        return;    # no sub -> see SUB Perl::Critic::Policy::Subroutines::ProhibitExcessComplexity !
    }

    my $desc = qq<"${block_keyword}" code-block has a high complexity score ($score)>;
    return $self->violation( $desc, $EXPL, $elem );
}

1;

__END__
