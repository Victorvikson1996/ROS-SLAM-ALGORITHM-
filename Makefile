.SILENT:

# Some use configurations

#CONFIG += -e TURTLEBOT3_MODEL=burger
CONFIG += -e ROS_DOMAIN_ID=30

PACKAGE_NAME := example_pkg
NODE_NAME := hello_node
LAUNCH_NAME := hello.yaml
NAMESPACE:=/

VOLUME_HOST=./src


include makefiles/container.mk
include makefiles/ros.mk


echo_counter: build
	$(EXEC) ros2 topic echo /counter
