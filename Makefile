# Makefile

run: link
	eri render
.PHONY: out

link: eri.conf tvcxair/eri.conf tvcxdorm/eri.conf tvcxhome/eri.conf

eri.conf:
	ln -sf "data/eri.conf" "eri.conf"

tvcxair/eri.conf:
	ln -sf "data/eri.tvcxair.conf" "tvcxair/eri.conf"

tvcxdorm/eri.conf:
	ln -sf "data/eri.tvcxdorm.conf" "tvcxdorm/eri.conf"

tvcxhome/eri.conf:
	ln -sf "data/eri.tvcxhome.conf" "tvcxhome/eri.conf"
