package Data::BEACON;

use strict;
use warnings;

our $VERSION = '0.01';

use parent 'Exporter';
our @EXPORT_OK = qw(beacon_parser beacon_writer);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

use Data::BEACON::Parser;
use Data::BEACON::Writer;

sub beacon_parser {
    Data::BEACON::Parser->new(@_);    
}

sub beacon_writer {
    Data::BEACON::Writer->new(@_);    
}

1;
__END__

=encoding utf-8

=head1 NAME

Data::BEACON - BEACON link dump format parser and serializer

=head1 SYNOPSIS

    use Data::BEACON;

=head1 DESCRIPTION

Data::BEACON provides a parser and serializer/writer for BEACON link dump
format and BEACON XML as specified at L<http://gbv.github.io/beaconspec/beacon.html>.

=head1 MODULES

=over

=item L<Data::BEACON::Parser>

=item L<Data::BEACON::Writer>

=back

=head1 FUNCTIONS

=head2 beacon_parser( ... )

Shortcut for C<<Data::BEACON::Parser->new>>.

=head2 beacon_writer( ... )

Shortcut for C<<Data::BEACON::Writer->new>>.

=head1 AUTHOR

Jakob Voß E<lt>jakob.voss@gbv.deE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

This module replaces L<Data::Beacon>

=cut
