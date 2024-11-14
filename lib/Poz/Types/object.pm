package Poz::Types::object;
use 5.032;
use strict;
use warnings;
use Carp ();
use Try::Tiny;

sub new {
    my ($class, $struct) = @_;
    my $self = bless { 
        __struct__ => {},
        __as__     => undef,
    }, $class;
    for my $key (keys %$struct) {
        my $v = $struct->{$key};
        if ($v->isa('Poz::Types::base')) {
            $self->{__struct__}{$key} = $v;
        }
    }
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
    if (ref($data) ne 'HASH') {
        push @errors, {
            key   => undef,
            error => "Invalid data: is not hashref"
        };
    } else {
        for my $key (sort keys %{$self->{__struct__}}) {
            my $v = $self->{__struct__}{$key};
            my $val = $data->{$key};
            try {
                $v->parse($val);
            } catch {
                my $error_message = $_;
                $error_message =~ s/ at .+ line [0-9]+\.\n//;
                push @errors, {
                    key   => $key,
                    error => $error_message,
                };
            }
        }
    }
    if (scalar(@errors) > 0) {
        return (undef, [@errors])
    }
    my $classname = $self->{__as__};
    my $valid = bless {%$data}, $classname;
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