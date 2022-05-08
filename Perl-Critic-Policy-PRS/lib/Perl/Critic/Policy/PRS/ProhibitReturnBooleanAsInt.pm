package Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt;

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use Perl::Critic::Utils qw( is_hash_key $SEVERITY_MEDIUM $SCOLON $TRUE $FALSE );

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
    return 'PPI::Statement::Break';
}

sub supported_parameters
{
    return;
}

sub _simplified_violates_check
{
    my ( $elem ) = @_;

    my $return_line_content = $elem->content();
    if ( !$return_line_content ) {
        return $FALSE;
    }

    # fast regex violation check - eg. "return 1"; - "return (1); # comment" - "return 1 if ..."
    if ( $return_line_content =~ /^\s*return\s*[(]?\s*[01]\s*[)]?\s*((if|unless)\s*[(]?\s*.+\s*[)]?\s*)?\s*;\s*$/io ) {
        return $TRUE;
    }

    return $FALSE;
}

sub _detailed_violates_check
{
    my ( $elem ) = @_;

    if ( $elem->isa( 'PPI::Structure::List' ) ) {
        if ( $elem->content() !~ m/^[(][01][)]$/aaixmso ) {
            return $FALSE;
        }
    }
    elsif ( $elem->isa( 'PPI::Token::Structure' ) && $SCOLON eq $elem->content() ) {
        return $FALSE;
    }
    elsif ( $elem->isa( 'PPI::Token::Number' ) && '0' ne $elem->content() && '1' ne $elem->content() ) {
        return $FALSE;
    }
    else {
        my $sib = $elem->snext_sibling();

        if ( $sib && $sib->isa( 'PPI::Token::Operator' ) ) {
            return $FALSE;
        }
    }

    # also all additions return 0 if ... violates - no extra checks needed.

    return $TRUE;
}

sub violates
{
    my ( $self, $elem, undef ) = @_;

    my $return_keyword = $elem->schild();    # not next element - need first child
    if ( !$return_keyword ) {
        return;
    }

    if ( 'return' ne $return_keyword->content() || is_hash_key( $return_keyword ) ) {
        return;
    }

    if ( _simplified_violates_check( $elem ) ) {
        return $self->violation( $DESC, $EXPL, $elem );
    }

    my $child = $return_keyword->snext_sibling();
    if ( !$child ) {
        return;
    }

    if ( _detailed_violates_check( $child ) ) {
        return $self->violation( $DESC, $EXPL, $elem );
    }

    return;
}

1;

__END__

#-----------------------------------------------------------------------------
