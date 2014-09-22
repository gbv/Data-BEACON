# NAME

Data::BEACON - BEACON link dump format parser and serializer

# SYNOPSIS

    use Data::BEACON;

# DESCRIPTION

Data::BEACON provides a parser and serializer/writer for BEACON link dump
format and BEACON XML as specified at [http://gbv.github.io/beaconspec/beacon.html](http://gbv.github.io/beaconspec/beacon.html).

# MODULES

- [Data::BEACON::Parser](https://metacpan.org/pod/Data::BEACON::Parser)
- [Data::BEACON::Writer](https://metacpan.org/pod/Data::BEACON::Writer)

# FUNCTIONS

## beacon\_parser( ... )

Shortcut for `<Data::BEACON::Parser-`new>>.

## beacon\_writer( ... )

Shortcut for `<Data::BEACON::Writer-`new>>.

# AUTHOR

Jakob Voß <jakob.voss@gbv.de>

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

This module replaces [Data::Beacon](https://metacpan.org/pod/Data::Beacon)
