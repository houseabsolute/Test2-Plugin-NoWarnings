package Test2::Event::Warning;

use strict;
use warnings;

our $VERSION = '0.06';

use parent 'Test2::Event';

use Test2::Util::HashBase qw( causes_fail warning );

sub init {
    $_[0]->{ +CAUSES_FAIL } = 1       unless exists $_[0]->{ +CAUSES_FAIL };
    $_[0]->{ +WARNING }     = 'undef' unless defined $_[0]->{ +WARNING };
}

sub summary { $_[0]->{ +WARNING } }

sub increments_count {1}
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
