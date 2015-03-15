#!/usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Text::Haml;
use FindBin;
use JSON 'from_json';

our $VERSION = 0.990101;

my $tests;

open FILE, "< $FindBin::Bin/tests.json" or die $!;
$tests = from_json(join("\n", <FILE>));
close FILE;

while (my ($section_name, $section) = each %$tests) {
    diag $section_name;

    while (my ($test_name, $test) = each %$section) {
        is( Text::Haml->new(%{$test->{config}}, vars_as_subs => 1)
              ->render($test->{haml}, %{$test->{locals}}),
            $test->{html}, $test_name
        );
    }
}
__END__

=head1 NAME

perl_haml_test.pl - Text::Haml spec tests runner

=head1 SYNOPSIS

    $ perl perl_haml_test.pl

    # conditional comments
    ok 1 - a conditional comment
    # tags with nested content
    ok 2 - a tag with CSS

    ...

    ok 81 - an inline comment
    ok 82 - a nested comment
    1..82

=head1 DESCRIPTION

This file is a part of Haml spec tests envorinment. It tests Perl
implementation using <Text::Haml>.

=head1 DEPENDENCIES

=over

    * Text::Haml (available via CPAN or http://github.com/vti/text-haml)
    * JSON (available on CPAN)
    * Test::More (included in Perl core)
    * FindBin (included in Perl core)

=back

=head1 SEE ALSO

L<Text::Haml>

=head1 AUTHOR

Viacheslav Tykhanovskyi, C<vti@cpan.org>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009, Viacheslav Tykhanovskyi

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
