.PHONY: clean

BITSTREAM=impl/pnr/Tang_nano_9K_LCD.fs

ide:
	HOME=$(shell pwd) gw_ide

program:
	openFPGALoader -b tangnano9k $(BITSTREAM)

flash:
	openFPGALoader -b tangnano9k -f $(BITSTREAM)

clean:
	rm -rf .cache .config .fontconfig .dbus
	rm -rf impl/gwsynthesis impl/pnr impl/temp
	rm -f *.gprj.user
