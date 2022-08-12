.PHONY: clean

BITSTREAM=impl/pnr/tang_nano.fs

ide:
	HOME=$(shell pwd) gw_ide

program:
	openFPGALoader -b tangnano -m $(BITSTREAM)

flash:
	openFPGALoader -b tangnano -f $(BITSTREAM)

clean:
	rm -rf .cache .config .fontconfig .dbus
	rm -rf impl/gwsynthesis impl/pnr impl/temp
	rm -f *.gprj.user
