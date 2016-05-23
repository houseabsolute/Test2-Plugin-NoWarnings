package Test2::Plugin::NoWarnings;

use strict;
use warnings;

our $VERSION = '0.01';

use Test2::API qw( context_do );

my $echo = 0;

sub import {
    shift;
    my %args = @_;
    $echo = $args{echo} if exists $args{echo};
    return;
}

my $_orig_warn_handler = $SIG{__WARN__};
## no critic (Variables::RequireLocalizedPunctuationVars)
$SIG{__WARN__} = sub {
    context_do {
        my $ctx = shift;
        $ctx->send_event( 'Warning', warning => $_[0] );
    }
    $_[0];

    return unless $echo;

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

# ABSTRACT: Fail if tests warn

__END__

=head1 SYNOPSIS

    use Test2::Bundle::Extended;
    use Test2::Plugin::NoWarnings;

    ...;

=head1 DESCRIPTION

Loading this plugin causes your tests to fail if there any warnings while they
run. Each warning generates a new failing test and the warning content is
outputted via C<diag>.

This module uses C<$SIG{__WARN__}>, so if the code you're testing sets this,
then this module will stop working.

=head1 ECHOING WARNINGS

By default, this module suppresses the warning itself so it does not go to
C<STDERR>. If you'd like to also have the warning go to C<STDERR> untouched,
you can ask for this with the C<echo> import argument:

    use Test2::Plugin::NoWarnings echo => 1;
