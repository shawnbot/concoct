BBOX = -122.53 37.82 -122.36 37.70
CENTER ?= -122.43 37.758
ZOOM ?= 13
BBOX_FACTOR = 1.5

WIDTH  ?= 1000
HEIGHT ?= 1000

# NIK2IMG ?= nik2img.py -f png -d $(WIDTH) $(HEIGHT) -b $(BBOX) --no-open
NIK2IMG ?= nik2img.py -f png -d $(WIDTH) $(HEIGHT) -c $(CENTER) -z $(ZOOM) --bbox-factor $(BBOX_FACTOR) --no-open

CHANNELS ?= trees crimes cabs

all: composite.png

composite.png: $(CHANNELS:%=channels/%.png)
	python blat.py -o $@ $^

all-channels: $(CHANNELS:%=channels/%.png)

.SECONDARY: data/%.shp data/%.csv.vrt channels/%.png

channels/%.png: data/%.shp
	cat points.xml | perl -pi -e 's#FILENAME#$<#g' | $(NIK2IMG) - $@

data/%.shp: data/%.csv.vrt
	ogr2ogr -f "ESRI Shapefile" $@ $<

data/%.csv.vrt: data/%.csv
	cat csv.vrt | perl -pi -e 's#FILENAME#$<#g' | perl -pi -e 's#LAYER#$*#g' > $@

clean:
	rm -f *.png
	rm -f channels/*.png

data-clean:
	rm -f data/*.csv.vrt
	rm -f data/*.shp data/*.dbf data/*.shx data/*.prj
