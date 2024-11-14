use strict;
use utf8;
use Test::More;
use Test::Exception;
use Poz qw/z/;

my $numbersSchema = z->array(z->number);
is_deeply(
    $numbersSchema->parse([1, 2, 3, 4, 5]),
    [1, 2, 3, 4, 5],
    "Array of numbers"
);

throws_ok(sub {
    $numbersSchema->parse([1, 2, 3, 4, "five"]);
}, qr/^Not a number on key `4`/, "Array of numbers with invalid data");

my $datesSchema = z->array(z->date)->as("My::Dates");
my $dates = $datesSchema->parse(["2020-01-01", "2020-01-02", "2020-01-03"]);
is_deeply(
    $dates,
    bless(["2020-01-01", "2020-01-02", "2020-01-03"], 'My::Dates'),
    "Array of dates"
);

my ($valid, $errors) = $datesSchema->safe_parse(["2020-01-01", "2020-01-02", "2020-01-03"]);
is_deeply(
    $valid,
    bless(["2020-01-01", "2020-01-02", "2020-01-03"], 'My::Dates'),
    "Array of dates"
);
is($errors, undef, "No errors");

($valid, $errors) = $datesSchema->safe_parse(["2020-01-01", "2020-01-02", "2020-01-0i"]);
is($valid, undef, "Invalid data");
is_deeply(
    $errors,
    [{key => 2, error => "Not a date"}],
    "Invalid data"
);


done_testing;