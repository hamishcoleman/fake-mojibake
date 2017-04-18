#!/usr/bin/env perl
use warnings;
use strict;
#
# A very simple hack to convert an program's stdout from latin-1 to
# cyrillic, using a phonetic mapping.
#
# TODO
# - read buffers of more than 1 char at a time
# - look at the whole group of chars and use the multi-char conversions
# - have support for canned conversion of entire words
# - support ANSI escape codes better (set terminal name, for instance)
# - double-check the phonetic translations I am using
#

sub conv2cyrillic($) {
    my $from = shift;

    my %map = (
        a => 'а',
        b => 'б',
        v => 'в',
        g => 'г',
        d => 'д',
        e => 'е',
        j => 'ж',
        z => 'з',
        i => 'и',
        y => 'й',
        k => 'к',
        l => 'л',
        m => 'м',
        n => 'н',
        o => 'о',
        p => 'п',
        r => 'р',
        s => 'с',
        t => 'т',
        u => 'у',
        f => 'ф',
        h => 'х',
        c => 'ц',
        #ch => 'ч',
        #sh => 'ш',
        #sht => 'щ',
        w => 'ъ',
        x => 'ь',
        #yu
        #ya
        #wy
        #ee
        #yo
        
        A => 'А',
        B => 'Б',
        V => 'В',
        G => 'Г',
        D => 'Д',
        E => 'Е',
        J => 'Ж',
        Z => 'З',
        I => 'И',
        Y => 'Й',
        K => 'К',
        L => 'Л',
        M => 'М',
        N => 'Н',
        O => 'О',
        P => 'П',
        R => 'Р',
        S => 'С',
        T => 'Т',
        U => 'У',
        F => 'Ф',
        H => 'Х',
        C => 'Ц',
        #W => '',
        #X => 'ь',

#        # FIXME, not cyrillic at all ...
#        0 => '٠',
#        1 => '١',
#        2 => '٢',
#        3 => '٣',
#        4 => '٤',
#        5 => '٥',
#        6 => '٦',
#        7 => '٧',
#        8 => '٨',
#        9 => '٩',
    );

    my $cyrillic = $map{$from};
    if (!defined($cyrillic)) {
        return $from;
    }
    return $cyrillic;
}

$| = 1;
my $buf;
while (sysread(STDIN,$buf,1,0)) {
    if ($buf eq "\e") {
        # this is the start of an escape sequence
        print($buf);

        # FIXME - assume always at least one char after escape
        sysread(STDIN,$buf,1,0);
        print($buf);

        if ($buf eq ']') {
            # its a xterm title sequence, ending with a bel char

            while (sysread(STDIN,$buf,1,0)) {
                print($buf);
                last if ($buf eq "\007");
            }
        } else {
            # FIXME - assume sequence ends with first alpha char
            while (sysread(STDIN,$buf,1,0)) {
                print($buf);
                last if ($buf =~ m/[a-zA-Z]/);
            }
        }
    } else {
        print(conv2cyrillic($buf));
    }
}

