package Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt;

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use base 'Perl::Critic::Policy';

sub applies_to
{
    return 'PPI::Token::Word';
}

sub violates
{
    my ( $self, $elem, undef ) = @_;

    if ( 'return' eq $elem->content() ) {
        return $self->violation( 'return desc', 'return expl', $elem );
    }

    return;
}

1;

__END__

#-----------------------------------------------------------------------------
