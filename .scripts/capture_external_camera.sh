sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2
sudo gphoto2 --stdout --capture-movie | sudo ffmpeg -i - -vcodec h264_nvenc -thread
s 0 -f v4l2 /dev/video2 #doesn't work
