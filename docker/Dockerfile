FROM        ros:humble-ros-base

ENV         PYTHONDONTWRITEBYTECODE=true

SHELL ["/bin/bash", "-c"]

# Copy the locally downloaded Vimba package, there is no direct access link for download, from
# https://www.alliedvision.com/en/products/software.html


RUN apt-get update && apt-get install -y python3-pip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN         apt-get update
RUN         apt-get install -y

RUN apt-get install wget
RUN wget https://downloads.alliedvision.com/VimbaX/VimbaX_Setup-2024-1-Linux_ARM64.tar.gz

RUN         apt-get install python3-rosdep -y
RUN         apt-get install ros-humble-cv-bridge -y
RUN         apt-get install python3-colcon-common-extensions -y
RUN         apt-get install ros-humble-ament-cmake-clang-format -y
RUN         tar -xzf VimbaX_Setup-2024-1-Linux_ARM64.tar.gz -C /opt
RUN         mv /opt/VimbaX_2024-1 /opt/VimbaX

# Create the udev rules directory (needed by the GenTL installation script),
# then run the GenTL script and update the linker cache.
RUN mkdir -p /etc/udev/rules.d && \
    sh /opt/VimbaX/cti/Install_GenTL_Path.sh && ldconfig


# Attempt to reload udev rules; ignore failures since udev isn't fully active in containers. May be excessive
RUN udevadm control --reload-rules && udevadm trigger || true

# Set the Vimba X environment variable so the API finds its transport layer configuration
ENV VIMBA_GENTL_PATH=/opt/VimbaX/cti/VimbaUSBTL.cti

# Register library paths
RUN echo "/opt/VimbaX/api/lib" > /etc/ld.so.conf.d/vimba.conf && \
    echo "/opt/VimbaX/bin" >> /etc/ld.so.conf.d/vimba.conf && \
    ldconfig

ENV GENICAM_GENTL64_PATH=${GENICAM_GENTL64_PATH}:/opt/VimbaX/cti

# Set LD_LIBRARY_PATH to include both API and bin directories
ENV LD_LIBRARY_PATH=/opt/VimbaX/api:/opt/VimbaX/bin


RUN         apt-get install ros-humble-rmw-cyclonedds-cpp -y
RUN         apt-get install libgl1 -y

RUN         mkdir -p /root/ros2_ws/src/
COPY        docker/run.sh /
COPY        docker/ros.sh /
COPY        vimbax_camera /root/ros2_ws/src/vimbax_camera
COPY        vimbax_camera_events /root/ros2_ws/src/vimbax_camera_events
COPY        vimbax_camera_examples /root/ros2_ws/src/vimbax_camera_examples
COPY        vimbax_camera_msgs /root/ros2_ws/src/vimbax_camera_msgs
COPY        vmbc_interface /root/ros2_ws/src/vmbc_interface
WORKDIR     /root/ros2_ws
RUN         rosdep install --from-path src --ignore-src -y
RUN         /bin/bash -c "source /opt/ros/humble/setup.bash; colcon build"

ENTRYPOINT  ["/run.sh"]
