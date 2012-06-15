CHANNELS ?= trees crimes cabs

WIDTH  ?= 1000
HEIGHT ?= 1000

CENTER ?= -122.43 37.758
ZOOM ?= 13
BBOX_FACTOR = 1.5

NIK2IMG ?= nik2img.py -f png -d $(WIDTH) $(HEIGHT) -c $(CENTER) -z $(ZOOM) --bbox-factor $(BBOX_FACTOR) --no-open

# Uncomment these two lines if you want to use a bounding box
# rather than a center and zoom 
# BBOX = -122.53 37.82 -122.36 37.70
# NIK2IMG = nik2img.py -f png -d $(WIDTH) $(HEIGHT) -b $(BBOX) --bbox-factor $(BBOX_FACTOR) --no-open

.PRECIOUS: data/%.shp data/%.csv.vrt channels/%.png channels/%.xml

all: composite.png

composite.png: $(CHANNELS:%=channels/%.png)
	python concoct.py -o $@ $^

all-channels: $(CHANNELS:%=channels/%.png)
all-styles: $(CHANNELS:%=channels/%.xml)

channels/%.png: channels/%.xml
	$(NIK2IMG) $< $@

data/%.shp: data/%.csv.vrt
	ogr2ogr -f "ESRI Shapefile" $@ $<

channels/%.xml: data/%.shp
	cat points.xml | perl -pi -e 's#FILENAME#../$<#g' > $@

data/%.csv.vrt: data/%.csv
	cat csv.vrt | perl -pi -e 's#FILENAME#$<#g' | perl -pi -e 's#LAYER#$*#g' > $@

clean:
	rm -f composite.png
	rm -f channels/*.png

style-clean:
	rm -f channels/*.xml

data-clean:
	rm -f data/*.csv.vrt
	rm -f data/*.shp data/*.dbf data/*.shx data/*.prj

dist-clean: clean style-clean data-clean
