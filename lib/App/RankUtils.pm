package App::RankUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use utf8;
use warnings;

our %SPEC;
$SPEC{rank_change} = {
    v => 1.1,
    summary => 'Show range changes',
    args => {
        lines1 => {
            schema => 'filename*',
            req => 1,
            pos => 0,
        },
        lines2 => {
            schema => 'filename*',
            req => 1,
            pos => 1,
        },
    },
};
sub rank_change {
    my %args = @_;

    my %pos1;
    open my $fh1, "<", $args{lines1} or return [500, "Can't open lines1 file '$args{lines1}': $!"];
    my $i = 0;
    while (defined(my $line = <$fh1>)) {
        chomp $line;
        $i++;
        $pos1{$line} //= $i;
    }
    close $fh1;

    my %pos2;
    open my $fh2, "<", $args{lines2} or return [500, "Can't open lines2 file '$args{lines2}': $!"];
    $i = 0;
    while (defined(my $line = <$fh2>)) {
        chomp $line;
        $i++;
        $pos2{$line} //= $i;
        my $pos2 = $pos2{$line};
        my $pos1 = $pos1{$line};
        my $mark = "";
        if (!defined $pos1) {
            # new
        } else {
            if ($pos1 == $pos2) {
                $mark = " (0)";
            } elsif ($pos1 > $pos2) {
                $mark = " (⯅".($pos1-$pos2).")";
            } else {
                $mark = " (⯆".($pos2-$pos1).")";
            }
        }
        print "$line$mark\n";
    }
    [200];
}

1;
# ABSTRACT: CLI utilities related to ranks

=head1 SYNOPSIS


=head1 SEE ALSO

L<App::rank>

=cut
