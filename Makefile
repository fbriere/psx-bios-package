MANPAGE=make-psx-bios-package.1

all: $(MANPAGE)

clean:
	rm -f $(MANPAGE)

%.1: %.1.txt
	a2x --doctype manpage --format manpage $<

.PHONY: all clean

