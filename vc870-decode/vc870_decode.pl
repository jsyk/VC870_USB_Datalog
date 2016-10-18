#!/usr/bin/perl

use strict;
use warnings;
# use Switch;

my %fun_sel = (
    '00' => 'DCV',
    '01' => 'ACV',
    '10' => 'DCmV',
    '11' => 'TEMP',
    '20' => 'RES',
    '21' => 'CTN',
    '30' => 'CAP',
    '40' => 'DIO',
    '50' => 'FREQ',
    '51' => '(4~20)mA',
    '60' => 'DCuA',
    '61' => 'ACuA',
    '70' => 'DCmA',
    '71' => 'ACmA',
    '80' => 'DCA',
    '81' => 'ACA',
    '90' => 'Act+Apar_Power',
    '91' => 'PowFactor+Freq',
    '92' => 'VoltEff+CurrEff'
);

while (<STDIN>) {
    my @ivals = /^(\d{2})(\d)(\d{5})(\d{5})(\d{2})(.)(.)(.)(.)(.)(\d)/;
    if (not defined($ivals[0])) {
        next;
    }

    # print(join(' ', @ivals) . "\n");

    my $fun = $fun_sel{$ivals[0]};
    print($fun . "  ");

    my ($div, $unit, $unit2, $div2);

    if (($fun eq 'DCV') or ($fun eq 'ACV')) {
        $unit = 'V';
        if ($ivals[1] eq '0') {
            # 4V
            $div = 10000;
        } elsif ($ivals[1] eq '1') {
            # 40V
            $div = 1000;
        } elsif ($ivals[1] eq '2') {
            # 400V
            $div = 100;
        } elsif ($ivals[1] eq '3') {
            # 1000V
            $div = 10;
        }
    } elsif ($fun eq 'DCmV') {
        $unit = 'mV';
        $div = 100;
    } elsif ($fun eq 'RES') {
        if ($ivals[1] eq '0') {
            # 400 ohm
            $div = 100;
            $unit = 'Ohm';
        } elsif ($ivals[1] eq '1') {
            # 4 kOhm
            $div = 1000;
            $unit = 'kOhm';
        } elsif ($ivals[1] eq '2') {
            # 40 kOhm
            $div = 100;
            $unit = 'kOhm';
        } elsif ($ivals[1] eq '3') {
            # 400 kOhm
            $div = 10;
            $unit = 'kOhm';
        } elsif ($ivals[1] eq '4') {
            # 4 MOhm
            $div = 1000;
            $unit = 'MOhm';
        } elsif ($ivals[1] eq '5') {
            # 40 MOhm
            $div = 10000;
            $unit = 'MOhm';
        }
    } elsif ($fun eq 'CAP') {
        if ($ivals[1] eq '0') {
            # 40 nF
            $div = 1000;
            $unit = 'nF';
        } elsif ($ivals[1] eq '1') {
            # 400 nF
            $div = 100;
            $unit = 'nF';
        } elsif ($ivals[1] eq '2') {
            # 4000 nF
            $div = 10;
            $unit = 'nF';
        } elsif ($ivals[1] eq '3') {
            # 40 uF
            $div = 1000;
            $unit = 'uF';
        } elsif ($ivals[1] eq '4') {
            # 400 uF
            $div = 100;
            $unit = 'uF';
        } elsif ($ivals[1] eq '5') {
            # 4 mF
            $div = 10000;
            $unit = 'mF';
        } elsif ($ivals[1] eq '6') {
            # 40 mF
            $div = 1000;
            $unit = 'mF';
        }
    } elsif (($fun eq 'DCuA') or ($fun eq 'ACuA')) {
        if ($ivals[1] eq '0') {
            # 400 uA
            $div = 100;
            $unit = 'uA';
        } elsif ($ivals[1] eq '1') {
            # 4000 uA
            $div = 10;
            $unit = 'uA';
        }
    } elsif (($fun eq 'DCmA') or ($fun eq 'ACmA')) {
        if ($ivals[1] eq '0') {
            # 40 mA
            $div = 1000;
            $unit = 'mA';
        } elsif ($ivals[1] eq '1') {
            # 400 mA
            $div = 100;
            $unit = 'mA';
        }
    } elsif (($fun eq 'DCA') or ($fun eq 'ACA')) {
        $div = 1000;
        $unit = 'A';
    } elsif ($fun eq 'TEMP') {
        $div = 10;
        $unit = 'Celsius';
        $unit2 = 'Farenheit';
    } elsif ($fun eq 'CTN') {
        $div = 100;
        $unit = 'Ohm';
    } elsif ($fun eq 'DIO') {
        $div = 10000;
        $unit = 'V';
    } elsif ($fun eq 'FREQ') {
        $div = 1;
        $unit = 'Hz';
    } elsif ($fun eq '(4~20)mA') {
        $div = 1;
        $unit = '%';
    } elsif ($fun eq 'Act+Apar_Power') {
        $div = 10;
        $unit = 'W';
        $unit2 = 'VA';
    } elsif ($fun eq 'PowFactor+Freq') {
        $div = 1000;
        $unit = 'cos_fi';
        $div2 = 10;
        $unit2 = 'Hz';
    } elsif ($fun eq 'VoltEff+CurrEff') {
        $div = 10;
        $unit = 'V';
        $unit2 = 'A';
    }


    if (not defined($unit2)) {
        $unit2 = $unit;
    }
    if (not defined($div2)) {
        $div2 = $div;
    }

    my $status  = ord($ivals[5]);
    my $option1 = ord($ivals[6]);
    my $option2 = ord($ivals[7]);
    my $option3 = ord($ivals[8]);
    my $option4 = ord($ivals[9]);
    my $option5 = ord($ivals[10]);

    my $sign2_flag = ($status & 0x08);
    my $sign1_flag = ($status & 0x04);
    my $batt_flag = ($status & 0x02);
    my $ol1_flag = ($status & 0x01);

    my $max_flag = ($option1 & 0x08);
    my $min_flag = ($option1 & 0x04);
    my $maxmin_flag = ($option1 & 0x02);
    my $rel_flag = ($option1 & 0x01);

    my $ol2_flag = ($option2 & 0x08);
    my $open_flag = ($option2 & 0x04);
    my $manu_flag = ($option2 & 0x02);
    my $hold_flag = ($option2 & 0x01);

    my $light_flag = ($option3 & 0x08);
    my $usb_flag = ($option3 & 0x04);
    my $warn_flag = ($option3 & 0x02);
    my $auto_power_flag = ($option3 & 0x01);

    my $misplug_flag = ($option4 & 0x08);
    my $lo_flag = ($option4 & 0x04);
    my $hi_flag = ($option4 & 0x02);
    my $open2_flag = ($option4 & 0x01);

    my $dualdisp_flag = ($option5 & 0x01);

    my $v1 = $ivals[2] / $div;
    if ($sign1_flag > 0) {
        print("-");
    }
    if (($ol1_flag > 0) or ($open_flag > 0)) {
        $v1 = '-OL-';
    }
    print("$v1 $unit");

    if ($max_flag > 0) {
        print(" MAX");
    }
    if ($min_flag > 0) {
        print(" MIN");
    }
    if ($maxmin_flag > 0) {
        print(" MAXMIN");
    }
    if ($rel_flag > 0) {
        print(" REL");
    }

    if ($dualdisp_flag > 0) {
        my $v2 = $ivals[3] / $div2;
        if (($ol2_flag > 0) or ($open_flag > 0)) {
            $v2 = '-OL-';
        }
        if ($sign2_flag > 0) {
            print("-");
        }
        print("  $v2 $unit2");
    }

    if ($open_flag > 0) {
        print(" OPEN");
    }
    if ($manu_flag > 0) {
        print(" MANU");
    }
    if ($hold_flag > 0) {
        print(" HOLD");
    }

    if ($lo_flag > 0) {
        print(" LO");
    }
    if ($hi_flag > 0) {
        print(" HI");
    }
    if ($open2_flag > 0) {
        print(" OPEN2");
    }

    print("\n");
}
