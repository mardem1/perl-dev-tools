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

sub supported_parameters
{
    return (
        {   'name'            => 'statement_count_limit',
            'description'     => 'The maximum statement count allowed.',
            'default_string'  => '10',
            'behavior'        => 'integer',
            'integer_minimum' => 1,
        },
    );
}

sub violates
{
    my ( $self, $elem, undef ) = @_;

    my $s = $elem->find( 'PPI::Statement' );

    if ( !$s ) {
        return;
    }

    my $statement_count = @{ $s };
    if ( $statement_count <= $self->{ '_statement_count_limit' } ) {
        return;
    }

    my $desc;
    if ( my $name = $elem->name() ) {
        $desc = qq<Subroutine "$name" with high statement count ($statement_count)>;
    }
    else {
        # never the case becaus no PPI::Statement::Sub
        $desc = qq<Anonymous subroutine with high statement count ($statement_count)>;
    }

    return $self->violation( $desc, $EXPL, $elem );
}

1;

__END__

#-----------------------------------------------------------------------------
