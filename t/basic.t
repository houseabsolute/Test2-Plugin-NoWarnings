use strict;
use warnings;

our $VERSION = '0.01';

use Test2::API qw( intercept );
use Test2::Bundle::Extended;
use Test2::Plugin::NoWarnings;

my $events = intercept {
    ok(1);
    warn 'Oh noes!';
    ok(2);
};

is(
    $events,
    array {
        event Ok => sub {
            call pass => T();
        };
        event Warning => sub {
            call warning => match qr/^Unexpected warning: Oh noes!/;
        };
        event Ok => sub {
            call pass => T();
        };
        end();
    }
);

done_testing();
