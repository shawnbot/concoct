from Blit import Bitmap, Color, blends

R = Color(255, 0, 0)
G = Color(0, 255, 0)
B = Color(0, 0, 255)
A = Color(255, 255, 255, 0)
WHITE = Color(255, 255, 255)

def blend_raw(layers, colors, op=blends.subtract):
    """
    blend_raw() takes a list of Blit.Layer instances and a list of Blit.Color
    instances, and blends them onto white with the given operation (which
    defaults to Blit.blends.subtract).
    """
    out = WHITE
    for layer, color in zip(layers, colors):
        overlay = A.blend(color, layer)
        out = out.blend(overlay, None, 1, op)
    return out

def blend_cmyk(red, green, blue):
    """
    Blend 3 layers into a single CMYK-like composite. The images are
    interpreted as alpha masks for red, green and blue channels, which are then
    subtractively blended onto white to simulate a CMYK print process. Remember:

    white - red = cyan      (#FFF - #F00 = #0FF)
    white - green = magenta (#FFF - #0F0 = #F0F)
    white - blue = yellow   (#FFF - #00F = #FF0)

    For best results, the layers should be grayscale with black representing
    fully transparent and white representing fully opaque.
    """
    return blend_raw((red, green, blue), (R, G, B))

if __name__ == "__main__":
    import optparse
    parser = optparse.OptionParser(usage='%prog [options] red green blue\n' + blend_cmyk.__doc__)
    parser.add_option('--out', '-o', dest='outfile', default='blat.png')
    options, args = parser.parse_args()

    channels = map(Bitmap, args)
    layer = blend_cmyk(*channels)
    img = layer.image()
    img.save(options.outfile)
