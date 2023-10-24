
# Rules to handle ROS environment in the container.
# To run command in ROS environment, $(EXEC) are used as explainer in ./container.mk

# Start a shell into the container
bash:
	$(EXEC) bash

# Create a new ROS package in $(VOLUME_HOST) with name $(PACKAGE_NAME)
# VOLUME_HOST and PACKAGE_NAME are defined in root Makefile
create_package:
	$(EXEC) bash -c "cd src ; ros2 pkg create --build-type ament_python $(PACKAGE_NAME)"
	# To install launch file when "make build"
	mkdir -p $(VOLUME_HOST)/$(PACKAGE_NAME)/launch
	sed --in-place --expression "/data_files/a ('share/' + package_name, glob('launch/*'))," "$(VOLUME_HOST)/$(PACKAGE_NAME)/setup.py"
	sed --in-place --expression "/import/a from glob import glob" "$(VOLUME_HOST)/$(PACKAGE_NAME)/setup.py"

# Create a new ROS node in PACKAGE_NAME package with name NODE_NAME
# NODE_NAME and PACKAGE_NAME are defined in root Makefile
create_node:
	sed --in-place --expression "/console_scripts/a '$(NODE_NAME) = $(PACKAGE_NAME).$(NODE_NAME):main'," "$(VOLUME_HOST)/$(PACKAGE_NAME)/setup.py"
	cp $(VOLUME_HOST)/example_pkg/example_pkg/hello_node.py $(VOLUME_HOST)/$(PACKAGE_NAME)/$(PACKAGE_NAME)/$(NODE_NAME).py

# Build all ROS nodes
build:
	$(EXEC) colcon build

# Run a node
run: build
	$(EXEC) ros2 run $(PACKAGE_NAME) $(NODE_NAME) --ros-args -r __ns:=$(NAMESPACE)

# launch a node
launch: build
	# Launch file should define "namespace" argument
	$(EXEC) ros2 launch $(PACKAGE_NAME) $(LAUNCH_NAME) namespace:=$(NAMESPACE)

# List running nodes
list_node:
	$(EXEC) ros2 node list

# List active topics
list_topic:
	$(EXEC) ros2 topic list