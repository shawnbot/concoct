Intermediate files for each channel go here during the rendering process. For
each channel named in the `CHANNELS` Makefile variable, you should see a
corresponding XML stylesheet (`channel.xml`) and, when rendering finishes, a
PNG image (`channel.png`).

Mapnik XML stylesheets are generated from `points.xml` in the parent directory,
the contents of which are searched for the string "FILENAME" and replaced with
the relative path of the channel's data set (e.g., `../data/channel.shp`). You
can modify the generated stylesheets if you want to adjust the symbology for
each channel; e.g., you can change the point radius by modifying the "width"
and "height" attributes of the `<MarkersSymbolizer>` element.
