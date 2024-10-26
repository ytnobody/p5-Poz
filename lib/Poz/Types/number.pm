package Poz::Types::number;
use 5.032;
use strict;
use warnings;
use parent 'Poz::Types::base';

our $RULE = sub {
    my ($value) = @_;
    return "Not a number" unless defined $value && $value =~ /^-?\d+\.?\d*$/;
    return;
};

1;