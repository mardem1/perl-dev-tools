package Perl::Critic::Policy::PRS::ProhibitConditionComplexity;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;

use Perl::Critic::Utils qw{ :severities :data_conversion :classification };
use Perl::Critic::Utils::McCabe qw{ calculate_mccabe_of_main };

use base 'Perl::Critic::Policy';

Readonly::Scalar my $EXPL => q{Consider refactoring};

sub default_severity {
    return $SEVERITY_MEDIUM;
}

sub default_themes {
    return qw(complexity maintenance);
}

sub applies_to {
    return ( 'PPI::Structure::Condition', 'PPI::Structure::For' );
}

sub supported_parameters {
    return (
        {   name            => 'max_mccabe',
            description     => 'The maximum complexity score allowed.',
            default_string  => '2',
            behavior        => 'integer',
            integer_minimum => 1,
        },
    );
}

sub violates {
    my ( $self, $elem, $doc ) = @_;

    my $score = calculate_mccabe_of_main($elem);
    if ( $score <= $self->{_max_mccabe} ) {
        return;
    }

    my $desc = qq<Condition-Block has a high complexity score ($score)>;
    return $self->violation( $desc, $EXPL, $elem );
}

1;
