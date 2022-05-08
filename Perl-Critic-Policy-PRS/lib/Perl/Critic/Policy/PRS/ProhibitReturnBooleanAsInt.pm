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
    return 'PPI::Statement::Break';
}

sub supported_parameters
{
    return;
}

sub violates
{
    my ( $self, $elem, undef ) = @_;

    my $sib1 = $elem->schild();    # not next element - need first child
    if ( !$sib1 ) {
        return;
    }

    if ( 'return' ne $sib1->content() || is_hash_key( $sib1 ) ) {
        return;
    }

    my $return_line_content = $elem->content();
    if ( !$return_line_content ) {
        return;
    }

    # fast regex violation check - eg. "return 1"; - "return (1); # comment"
    if ( $return_line_content =~ /^\s*return\s*[(]?\s*[01]\s*[)]?\s*;\s*/io ) {
        return $self->violation( $DESC, $EXPL, $elem );
    }

    my $sib2 = $sib1->snext_sibling();
    if ( !$sib2 ) {
        return;
    }

    if ( $sib2->isa( 'PPI::Structure::List' ) ) {

        if ( $sib2->content() !~ m/^[(][01][)]$/aaixmso ) {
            return;
        }
    }
    elsif ( $sib2->isa( 'PPI::Token::Structure' ) && $SCOLON eq $sib2->content() ) {
        return;
    }

    elsif ( $sib2->isa( 'PPI::Token::Number' ) && '0' ne $sib2->content() && '1' ne $sib2->content() ) {
        return;
    }
    else {

        my $sib3 = $sib2->snext_sibling();
        if ( $sib3 && $sib3->isa( 'PPI::Token::Operator' ) ) {
            return;
        }
    }

    return $self->violation( $DESC, $EXPL, $elem );
}

1;

__END__

#-----------------------------------------------------------------------------
