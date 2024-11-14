[![Actions Status](https://github.com/ytnobody/p5-Poz/actions/workflows/test.yml/badge.svg)](https://github.com/ytnobody/p5-Poz/actions)
# NAME

Poz - A simple, composable, and extensible data validation library for Perl.

# SYNOPSIS

    use Poz qw/z/;
    use Data::UUID;
    use Time::Piece;
    my $bookSchema = z->object({
        id         => z->string->uuid->default(sub { Data::UUID->new->create_str }),   
        title      => z->string,
        author     => z->string->default("Anonymous"),
        published  => z->date,
        created_at => z->date->default(sub { Time::Piece::localtime()->strftime('%Y-%m-%d') }),
        updated_at => z->date->default(sub { Time::Piece::localtime()->strftime('%Y-%m-%d') }),
    })->as("My::Book");

    my $book = $bookSchema->parse({
        title     => "Spidering Hacks",
        author    => "Kevin Hemenway",
        published => "2003-10-01",
    }) or die "Invalid book data";
    $book->isa("My::Book"); # true

    my ($otherBook, $err) = $bookSchema->safe_parse({
        title => "Eric Sink on the Business of Software",
        author => "Eric Sink",
        published => "2006-0i-01",
    });
    $otherBook; # undef
    $err; # [{key => "", error => "Not a date"}]

# DESCRIPTION

Poz is a simple, composable, and extensible data validation library for Perl. It is inspired heavily from Zod [https://zod.dev/](https://zod.dev/) in TypeScript.

# HOW TO CONTRIBUTE

If you want to contribute to Poz, you can follow the steps below:

- 1. Prepare: Install cpanm and Minilla

        $ curl -L https://cpanmin.us | perl - --sudo App::cpanminus
        $ cpanm Minilla

- 2. Fork: Please fork the repository on GitHub.

    The Repository on GitHub: [https://github.com/ytnobody/p5-Poz](https://github.com/ytnobody/p5-Poz)

- 3. Clone: Clone the repository.

        $ git clone

- 4. Branch: Create a feature branch from the main branch.

        $ git checkout -b feature-branch main

- 5. Code: Write your code and tests, then build.

        $ minil build

- 6. Test: Run the tests.

        $ minil test

- 7. Commit: Commit your changes.

        $ git commit -am "Add some feature"

- 8. Push: Push to your branch.

        $ git push origin feature-branch

- 9. Pull Request: Create a new Pull Request on GitHub.

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>
