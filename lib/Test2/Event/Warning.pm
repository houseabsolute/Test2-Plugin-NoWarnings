package Test2::Event::Warning;

use strict;
use warnings;

our $VERSION = '0.10';

use parent 'Test2::Event';

use Test2::Util::HashBase qw( warning );

sub init {
    $_[0]->{ +WARNING } = 'undef' unless defined $_[0]->{ +WARNING };
}

sub facet_data {
    return {
        assert => {
            pass    => 0,
            details => $_[0]->{ +WARNING },
        },
    };
}

1;

# ABSTRACT: A Test2 event for warnings

__END__

=for Pod::Coverage init

=head1 DESCRIPTION

An event representing an unwanted warning. This is treated as a failure.

=head1 ACCESSORS

=over 4

=item $warning = $event->warning

Returns the warning that this event captured.

=back
