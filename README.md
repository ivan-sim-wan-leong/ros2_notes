# cmake
### dependencies
```
set(dependencies
  rclcpp
  geometry_msgs
  tf2
  tf2_ros
)

foreach(pkg IN LISTS dependencies)
  find_package(${pkg} REQUIRED)
endforeach()
```

### include directories
```
include_directories(
  include
)
```

### eigen lib
```
find_package(Eigen3 REQUIRED)
include_directories(SYSTEM ${EIGEN3_INCLUDE_DIRS})
```

### libraries
```
add_library(lib_name SHARED
  src/utils/---.cpp
  src/---.cpp
)

target_include_directories(lib_name PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
)

target_link_libraries(lib_name
  jsoncpp
  yaml-cpp
)

ament_target_dependencies(lib_name
  ${dependencies}
)
```

### executable
```
add_executable(node_name
  src/---.cpp
)

target_include_directories(node_name PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
)

target_link_libraries(node_name
  lib_name
)

ament_target_dependencies(node_name PUBLIC
  ${dependencies}
)
```

### install
```
install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION include/${PROJECT_NAME}
)

install(
  TARGETS lib1 lib2
  EXPORT ${PROJECT_NAME} # only one export
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)

install(TARGETS 
  node_name1 
  node_name2
  DESTINATION lib/${PROJECT_NAME})

install(DIRECTORY launch config
  DESTINATION share/${PROJECT_NAME}/)
```

### ament export
```
ament_export_dependencies(${dependencies})
ament_export_include_directories(include) # name of folder in install/${PROJECT_NAME}/
ament_export_libraries(lib1 lib2) # all libraries
ament_export_targets(${PROJECT_NAME})

ament_package()
```
