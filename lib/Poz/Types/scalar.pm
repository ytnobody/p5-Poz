package Poz::Types::scalar;
use 5.032;
use strict;
use warnings;
use parent 'Poz::Types';

sub coerce {
    my ($self, $value) = @_;
    return $value;
}

sub default {
    my ($self, $default) = @_;
    push @{$self->{transform}}, sub {
        my ($self, $value) = @_;
        return $value if defined $value;
        return ref($default) eq "CODE" ? $default->($self) : $default;
    };
    return $self;
}

sub nullable {
    my ($self) = @_;
    unshift @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        return bless [], "Poz::Result::ShortCircuit" unless defined $value;
        return;
    };
    return $self;
}

sub optional {
    my ($self) = @_;
    unshift @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        return bless [], "Poz::Result::ShortCircuit" unless defined $value;
        return;
    };
    return $self;
}
1;