use strict;
use warnings;

our $VERSION = '0.01';

use Test2::API qw( intercept );
use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings echo => 0;

my $events = intercept {
    ok(1);
    warn "Oh noes!";
    ok(2);
};

is(
    $events,
    array {
        event Ok => sub {
            call pass => T();
        };
        event Ok => sub {
            call pass => F();
            call name => 'no warnings';
        };
        event 'Diag';
        event Diag => sub {
            call message => match qr/^Oh noes!/;
        };
        event Ok => sub {
            call pass => T();
        };
    }
);

done_testing();
