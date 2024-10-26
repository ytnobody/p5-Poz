package Poz::Builder;
use 5.032;
use strict;
use warnings;
use Poz::Types::string;

sub new {
    my ($class) = @_;
    bless {
        need_coerce => 0,
    }, $class;
}

sub coerce {
    my ($self) = @_;
    $self->{need_coerce} = 1;
    return $self;
}

sub string {
    my ($self, $opts) = @_;
    $opts = $opts || {};
    return Poz::Types::string->new({
        %{$opts},
        need_coerce => $self->{need_coerce},
    });
}

# sub number {
#     my ($self) = @_;
#     push @{$self->{rules}}, sub {
#         my ($value) = @_;
#         return "Not a number" unless defined $value && $value =~ /^-?\d+\.?\d*$/;
#         return;
#     };
#     return $self;
# }

# sub date {
#     my ($self) = @_;
#     push @{$self->{rules}}, sub {
#         my ($value) = @_;
#         return "Not a date" unless defined $value && $value =~ /^\d{4}-\d{2}-\d{2}$/;
#         return;
#     };
#     return $self;
# }

# sub object {
#     my ($self, $schema) = @_;
#     push @{$self->{rules}}, sub {
#         my ($value) = @_;
#         return "Not an object" unless defined $value && ref $value eq 'HASH';
#         for my $key (keys %$schema) {
#             my $err = $schema->{$key}->validate($value->{$key});
#             return "$key: $err" if defined $err;
#         }
#         return;
#     };
#     return $self;
# }

# sub array {
#     my ($self, $schema) = @_;
#     push @{$self->{rules}}, sub {
#         my ($value) = @_;
#         return "Not an array" unless defined $value && ref $value eq 'ARRAY';
#         for my $i (0..$#$value) {
#             my $err = $schema->validate($value->[$i]);
#             return "[$i]: $err" if defined $err;
#         }
#         return;
#     };
#     return $self;
# }

1;