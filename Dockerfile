FROM ros:humble

ENV DEBIAN_FRONTEND=noninteractive

# Install everything
RUN apt update && \
    apt install -y python3-pip python3-tk mesa-utils xauth openssh-server \
                   ros-humble-rqt-graph \
                   ros-humble-cartographer ros-humble-cartographer-ros \
                   ros-humble-navigation2 ros-humble-nav2-bringup \
                   ros-humble-tf-transformations \
                   ros-humble-dynamixel-sdk ros-humble-turtlebot3 ros-humble-turtlebot3-msgs  \
                   ros-dev-tools && \
    # To avoid warning during package build
    # https://github.com/ros/geometry_tutorials/issues/67
    pip3 install --no-cache-dir setuptools==58.2.0 transforms3d paho-mqtt

# Configure SSH
RUN printf "Port 10000\nPermitRootLogin yes" > /etc/ssh/sshd_config.d/lcis.conf && \
    echo 'root:root' | chpasswd

# $: last line  i: insert before. newline is automatocally add because GNU sed is nice.
RUN sed --in-place --expression '$i source "/usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash"' /ros_entrypoint.sh && \
    sed --in-place --expression '$i test -f "/root/my_workspace/install/setup.bash" && source "/root/my_workspace/install/setup.bash"' /ros_entrypoint.sh

# Install Gazebo Fortress
# RUN apt install python3-pip wget lsb-release gnupg curl && \
#    wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
#    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
#    apt-get update && \
#    apt install -y ignition-fortress

# This command has cost Guillaume many hours of browsing, trying tutorials, chasing dependencies
# change it at your own risks
RUN apt install -y ros-humble-ros-ign ros-humble-ign-ros2-control ros-humble-ros-ign-interfaces \
                   ros-humble-joint-state-broadcaster ros-humble-joint-state-publisher ros-humble-diff-drive-controller
ENV IGN_GAZEBO_RESOURCE_PATH=/opt/ros/humble/share/
ENV IGN_GAZEBO_SYSTEM_PLUGIN_PATH=/opt/ros/humble/lib/

RUN rm -rf /var/lib/apt/lists/*
WORKDIR /root/my_workspace

CMD ["bash"]
