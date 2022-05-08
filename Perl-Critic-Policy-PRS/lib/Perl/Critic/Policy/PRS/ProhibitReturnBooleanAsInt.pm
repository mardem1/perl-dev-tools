package Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt;

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use Perl::Critic::Utils qw( is_hash_key );

use base 'Perl::Critic::Policy';

Readonly::Scalar my $SEMICOLON => q{;};

sub applies_to
{
    return 'PPI::Token::Word';
}

sub violates
{
    my ( $self, $elem, undef ) = @_;

    if ( 'return' ne $elem->content() || is_hash_key( $elem ) ) {
        return;
    }

    my $sib = $elem->snext_sibling();

    if ( !$sib ) {
        return;
    }

    if ( $sib->isa( 'PPI::Structure::List' ) && '0' ne $sib->content() && '1' ne $sib->content() ) {
        return;
    }
    elsif ( $sib->isa( 'PPI::Token::Structure' ) && $SEMICOLON eq $sib->content() ) {
        return;
    }

    elsif ( $sib->isa( 'PPI::Token::Number' ) && '0' ne $sib->content() && '1' ne $sib->content() ) {
        return;
    }
    else {
        my $sib2 = $sib->snext_sibling();

        if ( $sib2 && $sib2->isa( 'PPI::Token::Operator' ) ) {
            return;
        }
    }

    return $self->violation( 'return desc', 'return expl', $elem );
}

1;

__END__

#-----------------------------------------------------------------------------
