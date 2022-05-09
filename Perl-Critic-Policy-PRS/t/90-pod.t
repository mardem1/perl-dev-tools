#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Cwd qw( abs_path );
use Path::This qw( $THISDIR );
use Test::More;
use English qw( -no_match_vars );

local $EVAL_ERROR = undef;
my $eval_ok = eval {
    use Test::Pod 1.00;
    return 'ok';
};

if ( $EVAL_ERROR || 'ok' ne $eval_ok ) {
    plan 'skip_all' => 'Test::Pod 1.00 required for testing POD';
}

my @poddirs = ( abs_path( $THISDIR ) . '/../' );

all_pod_files_ok( all_pod_files( @poddirs ) );

######

done_testing();

__END__

#-----------------------------------------------------------------------------
