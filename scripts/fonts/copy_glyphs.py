import fontforge

src = fontforge.open("JetBrainsMonoIF-Regular.ttf")
dst = fontforge.open("JetBrainsMonoNLNFM-Regular.ttf")

start = 0xF250D
end   = 0xFEEEE   

for codepoint in range(start, end):
    if codepoint in src:
        glyph_name = src[codepoint].glyphname

        # Create glyph in destination if missing
        if codepoint not in dst:
            dst.createChar(codepoint, glyph_name)

        # Copy glyph shape and metrics
        dst[codepoint].foreground = src[codepoint].foreground
        dst[codepoint].width = src[codepoint].width
        dst[codepoint].vwidth = src[codepoint].vwidth
        dst[codepoint].unlinkRef()

        print(f"✓ Copied U+{codepoint:06X} ({glyph_name})")

# Save output font
dst.generate("merged.ttf")
print("Done! Saved as merged.ttf")
