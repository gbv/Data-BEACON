use strict;
use Test::More;

use Data::BEACON::Parser;
use IO::File;

my $beacon = do { local (@ARGV, $/) = "t/input.txt"; <> };
my $link   = [qw(source target annotation)];

{   
    open my $stdin, '<', \$beacon;
    local *STDIN = $stdin;
    is_deeply(Data::BEACON::Parser->new->next_link, $link, 'STDIN (default)');
}

my @input = (
    'string referene' => \$beacon,
    'object with getline method' => IO::File->new('t/input.txt','r'),
    'file' => 't/input.txt',
    'handle' => do { open my $fh, '<', 't/input.txt'; $fh },
);

for(my $i=0; $i<@input; $i+=2) {
    is_deeply(Data::BEACON::Parser->new($input[$i+1])->next_link, $link, $input[$i]);
}

foreach ( (bless {}, 'DoesNotExist'), [], '' ) {
    eval { Data::BEACON::Parser->new($_) };
    ok $@, 'invalid input';
}

done_testing;
