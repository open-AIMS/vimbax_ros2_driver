# Allow connections to X server
xhost +local:docker

docker run --name vimba --rm -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
   --privileged \
   --device /dev/input \
   --device=/dev/bus/usb:/dev/bus/usb:rwm \
   -v /home/reefscan/greg/reefscan-data:/data \
   vimba
