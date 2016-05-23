package Test2::Event::Warning;

use strict;
use warnings;

our $VERSION = '0.02';

use parent 'Test2::Event';

use Test2::Util::HashBase qw( warning );

sub init {
    $_[0]->{ +WARNING } = 'undef' unless defined $_[0]->{ +WARNING };
}

sub summary { 'Unexpected warning: ' . $_[0]->{ +WARNING } }

sub causes_fail      {1}
sub increments_count {0}
sub diagnostics      {1}

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
