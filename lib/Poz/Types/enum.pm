package Poz::Types::enum;
use strict;
use warnings;
use parent 'Poz::Types::scalar';

sub new {
    my ($class, $enum) = @_;
    $enum = $enum || [];
    my $opts = {};
    $opts->{required_error} //= "required";
    $opts->{invalid_type_error} //= "Invalid data of enum";
    my $self = $class->SUPER::new($opts);
    $self->{__enum__} = $enum;
    return $self;
}

sub rule {
    my ($self, $value) = @_;
    Carp::croak($self->{required_error}) unless defined $value;
    Carp::croak($self->{invalid_type_error}) unless grep { $_ eq $value } @{$self->{__enum__}};
    return;
}

sub as {
    my ($self, $typename) = @_;
    $self->{__as__} = $typename;
    return $self;
}

sub exclude {
    my ($self, $opts) = @_;
    $opts = $opts || [];
    my $enum = [];
    for my $e (@{$self->{__enum__}}) {
        my $found = 0;
        for my $o (@{$opts}) {
            if ($e eq $o) {
                $found = 1;
                last;
            }
        }
        push @{$enum}, $e unless $found;
    }
    return __PACKAGE__->new($enum);
}

sub extract {
    my ($self, $opts) = @_;
    $opts = $opts || [];
    my $enum = [];
    for my $e (@{$self->{__enum__}}) {
        for my $o (@{$opts}) {
            if ($e eq $o) {
                push @{$enum}, $e;
                last;
            }
        }
    }
    return __PACKAGE__->new($enum);
}

1;