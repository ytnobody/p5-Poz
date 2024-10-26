package Poz::Builder;
use 5.032;
use strict;
use warnings;
use Poz::Types::string;
use Poz::Types::number;

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

sub number {
    my ($self, $opts) = @_;
    $opts = $opts || {};
    return Poz::Types::number->new({
        %{$opts},
        need_coerce => $self->{need_coerce},
    });
}

1;