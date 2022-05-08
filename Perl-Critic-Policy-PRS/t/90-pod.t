#!perl

use utf8;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.01';

use Path::This qw( $THISDIR );
use Test::More;

local $@ = undef;
my $eval_ok = eval {
    use Test::Pod 1.00;
    return 'ok';
};

if ( $@ || 'ok' ne $eval_ok ) {
    plan 'skip_all' => 'Test::Pod 1.00 required for testing POD';
}

my @poddirs = ( $THISDIR . '/../lib' , $THISDIR . '/../t' );

all_pod_files_ok( all_pod_files( @poddirs ) );

######

done_testing();

__END__

#-----------------------------------------------------------------------------
