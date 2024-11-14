package Poz::Types::array;
use 5.032;
use strict;
use warnings;
use Carp ();
use Try::Tiny;

sub new {
    my ($class, $validator) = @_;
    if (!$validator->isa('Poz::Types::base')) {
        Carp::croak("Invalid validator: is not a subclass of Poz::Types");
    }
    my $self = bless { 
        __validator__ => $validator,
        __as__        => undef,
    }, $class;
    return $self;
}

sub as {
    my ($self, $typename) = @_;
    $self->{__as__} = $typename;
    return $self;
}

sub parse {
    my ($self, $data) = @_;
    my ($valid, $errors) = $self->safe_parse($data);
    if ($errors) {
        my $error_message = _errors_to_string($errors);
        Carp::croak($error_message);
    }
    return $valid;
}

sub safe_parse {
    my ($self, $data) = @_;
    my @errors = ();
    if (ref($data) ne 'ARRAY') {
        push @errors, {
            key   => undef,
            error => "Invalid data: is not arrayref"
        };
    } else {
        for my $i (0 .. $#{$data}) {
            my $v = $self->{__validator__};
            my $val = $data->[$i];
            try {
                $v->parse($val);
            } catch {
                my $error_message = $_;
                $error_message =~ s/ at .+ line [0-9]+\.\n//;
                push @errors, {
                    key   => $i,
                    error => $error_message,
                };
            }
        }
    }
    if (scalar(@errors) > 0) {
        return (undef, [@errors])
    }
    my $classname = $self->{__as__};
    my $valid = $classname ? bless [@$data], $classname : [@$data];
    return ($valid, undef);
}

sub _errors_to_string {
    my $errors = shift;
    my @error_strings = ();
    for my $error (@$errors) {
        push @error_strings, sprintf("%s on key `%s`", $error->{error}, $error->{key});
    }
    return join(", and ", @error_strings);
}

1;