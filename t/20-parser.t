use strict;
use Test::More;

use Data::BEACON::Parser;

my $beacon = <<BEACON;
http://example.com/people/alice|http://example.com/documents/23.about
http://example.com/people/bob|http://example.com/documents/42.about
BEACON

my $parser = Data::BEACON::Parser->new(\$beacon);
is_deeply $parser->all_links, [
    ['http://example.com/people/alice','http://example.com/documents/23.about',undef],
    ['http://example.com/people/bob','http://example.com/documents/42.about',undef],
];

# ...

# templates

my @patterns = (
    'path/dir','{ID}','path%2Fdir', 
    'path/dir','{+ID}','path/dir',
    'Hello World!','{ID}','Hello%20World%21',
    'Hello World!','{+ID}','Hello%20World!',
    'Hello%20World','{ID}','Hello%2520World', #7
    'Hello%20World','{+ID}','Hello%20World',
    'M%C3%BCller','{ID}','M%25C3%25BCller', #9
    'M%C3%BCller','{+ID}','M%C3%BCller',
);

for (my $i=0; $i<@patterns; $i+=3) {
    my ($value, $template, $result) = @patterns[$i .. $i+2];

    $beacon = "#PREFIX: $template\n\n$value";
    my $link = Data::BEACON::Parser->new(\$beacon)->next_link;

    is $link->[0], $result;
}

done_testing;
