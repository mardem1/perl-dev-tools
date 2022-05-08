package Perl::Critic::Policy::PRS::ProhibitReturnBooleanAsInt;

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;
use Perl::Critic::Utils qw( is_hash_key $SEVERITY_MEDIUM );

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

    my $return_keyword = $elem->schild();    # not next element - need first child
    if ( !$return_keyword ) {
        return;
    }

    if ( 'return' ne $return_keyword->content() || is_hash_key( $return_keyword ) ) {
        return;
    }

    my $return_line_content = $elem->content();
    if ( !$return_line_content ) {
        return;
    }

    # fast regex violation check - eg. "return 1"; - "return (1); # comment" - "return 1 if ..."
    if ( $return_line_content !~ m/^\s*return\s*[(]?\s*[01]\s*[)]?\s*((if|unless)\s*[(]?\s*.+\s*[)]?\s*)?\s*;/aaixmso )
    {
        return;
    }

    return $self->violation( $DESC, $EXPL, $elem );
}

1;

__END__

#-----------------------------------------------------------------------------
