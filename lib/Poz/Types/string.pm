package Poz::Types::string;
use 5.014;
use strict;
use warnings;
use utf8;
use parent 'Poz::Types::base';
use Carp ();
use Email::Address ();
use URI::URL ();
use Net::IPv6Addr ();
use Time::Piece ();
use DateTime::Format::Duration::ISO8601 ();

sub rule {
    my ($value) = @_;
    Carp::croak("Not a string") unless defined $value && !ref $value;
    return;
}

sub coerce {
    my ($self, $value) = @_;
    return "$value";
}

sub max {
    my ($self, $max) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Too long") if length($value) > $max;
        return;
    };
    return $self;
}

sub min {
    my ($self, $min) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Too short") if length($value) < $min;
        return;
    };
    return $self;
}

sub length {
    my ($self, $length) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not the right length") if length($value) != $length;
        return;
    };
    return $self;
}

sub email {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        my ($addr) = Email::Address->parse($value);
        Carp::croak("Not an email") unless defined $addr;
        return;
    };
    return $self;
}

sub url {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        my $url = URI::URL->new($value);
        Carp::croak("Not an URL") if !defined $url || !defined $url->scheme;
        return;
    };
    return $self;
}

sub emoji {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not an emoji") unless $value =~ /\p{Emoji}/;
        return;
    };
    return $self;
}

sub uuid {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not an UUID") unless $value =~ /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;
        return;
    };
    return $self;
}

sub nanoid {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not a nanoid") unless $value =~ /^[0-9a-zA-Z_-]{21}$/;
        return;
    };
    return $self;
}

sub cuid {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not a cuid") unless $value =~ /^c[a-z0-9]{24}$/;
        return;
    };
    return $self;
}

sub cuid2 {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not a cuid2") unless $value =~ /^[a-z0-9]{24,32}$/;
        return;
    };
    return $self;
}

sub ulid {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not an ulid") unless $value =~ /^[0-9A-HJKMNP-TV-Z]{26}$/;
        return;
    };
    return $self;
}

sub regex {
    my ($self, $regex) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not match regex") unless $value =~ $regex;
        return;
    };
    return $self;
}

sub includes {
    my ($self, $includes) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not includes $includes") unless index($value, $includes) != -1;
        return;
    };
    return $self;
}

sub startsWith {
    my ($self, $startWith) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not starts with $startWith") unless index($value, $startWith) == 0;
        return;
    };
    return $self;
}

sub endsWith {
    my ($self, $endsWith) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not ends with $endsWith") unless substr($value, -1 * length($endsWith)) eq $endsWith;
        return;
    };
    return $self;
}

# supports ipv4 / ipv6
sub ip {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        my @octets = split(/\./, $value);
        if (scalar(@octets) == 4) {
            foreach my $octet (@octets) {
                Carp::croak("Not an IP address") unless $octet =~ /^\d+$/ && $octet >= 0 && $octet <= 255;
            }
        } else {
            Carp::croak("Not an IP address") unless Net::IPv6Addr::is_ipv6($value);
        }
        return;
    };
    return $self;
}

sub trim {
    my ($self) = @_;
    push @{$self->{transform}}, sub { 
        my ($value) = @_;
        $value =~ s/^\s+|\s+$//g;
        return $value;
    };
    return $self;
}

sub toLowerCase {
    my ($self) = @_;
    push @{$self->{transform}}, sub { 
        my ($value) = @_;
        return lc($value);
    };
    return $self;
}

sub toUpperCase {
    my ($self) = @_;
    push @{$self->{transform}}, sub { 
        my ($value) = @_;
        return uc($value);
    };
    return $self;
}

sub date {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not a date format") unless $value =~ /^\d{4}-\d{2}-\d{2}$/;
        Carp::croak("Not a valid date") unless eval { Time::Piece->strptime($value, "%Y-%m-%d") };
        return;
    };
    return $self;
}

sub time {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not a time format") unless $value =~ /^\d{2}:\d{2}:\d{2}(\.[0-9]{1,6})?$/;
        Carp::croak("Not a valid time") unless eval { Time::Piece->strptime($value, "%H:%M:%S") };
        return;
    };
    return $self;
}

# iso8601 duration
sub duration {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        my $format = DateTime::Format::Duration::ISO8601->new;
        Carp::croak("Not a valid duration") unless eval { $format->parse_duration($value) };
        return;
    };
    return $self;
}

sub base64 {
    my ($self) = @_;
    push @{$self->{rules}}, sub {
        my ($value) = @_;
        Carp::croak("Not a base64") unless $value =~ /^[A-Za-z0-9+\/]+={0,2}$/;
        return;
    };
    return $self;
}
1;