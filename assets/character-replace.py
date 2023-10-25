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
    dest_font['glyf'][target] = source_font['glyf'][target]
    # add also to the hmtx table
    dest_font['hmtx'][target] = source_font['hmtx'][target]

dest_font.save(dest)
