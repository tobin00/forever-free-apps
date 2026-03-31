"""
Generate the Forever Free: NATO Alphabet app icon — Concept E (A → Alpha).
Outputs icon_source_1024.png in this directory.
"""
from PIL import Image, ImageDraw, ImageFont
import math, os

# ── Palette ──────────────────────────────────────────────────────────────────
BG      = (27,  94, 123)   # #1B5E7B  Deep Ocean Blue
AMBER   = (244, 167, 38)   # #F4A726  Warm Amber
WHITE   = (255, 255, 255)
ALPHA_SEP = (*AMBER, 110)   # amber at ~43% opacity for separator

SIZE   = 1024
RADIUS = int(SIZE * 0.2188)  # 224px  —  matches 112/512 from design spec

# ── Canvas ───────────────────────────────────────────────────────────────────
img  = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

draw.rounded_rectangle([(0, 0), (SIZE - 1, SIZE - 1)],
                        radius=RADIUS, fill=BG)

# ── Large "A"  (Arial Black, Amber) ──────────────────────────────────────────
FONT_A_SIZE = 530
font_a = ImageFont.truetype("C:/Windows/Fonts/ariblk.ttf", FONT_A_SIZE)

a_bbox  = draw.textbbox((0, 0), "A", font=font_a)
a_w     = a_bbox[2] - a_bbox[0]
a_h     = a_bbox[3] - a_bbox[1]

# Center horizontally; visual center of "A" at ~38% down the icon
a_center_y = int(SIZE * 0.38)
a_x = (SIZE - a_w) // 2 - a_bbox[0]
a_y = a_center_y - a_h // 2 - a_bbox[1]

draw.text((a_x, a_y), "A", font=font_a, fill=AMBER)

# ── Separator line ────────────────────────────────────────────────────────────
sep_y  = int(SIZE * 0.605)
sep_x0 = int(SIZE * 0.12)
sep_x1 = int(SIZE * 0.88)
# Draw as a semi-transparent rectangle (Pillow can't antialias lines well)
draw.rectangle([(sep_x0, sep_y - 2), (sep_x1, sep_y + 2)],
               fill=(*AMBER, 100))

# ── "— Alpha"  (Arial Bold, White) ───────────────────────────────────────────
FONT_AL_SIZE = 126
font_al  = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", FONT_AL_SIZE)
al_text  = "\u2014 Alpha"          # em-dash

al_bbox  = draw.textbbox((0, 0), al_text, font=font_al)
al_w     = al_bbox[2] - al_bbox[0]
al_h     = al_bbox[3] - al_bbox[1]

al_center_y = int(SIZE * 0.78)
al_x = (SIZE - al_w) // 2 - al_bbox[0]
al_y = al_center_y - al_h // 2 - al_bbox[1]

draw.text((al_x, al_y), al_text, font=font_al, fill=WHITE)

# ── Save ──────────────────────────────────────────────────────────────────────
out_path = os.path.join(os.path.dirname(__file__), "icon_source_1024.png")
# Composite over white for a flat PNG (launcher icons are opaque)
bg_white = Image.new("RGBA", (SIZE, SIZE), (255, 255, 255, 255))
flat     = Image.alpha_composite(bg_white, img)
flat.convert("RGB").save(out_path, "PNG")
print(f"Saved: {out_path}")
