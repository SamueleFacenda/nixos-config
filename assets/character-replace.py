from fontTools.ttLib import TTFont
import sys
import os

source = sys.argv[1]
dest = sys.argv[2]

assert os.path.isfile(source)
assert os.path.isfile(dest)

source_font = TTFont(source)
dest_font = TTFont(dest)

for target in sys.argv[3:]:
    tmp = source_font['glyf'][target]
    dest_font['glyf'][target] = tmp

source_font.save('out.ttf')
