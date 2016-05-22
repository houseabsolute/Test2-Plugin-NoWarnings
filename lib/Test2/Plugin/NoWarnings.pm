package Test2::Plugin::NoWarnings;

use strict;
use warnings;

our $VERSION = '0.01';

use Test2::API qw( context_do );

my $LOADED = 0;

my $_orig_warn_handler = $SIG{__WARN__};
$SIG{__WARN__} = sub {
    context_do {
        my $ctx = shift;
        $ctx->ok( 0, 'no warnings' );
        $ctx->diag( $_[0] );
    } $_[0];

    return if $_orig_warn_handler && $_orig_warn_handler eq 'IGNORE';

    # The rest was copied from Test::Warnings

    # TODO: this doesn't handle blessed coderefs... does anyone care?
    goto &$_orig_warn_handler
        if $_orig_warn_handler
        and (
        ( ref $_orig_warn_handler eq 'CODE' )
        or (    $_orig_warn_handler ne 'DEFAULT'
            and $_orig_warn_handler ne 'IGNORE'
            and defined &$_orig_warn_handler )
        );

    if ( $_[0] =~ /\n$/ ) {
        warn $_[0];
    }
    else {
        require Carp;
        Carp::carp( $_[0] );
    }
};

1;
