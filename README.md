Concoct
====

*concoct* : to prepare by combining raw materials  
*concoction* : a motley assemblage of things, persons or ideas

Concoct is a set of tools for creating maps from three geographic point data sources, each of which is rendered as a primary ink in the [CMYK color model](http://en.wikipedia.org/wiki/CMYK_color_model). The result looks something like this:

![](https://github.com/shawnbot/concoct/raw/master/sample.png)

Overview
===

Here are the basic steps in the concoction process:

  1. Find three geographic point data sets in the same area.
  1. Convert the data sets into Shapefiles, which Mapnik can read directly.
  1. Render each data set into a separate "channel" image (essentially an alpha mask).
  1. Composite the three channels onto white with subtractive blending.

Running it
===

To create a composite using the provided sample data, just run `make` in project directory:

```sh
$ make
```

You should see a list of commands scroll past, and when all is said and done there will be a file named `composite.png` in the same directory.

Parameters
====

All of the parameters to the composite process are in the `Makefile`. Most of them are defined as variables at the top, including:

  * `CHANNELS`: the space-separated names of the three data sets. These should correspond to the `.csv` files in the data directory (e.g., "cabs" refers to "data/cabs.csv").
  * `WIDTH` and `HEIGHT`: the dimensions of the output image in pixels. Note that large image sizes (over 3000 pixels square) may require more memory than your computer allows per process. (If this is the case, you can render smaller areas individually and stitch them together afterwards.)
  * `CENTER`: the center latitude and longitude for the map. [getlatlon.com](http://www.getlatlon.com/) is your friend.
  * `ZOOM`: the zoom level of the map. Bigger numbers zoom in further; [getlatlon.com](http://www.getlatlon.com/) will also tell you which zoom you're looking at on a Google map.
  * `BBOX`: if you choose to define a bounding box rather than a center and zoom, you can uncomment the coresponding lines in the `Makefile`.
  * `BBOX_FACTOR`: an additional zoom factor, which is useful for tweaking the scale of the map independent of zoom level or bounding box.

The rules dictating how individual channels are rendered live first in a single Mapnik XML stylesheet, `points.xml`, a copy of which is created (in `channels/{channel}.xml`) for each channel with a reference to its corresponding data file. See [channels/README.md](channels/README.md) for more info.

Data inputs
===

The inputs to the concoction process are three CSV files containing geographic point data. The CSV files should contain numeric `latitude` and `longitude` columns in the [WGS84 coordinate system](http://geography.about.com/od/geographyintern/a/datums.htm). (All other columns are ignored in the rendering process.)

Prerequisites
===

Concoct relies on a similarly motley assemblage of tools:

  * A [Makefile](http://www.gnu.org/software/make/) for coordinating build steps.
  * [ogr2ogr](http://www.gdal.org/ogr2ogr.html) for converting between geographic data formats (CSV -> Shapefile).
  * [Mapnik](http://mapnik.org/) for rendering each data set into a black and white mask.
  * [Blit](https://github.com/migurski/Blit) and [PIL](http://www.pythonware.com/library/pil/handbook/overview.htm) for compositing data sets into a single image.
