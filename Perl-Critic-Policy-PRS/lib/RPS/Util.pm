package RPS::Util;

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use List::Util qw( first );

use Perl::Critic::Utils qw{ is_hash_key };

use base 'Exporter';

our @EXPORT_OK = qw( search_for_block_keyword );

Readonly::Array my @BLOCK_SEARCH_KEYWORD => qw(
    SUB
    IF ELSIF UNLESS
    WHILE UNTIL
    DO
    FOR FOREACH
    EVAL
    SORT MAP GREP
    BEGIN UNITCHECK CHECK INIT END
    PACKAGE );

Readonly::Scalar my $MAX_KEYWORD_LOOKUP_DEPTH => 10;

sub _keyword_in_searchlist
{
    my ( $keyword ) = @_;

    $keyword = uc $keyword;

    my $found = first { $_ eq $keyword } @BLOCK_SEARCH_KEYWORD;

    return $found;
}

sub search_for_block_keyword
{
    my ( $elem ) = @_;

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

        if ( !is_hash_key( $sprevious ) ) {
            $word_search = $sprevious;

            my $content_search = $word_search->content;

            $block_keyword = _keyword_in_searchlist( $content_search );
        }

        $i++;
    }

    return $block_keyword;
}

1;

__END__

#-----------------------------------------------------------------------------
