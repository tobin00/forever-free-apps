"""
gen_store_icons.py
──────────────────
Generates store-ready app icons for Forever Free: NATO Alphabet.

Outputs
───────
google_play/icon.png        512 × 512   RGB  (no alpha)  full-bleed square
apple_app_store/icon.png   1024 × 1024  RGB  (no alpha)  full-bleed square

Rules applied per store specs (2026)
─────────────────────────────────────
• NO pre-applied rounded corners  — stores mask programmatically
• NO alpha channel in final file  — Apple rejects icons with transparency
• Full bleed: design fills every pixel to the edge
• sRGB color space

Run: python store_assets/gen_store_icons.py
(from the nato_alphabet app root, or from inside store_assets/)
"""

from PIL import Image, ImageDraw, ImageFont
import os, sys

# ── Paths ─────────────────────────────────────────────────────────────────────
HERE     = os.path.dirname(os.path.abspath(__file__))
FONT_BLACK  = "C:/Windows/Fonts/ariblk.ttf"   # Arial Black  — bold "A"
FONT_BOLD   = "C:/Windows/Fonts/arialbd.ttf"  # Arial Bold   — "— Alpha"

# ── Brand palette ─────────────────────────────────────────────────────────────
BG      = (27,  94, 123)    # #1B5E7B  Deep Ocean Blue
AMBER   = (244, 167, 38)    # #F4A726  Warm Amber
WHITE   = (255, 255, 255)


def draw_icon(canvas_size: int) -> Image.Image:
    """
    Render the A → Alpha icon at any square size.
    Returns an RGB Image (no alpha), full-bleed, no rounded corners.
    """
    S  = canvas_size
    s  = S / 1024.0          # scale factor relative to 1024 design grid

    img  = Image.new("RGB", (S, S), BG)
    draw = ImageDraw.Draw(img)

    # ── Large "A" ─────────────────────────────────────────────────────────────
    font_a_size = int(530 * s)
    font_a      = ImageFont.truetype(FONT_BLACK, font_a_size)

    a_bbox  = draw.textbbox((0, 0), "A", font=font_a)
    a_w     = a_bbox[2] - a_bbox[0]
    a_h     = a_bbox[3] - a_bbox[1]

    a_center_y = int(S * 0.38)
    a_x = (S - a_w) // 2 - a_bbox[0]
    a_y = a_center_y - a_h // 2 - a_bbox[1]

    draw.text((a_x, a_y), "A", font=font_a, fill=AMBER)

    # ── Separator line ─────────────────────────────────────────────────────────
    sep_y  = int(S * 0.605)
    sep_x0 = int(S * 0.12)
    sep_x1 = int(S * 0.88)
    sep_h  = max(2, int(4 * s))
    draw.rectangle(
        [(sep_x0, sep_y - sep_h // 2), (sep_x1, sep_y + sep_h // 2)],
        fill=(244, 167, 38, 100) if img.mode == "RGBA" else (180, 130, 40),
    )

    # ── "— Alpha" ──────────────────────────────────────────────────────────────
    font_al_size = int(126 * s)
    font_al      = ImageFont.truetype(FONT_BOLD, font_al_size)
    al_text      = "\u2014 Alpha"           # em-dash

    al_bbox  = draw.textbbox((0, 0), al_text, font=font_al)
    al_w     = al_bbox[2] - al_bbox[0]
    al_h     = al_bbox[3] - al_bbox[1]

    al_center_y = int(S * 0.78)
    al_x = (S - al_w) // 2 - al_bbox[0]
    al_y = al_center_y - al_h // 2 - al_bbox[1]

    draw.text((al_x, al_y), al_text, font=font_al, fill=WHITE)

    return img


TARGETS = [
    {
        "label":    "Google Play Store",
        "size":     512,
        "out":      os.path.join(HERE, "google_play", "icon.png"),
        "mode":     "RGB",
        "note":     "512x512 RGB PNG - upload to Google Play Console > Store listing > App icon",
    },
    {
        "label":    "Apple App Store",
        "size":     1024,
        "out":      os.path.join(HERE, "apple_app_store", "icon.png"),
        "mode":     "RGB",   # Apple rejects any file with an alpha channel
        "note":     "1024x1024 RGB PNG - upload to App Store Connect > App Information > App Icon",
    },
]

for t in TARGETS:
    img = draw_icon(t["size"])
    if img.mode != t["mode"]:
        img = img.convert(t["mode"])
    img.save(t["out"], "PNG")
    size_kb = os.path.getsize(t["out"]) // 1024
    print(f"OK  {t['label']:25s}  {t['size']}x{t['size']}  {size_kb} KB")
    print(f"    {t['out']}")
    print(f"    {t['note']}")
    print()

print("Done. No rounded corners applied - stores mask programmatically.")
