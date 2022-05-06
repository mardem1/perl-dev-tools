package Perl::Critic::Policy::PRS::ProhibitLargeSub;

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Perl::Critic::Utils qw{ :severities :data_conversion :classification };

use parent 'Perl::Critic::Policy';

Readonly::Scalar my $EXPL => q{Consider refactoring};

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
    return 'PPI::Statement::Sub';
}

sub violates
{
    my ( $self, $elem, undef ) = @_;

    my $s = $elem->find( 'PPI::Statement' );

    if ( !$s ) {
        return;
    }

    my $statement_count = @{ $s };

    if ( 10 > $statement_count ) {
        return;
    }

    my $desc = qq<Subroutine with high statement count ($statement_count)>;

    return $self->violation( $desc, $EXPL, $elem );
}

1;

__END__
