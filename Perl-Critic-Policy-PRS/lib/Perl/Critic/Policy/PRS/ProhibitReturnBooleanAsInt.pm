package Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt;

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use Perl::Critic::Utils qw( is_hash_key $SEVERITY_MEDIUM $SCOLON );

use base 'Perl::Critic::Policy';

## no critic (RequireInterpolationOfMetachars)
Readonly::Scalar my $EXPL => q{Consider using some $false, $true or other available module implementation};

Readonly::Scalar my $DESC => q{"return" statement with explicit "0/1"};

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
    return 'PPI::Token::Word';
}

sub supported_parameters
{
    return;
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

    if ( $sib->isa( 'PPI::Structure::List' ) ) {
        if ( $sib->content() !~ m/^[(][01][)]$/aaixmso ) {
            return;
        }
    }
    elsif ( $sib->isa( 'PPI::Token::Structure' ) && $SCOLON eq $sib->content() ) {
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

    return $self->violation( $DESC, $EXPL, $elem );
}

1;

__END__

#-----------------------------------------------------------------------------
