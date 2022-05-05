package Perl::Critic::Policy::PRS::ProhibitBlockComplexity;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Readonly;

use Perl::Critic::Utils::McCabe qw{ calculate_mccabe_of_main };

use base 'Perl::Critic::Policy';

Readonly::Scalar my $EXPL => q{Consider refactoring};

sub applies_to
{
    return 'PPI::Structure::Block';
}

sub violates
{
    my ( $self, $elem, $doc ) = @_;

    my $score = calculate_mccabe_of_main($elem);
    if ( $score <= 2 ) {
        return;
    }

    my $desc = qq<Code-Block has a high complexity score ($score)>;
    return $self->violation( $desc, $EXPL, $elem );
}

1;

__END__
