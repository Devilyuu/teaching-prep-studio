# -*- coding: utf-8 -*-
"""
拼总览图.py：把 逐页预览/slide_XX.png 拼成一张 _contact_sheet.png。
阶段 8 视觉目检的标准做法：先看总览图判断整体节奏、配色与明显溢出，再打开关键页原图细看。
用法：python 拼总览图.py <逐页预览目录> [--cols 4] [--thumb 480]
依赖：Pillow
"""
import argparse
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8")  # Windows 控制台中文不乱码
except Exception:
    pass

from PIL import Image, ImageDraw, ImageFont


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dir", help="含 slide_XX.png 的目录")
    ap.add_argument("--cols", type=int, default=4)
    ap.add_argument("--thumb", type=int, default=480, help="缩略图宽度")
    ap.add_argument("--out", default="_contact_sheet.png")
    a = ap.parse_args()

    files = sorted(f for f in os.listdir(a.dir) if re.match(r"slide_\d+\.png$", f))
    if not files:
        sys.exit("目录里没有 slide_XX.png")
    imgs = [Image.open(os.path.join(a.dir, f)).convert("RGB") for f in files]
    w0, h0 = imgs[0].size
    tw = a.thumb
    th = round(h0 * tw / w0)
    pad, label = 16, 28
    cols = a.cols
    rows = (len(imgs) + cols - 1) // cols
    W = cols * tw + (cols + 1) * pad
    H = rows * (th + label) + (rows + 1) * pad
    sheet = Image.new("RGB", (W, H), "#E5E5E0")
    d = ImageDraw.Draw(sheet)
    font = None
    for name in ("msyh.ttc", "PingFang.ttc", "NotoSansCJK-Regular.ttc", "arial.ttf"):
        try:
            font = ImageFont.truetype(name, 18)
            break
        except Exception:
            continue
    if font is None:
        font = ImageFont.load_default()
    for i, im in enumerate(imgs):
        r, c = divmod(i, cols)
        x = pad + c * (tw + pad)
        y = pad + r * (th + label + pad)
        sheet.paste(im.resize((tw, th), Image.LANCZOS), (x, y))
        d.rectangle([x, y, x + tw - 1, y + th - 1], outline="#8A8880")
        d.text((x, y + th + 4), "P%02d  %s" % (i + 1, files[i]), fill="#1A1A1A", font=font)
    out = os.path.join(a.dir, a.out)
    sheet.save(out)
    print("总览图: %s（%d 页，%d x %d）" % (out, len(imgs), W, H))


if __name__ == "__main__":
    main()
