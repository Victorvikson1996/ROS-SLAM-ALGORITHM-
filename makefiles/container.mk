
# Rules to build, create and delete container ROS environment.

# Once the container created, a ssh server on port 10000 is running on host network.
# This ssh server is used by PyCharm for source indexation.
# While this ssh server is running, the ROS environment is OK.
# `podman exec` commands are used for everything.

# Config to allow container to use the GUI (for Gazebo)
GUI += --device /dev/dri --device /dev/snd
GUI += -e DISPLAY

# Config to allow container to use the GPU (for Gazebo)
GPU += --hooks-dir=/usr/share/containers/oci/hooks.d/
GPU += --security-opt=label=disable
GPU += -e __NV_PRIME_RENDER_OFFLOAD=1
GPU += -e __GLX_VENDOR_LIBRARY_NAME=nvidia
GPU += -e NVIDIA_VISIBLE_DEVICES=all
GPU += -e NVIDIA_DRIVER_CAPABILITIES=all

# Prefix to run command in the container.
# ros_entrypoint.sh is used to setup ROS environment.
EXEC = podman exec -it $(CONTAINER_NAME) /ros_entrypoint.sh

# podman image/container names
IMAGE_NAME := lcis_turtlebot3_ign
CONTAINER_NAME := ros_ws_ign

# Volume to ROS source workspace. It is relative to root Makefile (in ..)
VOLUME += -v $(VOLUME_HOST):/root/my_workspace/src

# Build image in ../Dockerfile
build_image:
	podman build --network host -t $(IMAGE_NAME) -f Dockerfile .

# Create a container by starting ssh service and bloking `sh` command
create_container: build_image
	# Can use podman create, then podman run
	mkdir -p $(VOLUME_HOST)
	podman run -dit --network host --name $(CONTAINER_NAME) $(CONFIG) $(GUI) $(GPU) $(VOLUME) $(IMAGE_NAME) -- bash -c "service ssh start ; sh"

# Kill and delete the container
delete_container:
	-podman kill $(CONTAINER_NAME)
	-podman rm $(CONTAINER_NAME)

# easy
recreate_container: delete_container create_container build
