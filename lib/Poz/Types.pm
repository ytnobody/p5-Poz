package Poz::Types;
use strict;
use warnings;
use Carp;

sub new {
    my ($class, $opts) = @_;
    $opts = $opts || {};
    my $rulecode = $class . "::rule";
    my $self = bless {
        %{$opts},
        rules => [\&$rulecode],
        transform => [],
        caller => [ caller() ],
    }, $class;
    $self->{required_error} //= 'required';
    $self->{invalid_type_error} //= 'invalid type';
    return $self;
}

sub rule {
    Carp::croak("Not implemented");
}

sub parse {
    my ($self, $value) = @_;
    if (length($self->{transform}) > 0) {
        for my $transformer (@{$self->{transform}}) {
            $value = $transformer->($self, $value);
        }
    }
    for my $rule (@{$self->{rules}}) {
        my $err = $rule->($self, $value);
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

1;