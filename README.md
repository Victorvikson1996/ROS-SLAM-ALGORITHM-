# ROS MQTT

This project uses `podman` (like a rootless docker) to create ROS environment with all dependencies and ensure that alll users has the same environment. 
To install podman, start by reading the [intranet page](http://intranet.lcis.fr/doku.php?id=scientifique:outils_utilises_par_le_lcis:container_docker_podman:installation_podman). 

The ROS environment use:
- `ROS Humble` [LTS to 2027/05](https://docs.ros.org/en/humble/Releases.html)
- `Gazebo Fortress` [LTS to 2026/09](https://gazebosim.org/docs/fortress/releases)

You will find on this repo:
- `Makefile`: Makefile with basic command to create/run ROS node and manage ROS container (include `makefiles/*.mk`)
- `makefiles/`: Sub makefile included by `Makefile`. **Each `.mk` has specific documentation**.
- `Dockerfile`: Dockerfile to build ROS environment image.
- `src/`: `src/` ROS workspace `src/` folder (bind to the container) where you put your ROS packages.
- `src/example_pkg/`: ROS packages for example
- `src/example_pkg/example_pkg/hello_node.py`: ROS Node example
- `src/example_pkg/launch/hello.yaml`: ROS launch example to launch `hello_node.py`


## Getting started

*Re*create the ROS environment:
```shell
make recreate_container
make run  # To run example node
```

And in another terminal:
```shell
make echo_counter  # To see publications of the example running node
```

This command will build the podman image and will create a container.
This container runs an ssh server (port `10000`, user `root`, pass `root`) to allow IDE to index libraries.


## Create your own package and node

Then create your ROS package and node: 
```shell
make create_package # with name defined in Makefile
# or
make create_package PACKAGE_NAME=example_pkg

# Then
make create_node # with names defined in Makefile
# or
make create_node PACKAGE_NAME=example_pkg NODE_NAME=hello_node
```

Run your node:
```shell 
make run # with names defined in Makefile
# or
make run PACKAGE_NAME=example_pkg NODE_NAME=hello_node
# or if there is launch file
make launch # with names defined in Makefile
# or 
make launch PACKAGE_NAME=example_pkg LAUNCH_NAME=hello.yaml
```

You can add `NAMESPACE=your_robot` to change the node namespace.

**Don't hesitate to explore `Makefile` and `makefiles/ros.mk`**
