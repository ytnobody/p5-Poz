package Poz::Types::number;
use 5.032;
use strict;
use warnings;
use parent 'Poz::Types::scalar';
use Carp ();

sub new {
    my ($class, $opts) = @_;
    $opts = $opts || {};
    $opts->{required_error} //= "required";
    $opts->{invalid_type_error} //= "Not a number";
    my $self = $class->SUPER::new($opts);
    return $self;
}

sub rule {
    my ($self, $value) = @_;
    return Carp::croak($self->{required_error}) unless defined $value;
    return Carp::croak($self->{invalid_type_error}) unless $value =~ /^-?\d+\.?\d*$/;
    return;
};

sub coerce {
    my ($self, $value) = @_;
    return $value +0;
}

sub gt {
    my ($self, $min, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Too small";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value <= $min;
        return;
    };
    return $self;
}

sub gte {
    my ($self, $min, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Too small";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value < $min;
        return;
    };
    return $self;
}

sub lt {
    my ($self, $max, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Too large";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value >= $max;
        return;
    };
    return $self;
}

sub lte {
    my ($self, $max, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Too large";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value > $max;
        return;
    };
    return $self;
}

# value must be an integer
sub int {
    my ($self, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Not an integer";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value !~ /^-?\d+$/;
        return;
    };
    return $self;
}

sub positive {
    my ($self, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Not a positive number";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value <= 0;
        return;
    };
    return $self;
}

sub negative {
    my ($self, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Not a negative number";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value >= 0;
        return;
    };
    return $self;
}

sub nonpositive {
    my ($self, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Not a non-positive number";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value > 0;
        return;
    };
    return $self;
}

sub nonnegative {
    my ($self, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Not a non-negative number";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value < 0;
        return;
    };
    return $self;
}

# Evenly divisible by 5.
sub multipleOf {
    my ($self, $divisor, $opts) = @_;
    $opts = $opts || {};
    $opts->{message} //= "Not a multiple of $divisor";
    push @{$self->{rules}}, sub {
        my ($self, $value) = @_;
        Carp::croak($opts->{message}) if $value % $divisor != 0;
        return;
    };
    return $self;
}

# synonym for multipleOf
sub step {
    my ($self, $divisor, $opts) = @_;
    return $self->multipleOf($divisor, $opts);
}

1;