package WWW::Opentracker::Stats::Mode::TCP4;

use strict;
use warnings;

use parent qw/
    WWW::Opentracker::Stats::Mode
    Class::Accessor::Fast
/;


__PACKAGE__->_format('txt');
__PACKAGE__->_mode('tcp4');

__PACKAGE__->mk_accessors(qw/_stats/);


=head1 NAME

WWW::Opentracker::Stats::Mode::TCP4

=head1 DESCRIPTION

Parses the tcp4 statistics from opentracker.

=head1 METHODS

=head2 parse_stats

 Args: $self, $payload

Decodes the plain text data retrieved from the tcp4 statistics of opentracker.

The payload looks like this (no indentation):
 119
 39
 33106 seconds (9 hours)
 opentracker tcp4 stats, 0 conns/s :: 0 success/s.

=cut

sub parse_stats {
    my ($self, $payload) = @_;

    my ($total, $announces, $seconds, $total_per_sec, $ann_per_sec)
        = $payload =~ m{\A
            (\d+) \s
            (\d+) \s
            (\d+) \s seconds \s \( \d+ \s hours \) \s
            opentracker \s tcp4 \s stats , \s
                (\d+) \s conns/s \s :: \s (\d+) \s success/s \.
        }xms
        or die "Unable to parse payload: $payload";

    my %stats = (
        'total'             => $total,
        'announces'         => $announces,
        'uptime'            => $seconds,
        'total_per_sec'     => $total_per_sec,
        'announces_per_sec' => $ann_per_sec,
    );

    return \%stats;
}


=head1 SEE ALSO

L<WWW::Opentracker::Stats::Mode>

=head1 AUTHOR

Knut-Olav Hoven, E<lt>knutolav@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Knut-Olav Hoven

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut

1;

