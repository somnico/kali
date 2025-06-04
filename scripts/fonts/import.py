import fontforge
import os

font = fontforge.open("C:/Users/nfs/svg-frame-extractor/merged.sfd")

svg_dir = "C:/Users/nfs/svg-frame-extractor/svgs"
start_codepoint = 0xF64A

for i, filename in enumerate(sorted(os.listdir(svg_dir))):
    if filename.endswith(".svg"):
        codepoint = start_codepoint + i
        glyph = font.createChar(codepoint)
        glyph.importOutlines(os.path.join(svg_dir, filename))
        glyph.simplify()
        glyph.autoHint()
        glyph.width = 600
        print(f"Imported '{filename}' as glyph U+{codepoint:04X} with width {glyph.width}")

font.save("C:/Users/nfs/svg-frame-extractor/merged-updated.sfd")

# & "C:\Program Files (x86)\FontForgeBuilds\bin\fontforge.exe" -script C:/Users/nfs/svg-frame-extractor/import.py