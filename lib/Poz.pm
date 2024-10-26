package Poz;
use 5.014;
use strict;
use warnings;
use Poz::Builder;
use Exporter 'import';

our $VERSION = "0.01";

our @EXPORT_OK = qw/z/;
our %EXPORT_TAGS = (all => \@EXPORT_OK);

sub z {
    return Poz::Builder->new;
}

1;
__END__

=encoding utf-8

=head1 NAME

Poz - A simple, composable, and extensible data validation library for Perl.

=head1 SYNOPSIS

    use Poz qw/z/;
    use Data::UUID;
    use Time::Piece;
    my $bookSchema = z->object({
        id         => z->string->default(sub { Data::UUID->new->create_str }),   
        title      => z->string,
        author     => z->string->default("Anonymous"),
        published  => z->date,
        created_at => z->date->default(sub { Time::Piece::localtime() }),
        updated_at => z->date->default(sub { Time::Piece::localtime() }),
    });

    my $book = $bookSchema->parse({
        title     => "Spidering Hacks",
        author    => "Kevin Hemenway",
        published => "2003-10-01",
    }) or die "Invalid book data";
    $book->isa("Book"); # true

    my ($otherBook, $err) = $bookSchema->safe_parse({
        title => "Eric Sink on the Business of Software",
        author => "Eric Sink",
        published => "2006-0i-01",
        created_at => "2024-10-10 01:23:45+09:00",
        updated_at => "2024-10-10 01:23:45+09:00",
    });
    $otherBook; # undef
    $err; # "Invalid date format: 2006-0i-01"

=head1 DESCRIPTION

Poz is a simple, composable, and extensible data validation library for Perl. It is inspired heavily from Zod L<https://zod.dev/> in TypeScript.

=head1 HOW TO CONTRIBUTE

If you want to contribute to Poz, you can follow the steps below:

=over 4

=item 1. Prepare: Install cpanm and Minilla

    $ curl -L https://cpanmin.us | perl - --sudo App::cpanminus
    $ cpanm Minilla

=item 2. Fork: Please fork the repository on GitHub.

The Repository on GitHub: L<https://github.com/ytnobody/p5-Poz>

=item 3. Clone: Clone the repository.

    $ git clone

=item 4. Branch: Create a feature branch from the main branch.

    $ git checkout -b feature-branch main

=item 5. Code: Write your code and tests, then build.

    $ minil build

=item 6. Test: Run the tests.

    $ minil test

=item 7. Commit: Commit your changes.

    $ git commit -am "Add some feature"

=item 8. Push: Push to your branch.
    
    $ git push origin feature-branch

=item 9. Pull Request: Create a new Pull Request on GitHub.

=back

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

