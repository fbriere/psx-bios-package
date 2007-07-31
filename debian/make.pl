#!/usr/bin/perl -w

use 5.006;
use strict;

use constant FILES => '*.bin';
use constant FILES_EXCL => qw(scph5000a.bin);

warn "Deleting old debian/*.install files\n";
system 'rm -rf debian/psx-bios-*.install' and die "rm failed: $?";

warn "Reading debian/control.in\n";
local $/ = '';
open TMP, 'debian/control.in' or die "Cannot open debian/control.in: $!";
my $header = <TMP>;
my $body = <TMP>;
close TMP;

warn "Creating debian/control\n";
open CONTROL, '>debian/control' or die "Cannot write to debian/control: $!";
print CONTROL $header;

foreach my $file (glob FILES) {
	next if grep $_ eq $file, FILES_EXCL;

	my ($rom, $ROM) = (lc $file, uc $file);
	$rom =~ s/\.\w+$//;  $ROM =~ s/\.\w+$//;

	local $_ = $body;
	s/\%rom%/$rom/g;  s/\%ROM%/$ROM/g;
	warn "Adding $rom to control\n";
	print CONTROL $_, "\n";

	warn "Creating debian/psx-bios-$rom.install\n";
	system "sed 's/\%file%/$file/g' debian/install.in > debian/psx-bios-$rom.install"
		and die "Error creating debian/install.in: $?";
}

close CONTROL;
