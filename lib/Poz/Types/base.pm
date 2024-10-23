package Poz::Types::base;
use 5.014;
use strict;
use warnings;
use Carp;

sub new {
    my ($class, %opts) = @_;
    my $rulecode = $class . "::rule";
    bless {
        %opts,
        rules => [\&$rulecode],
        transform => [],
        caller => [ caller() ],
    }, $class;
}

sub rule {
    Carp::croak("Not implemented");
}

sub parse {
    my ($self, $value) = @_;
    if (length($self->{transform}) > 0) {
        for my $transformer (@{$self->{transform}}) {
            $value = $transformer->($value);
        }
    }
    for my $rule (@{$self->{rules}}) {
        my $err = $rule->($value);
        if (defined $err && ref($err) eq "Poz::Result::ShortCircuit") {
            return;
        }
        return $err if defined $err;
    }
    if ($self->{need_coerce}) {
        $value = $self->coerce($value);
    }
    return $value;
}

sub coerce {
    my ($self, $value) = @_;
    return $value;
}

sub default {
    my ($self, $default) = @_;
    push @{$self->{transform}}, sub {
        my ($value) = @_;
        return $value if defined $value;
        return ref($default) eq "CODE" ? $default->() : $default;
    };
    return $self;
}

sub nullable {
    my ($self) = @_;
    unshift @{$self->{rules}}, sub {
        my ($value) = @_;
        return bless [], "Poz::Result::ShortCircuit" unless defined $value;
        return;
    };
    return $self;
}

sub optional {
    my ($self) = @_;
    unshift @{$self->{rules}}, sub {
        my ($value) = @_;
        return bless [], "Poz::Result::ShortCircuit" unless defined $value;
        return;
    };
    return $self;
}
1;