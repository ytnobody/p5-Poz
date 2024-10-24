requires 'perl', '5.014';
requires 'Email::Address', '1.912';
requires 'URI', '5.07';
requires 'Net::IPv6Addr', '1.02';
requires 'DateTime::Format::ISO8601', '0.16';
requires 'DateTime::Format::Duration::ISO8601', '0.008';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

