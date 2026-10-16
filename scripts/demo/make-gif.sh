#!/usr/bin/env bash
# Builds demo.gif from the VHS recording (session.mp4) and the image the agent downloaded (hero.jpg).
# The terminal is shown on the left; a preview panel on the right fades in when the download finishes.
# Waiting time is sped up. Run in a directory holding session.mp4 and hero.jpg.
# Needs ffmpeg, gifsicle, ImageMagick.
set -euo pipefail

T_SHOW=50.3   # second of session.mp4 where the download finishes; the preview fades in then
CREDIT="${CREDIT:-Photo by Septimiu Lupea on Pexels}"   # the credit the agent reported in this take
FONT="${FONT:-/System/Library/Fonts/Menlo.ttc}"
DIMS="$(magick identify -format '%w x %h' hero.jpg)"
SIZE="$(( $(wc -c < hero.jpg) / 1024 )) KB"

# Preview panel, 420x720: an empty placeholder first, then the downloaded image with its caption and credit.
magick -size 420x720 xc:'#181825' -font "$FONT" -fill '#a6adc8' -pointsize 15 -annotate +24+40 'Preview' \
  -fill none -stroke '#45475a' -strokewidth 1.5 -draw "roundrectangle 24,250 396,481 10,10" \
  -stroke none -fill '#585b70' -pointsize 14 -annotate +112+372 'public/images/hero.jpg' \
  -stroke '#313244' -strokewidth 1 -draw "line 0,0 0,720" -depth 8 panel-empty.png
magick hero.jpg -resize 372x -bordercolor '#313244' -border 1 +repage card.png
CH="$(magick identify -format '%h' card.png)"
Y=$((250 + CH + 28))
magick -size 420x720 xc:'#181825' -font "$FONT" -fill '#a6adc8' -pointsize 15 -annotate +24+40 'Preview' \
  -stroke '#313244' -strokewidth 1 -draw "line 0,0 0,720" -stroke none \
  card.png -gravity northwest -geometry +24+250 -composite \
  -fill '#cdd6f4' -pointsize 14 -annotate +24+$Y 'public/images/hero.jpg' \
  -fill '#a6e3a1' -annotate +24+$((Y+30)) '✓' -fill '#a6adc8' -annotate +44+$((Y+30)) 'downloaded' \
  -fill '#f9e2af' -annotate +24+$((Y+60)) "$CREDIT" \
  -fill '#6c7086' -annotate +24+$((Y+90)) "$DIMS · landscape · $SIZE" -depth 8 panel-result.png

# Speed ramp: typing ~1.5x, the agent's search at 5x, the download at 3x, then the answer at 1x and a final hold.
ffmpeg -v error -y -i session.mp4 -loop 1 -framerate 30 -i panel-empty.png -loop 1 -framerate 30 -i panel-result.png \
  -filter_complex "
[1:v]format=rgba[pe];[2:v]format=rgba,fade=in:st=$T_SHOW:d=0.6:alpha=1[pr];
[pe][pr]overlay[panel];
[0:v]format=rgba[term];
[term][panel]hstack=inputs=2:shortest=1,fps=30,format=rgb24[full];
[full]split=5[a][b][c][d][e];
[a]trim=1.0:10.5,setpts=(PTS-STARTPTS)/1.5[s1];
[b]trim=10.5:34.0,setpts=(PTS-STARTPTS)/5[s2];
[c]trim=34.0:49.5,setpts=(PTS-STARTPTS)/3[s3];
[d]trim=49.5:52.2,setpts=PTS-STARTPTS[s4];
[e]trim=52.1:52.2,setpts=PTS-STARTPTS,tpad=stop_mode=clone:stop_duration=4[s5];
[s1][s2][s3][s4][s5]concat=n=5:v=1:a=0,fps=12,scale=960:-2:flags=lanczos,split[x][y];
[x]palettegen=max_colors=256:stats_mode=full[p];[y][p]paletteuse=dither=bayer:bayer_scale=3[out]" \
  -map "[out]" demo-raw.gif
gifsicle -O3 --lossy=25 demo-raw.gif -o demo.gif
echo "wrote $PWD/demo.gif"
