
# NAME

Poz - It's new $module

# SYNOPSIS

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

# DESCRIPTION

Poz is a simple, composable, and extensible data validation library for Perl. It is inspired heavily from Zod [https://zod.dev/](https://zod.dev/) in TypeScript.

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>
