use strict;
use warnings;

use Test2::API qw( intercept );
use Test2::V0;
use Test2::Plugin::NoWarnings;

{
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
                call facets => hash {
                    field assert => object {
                        call pass => F();
                        call details => match
                            qr/^Unexpected warning: Oh noes!/,;
                    }
                };
                call warning => match qr/^Unexpected warning: Oh noes!/;
            };
            event Ok => sub {
                call pass => T();
            };
            end();
        }
    );
}

{
    my $events = intercept {
        ok(1);
        subtest 'subt' => sub {
            warn 'Oh noes!';
            ok(2);
        };
    };

    is(
        $events,
        array {
            event Ok => sub {
                call pass => T();
            };
            event Subtest => sub {
                call pass      => F();
                call subevents => array {
                    event Warning => sub {
                        call facets => hash {
                            field assert => object {
                                call pass => F();
                                call details => match
                                    qr/^Unexpected warning: Oh noes!/,;
                            }
                        }
                    };
                    event Ok => sub {
                        call pass => T();
                    };
                    event Plan => sub {
                        call max => 2;
                    };
                    end();
                };
            };
            event Diag => sub {
                call message => match qr{^\n?Failed test};
            };
            end();
        }
    );
}

done_testing();
