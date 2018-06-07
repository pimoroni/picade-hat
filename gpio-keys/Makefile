all:
	dtc -I dts -O dtb -o picade.dtbo picade.dts

dt-remove:
	sudo dtoverlay -r picade

dt-load:
	sudo dtoverlay picade.dtbo
