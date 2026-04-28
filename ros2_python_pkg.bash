#!/bin/bash

ros2_create_hybrid() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a package name."
        return 1
    fi

    # 1. Create the package
    ros2 pkg create --build-type ament_cmake "$1"
    
    # 2. Create Python structure (Directory, Init, and the Script)
    mkdir -p "$1/$1"
    touch "$1/$1/__init__.py"
    touch "$1/$1/python.py"  # <--- Added this fix!

    # 3. Define the Python CMake block
    PYTHON_CMK=$(cat <<'EOF'

find_package(ament_cmake_python REQUIRED)
find_package(rclpy REQUIRED)

install(PROGRAMS
  ${PROJECT_NAME}/python.py
  DESTINATION lib/${PROJECT_NAME}
)

ament_python_install_package(${PROJECT_NAME})

EOF
)

    # 4. Inject into CMakeLists.txt
    export PYTHON_CMK
    perl -i -0777 -pe 's/ament_package\(\)/$ENV{PYTHON_CMK}\nament_package()/' "$1/CMakeLists.txt"

    # 5. Inject dependencies into package.xml
    # Adds them right after the ament_cmake buildtool dependency
    sed -i '/<buildtool_depend>ament_cmake<\/buildtool_depend>/a \  <buildtool_depend>ament_cmake_python<\/buildtool_depend>\n  <depend>rclpy<\/depend>' "$1/package.xml"

    echo "---"
    echo "Hybrid package '$1' is fully initialized."
    echo "Files created: $1/$1/python.py and $1/$1/__init__.py"
    echo "CMakeLists.txt and package.xml have been updated."
}