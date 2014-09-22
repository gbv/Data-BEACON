use strict;
use Test::More;

use Data::BEACON::Parser;

my $beacon = "source|annotation|target";

my %input = (

    'string referene' =>
        [ Data::BEACON::Parser->new(\$beacon)->next_link ],

    'STDIN (default)' => do {   
        open my $stdin, '<', \$beacon;
        local *STDIN = $stdin;
        [ Data::BEACON::Parser->new->next_link ];
    },

    # input from object with 'getline' method (e.g. IO::Handle)
    # ...

    # input from handle
    # ...

    # input from file
    # ...
);

while (my ($msg, $first) = each %input) {
    is_deeply $first, [qw(source target annotation)], $msg;
}

done_testing;
