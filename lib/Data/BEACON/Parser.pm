package Data::BEACON::Parser;

use strict;
use warnings;

use Scalar::Util 'blessed';
use Carp 'croak';
use URI::Template;

our $VERSION = '0.10';

our $EMPTY_LINE = qr{^[ \t\n\r]*$};
our $DEFAULT_TEMPLATE = URI::Template->new('{+ID}');

sub new {
    my $class = shift;
    my $input = shift // \*STDIN;

    unless (defined eval { fileno $input }) {
        if ((ref $input and ref $input eq 'SCALAR') or -e $input) {
            open(my $fh, '<:encoding(UTF-8)', $input)
                or croak "cannot read from file $input";
            $input = $fh;
        } elsif (blessed $input) {
            unless ($input->can('getline')) {
                croak 'input must support method getline';
            }
        } else {
            croak 'cannot find input file or handle';
        }
    }
    
    bless { input => $input }, $class;
}

sub getline {
    my ($self) = @_;
    
    # TODO: handle all cases of newlines ("\n" or "\r\n" or "\r")
    my $line = $self->{input}->getline // return;
    $line =~ s/[ \t\n\r]+$//; # right-trim
    
    return $line;
}

sub next {
    my ($self) = @_;

    my $line;

    if (!$self->{meta}) {
        $line = $self->getline // return;
        $line =~ s/^\xEF\xBB\xBF//; # Unicode UTF-8 Byte Order Mark

        $self->{meta} = { };
        
        while (1) {
            if ($line =~ $EMPTY_LINE) {
                last;
            } elsif ($line =~ /^#([A-Z]+)(:|[ \t])[ \t]*(.*)$/) {
                my ($field, $value) = ($1, $3);

                $value =~ s/[ \t]+/ /; # normalize space
                $value =~ s/ +$//;

                # TODO: validate/compile meta fields
                $self->{meta}->{field} = $value;

            } else {
                if ($line =~ /^#/) {
                    # TODO: first link line MUST NOT begin with "#"
                }
                last;
            }

            $line = $self->getline // return;
        }
    } else {
        $line = $self->getline;
    }

    while (defined $line) {
        if ($line !~ $EMPTY_LINE) {
            my @link = map { s/[ \t]+/ /; s/^ | $//g; $_; } split /\|/, $line;
            
            # TODO: warn if (scalar @link > 3 )

            if (defined $link[1] and $link[1] =~ /^https?:/ and $self->meta->{TARGET} eq '{+ID}') {
                return [ $link[0], undef, $link[1] ]
            } else {
                return [ $link[0], $link[1], $link[2] ];
            }
        }
        $line = $self->getline // return;
    } 
    
}

# 3.1 Link construction
sub link {
    my ($self, $source, $annotation, $target) = @_;

    $target //= $source;

    my $source_template = $self->{PREFIX} // $DEFAULT_TEMPLATE;
    my $target_template = $self->{TARGET} // $DEFAULT_TEMPLATE;

    return (
        $source_template->process_to_string( ID => $source ),
        $target_template->process_to_string( ID => $target ),
        $annotation // $self->{meta}->{MESSAGE}
    );
}

sub next_link {
    my ($self) = @_;
    my $next = $self->next // return;
    $self->link( @$next );
}

1;
__END__

=encoding utf-8

=head1 NAME

Data::BEACON::Parser - BEACON text file format parser

=head1 SYNOPSIS

    use Data::BEACON::Parser;
    my $parser = Data::BEACON::Parser->new('beacon.txt');

    while( my $link = $parser->next_link ) {
        ...
    }

=head1 METHODS

=head2 new( [ $input ] )

Create a new parser to parse from an input handle (STDIN by default), file,
string reference, or any object with a getline method.

=head2 next

Read the next link line and return its tokens (source, annotation, and target)
as array reference.

=head2 link( $source, $annotation, $target )

Construct a link from its tokens and the current meta fields. Returns a list of
source identifier, target identifier, and annotation.

=head2 next_link

Read the next link line and construct a link.

=cut
