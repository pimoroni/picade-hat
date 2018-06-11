all:
	dtc -I dts -O dtb -o picade.dtbo picade.dts

dt-remove:
	dtoverlay -r picade

dt-load:
	dtoverlay picade.dtbo

install:
	cp picade.dtbo /boot/overlays/
