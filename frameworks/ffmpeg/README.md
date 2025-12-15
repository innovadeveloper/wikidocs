```sh
ffmpeg -re -i ./sample.mp4 \
  -c:v libx264 -preset veryfast -b:v 500k -maxrate 500k -bufsize 1000k \
  -c:a aac -b:a 64k -ar 44100 \
  -f flv \
  "rtmp://origin.obstream.sx/cast?publishsign=aWQ9Nzc2OCZzaWduPTkwVXFQZkUxekl2TVU3cUtCVkVkMnc9PQ=="

ffmpeg -re -i ./sample.mp4 \
  -c:v libx264 -preset veryfast -b:v 500k -maxrate 500k -bufsize 1000k \
  -pix_fmt yuv420p \
  -profile:v baseline \
  -g 30 -keyint_min 30 \
  -c:a aac -b:a 64k -ac 2 -ar 44100 \
  -f flv \
  "rtmp://origin.obstream.sx/cast/opfos5hdvvz?publishsign=aWQ9Nzc2OCZzaWduPTkwVXFQZkUxekl2TVU3cUtCVkVkMnc9PQ=="


ffmpeg -re -i ./sample.mp4 \
  -c:v libx264 -preset veryfast -b:v 450k \
  -pix_fmt yuv420p -profile:v baseline \
  -g 30 -keyint_min 30 \
  -c:a aac -b:a 64k -ac 2 -ar 44100 \
  -f flv \
  -rtmp_app "cast?publishsign=aWQ9Nzc2OCZzaWduPTkwVXFQZkUxekl2TVU3cUtCVkVkMnc9PQ==" \
  -rtmp_playpath "opfos5hdvvz" \
  "rtmp://origin.obstream.sx"


ffmpeg -re -i ./sample.mp4 \
  -map 0:v:0 -map 0:a:0 \
  -c:v libx264 -preset veryfast -b:v 450k \
  -pix_fmt yuv420p -profile:v baseline \
  -g 30 -keyint_min 30 \
  -c:a aac -profile:a aac_low -b:a 64k -ac 2 -ar 44100 \
  -flvflags no_duration_filesize \
  -f flv \
  -rtmp_app "cast?publishsign=aWQ9Nzc2OCZzaWduPTkwVXFQZkUxekl2TVU3cUtCVkVkMnc9PQ==" \
  -rtmp_playpath "opfos5hdvvz" \
  "rtmp://origin.obstream.sx"

# audio + video
ffmpeg -stream_loop -1 -re -i ./sample.mp4 \
  -map 0:v:0 -map 0:a:0 \
  -c:v libx264 -preset veryfast -b:v 450k \
  -pix_fmt yuv420p -profile:v baseline \
  -g 30 -keyint_min 30 \
  -c:a aac -profile:a aac_low -b:a 64k -ac 2 -ar 44100 \
  -flvflags no_duration_filesize \
  -f flv \
  -rtmp_app "cast?publishsign=aWQ9Nzc2OCZzaWduPTkwVXFQZkUxekl2TVU3cUtCVkVkMnc9PQ==" \
  -rtmp_playpath "opfos5hdvvz" \
  "rtmp://origin.obstream.sx"
```