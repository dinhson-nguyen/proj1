cmake_minimum_required(VERSION 3.02.1)

option(LINK_INSIGHT "Link Qt Insight Tracker library" ON)
option(BUILD_QDS_COMPONENTS "Build design studio components" ON)
set(CMAKE_PREFIX_PATH "/opt/ros/noetic;/home/dinhson/amr_ws/devel")
project(proj1_node LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

include_directories(/home/dinhson/yaml-cpp/include)
link_directories(/home/dinhson/yaml-cpp/lib)
find_package(catkin REQUIRED COMPONENTS
  roscpp
  std_msgs
  std_stamped_msgs
  
  
)
find_package(yaml-cpp REQUIRED)

find_package(Qt6 6.2 REQUIRED COMPONENTS Core Gui Qml Quick Linguist)
# qt6_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} simplequick.ts)
# configure_file(${QM_FILES} ${CMAKE_SOURCE_DIR} COPYONLY)

if (Qt6_VERSION VERSION_GREATER_EQUAL 6.3)
    qt_standard_project_setup()
endif()
# include_directories(/home/dinhson/yaml-cpp/include)
catkin_package(
  INCLUDE_DIRS ${catkin_INCLUDE_DIRS} 
  LIBRARIES proj1_node
  CATKIN_DEPENDS roscpp std_msgs std_stamped_msgs
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
  
)


qt6_add_executable(proj1_node  
    src/main.cpp 
    src/backend.cpp 
    src/include/backend.h 
    src/include/json.hpp
    qml.qrc
    # ${QM_FILES}
)
qt6_add_resources( qml.qrc  )
qt6_add_translations(proj1_node)
target_link_libraries(proj1_node PRIVATE
    ${catkin_LIBRARIES}
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Linguist
    yaml-cpp
)

qt6_add_resources(proj1_node "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf

)

set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)
set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY}
    CACHE STRING "Import paths for Qt Creator's code model"
    FORCE
)

if (BUILD_QDS_COMPONENTS)
    include(${CMAKE_CURRENT_SOURCE_DIR}/qmlcomponents)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/qmlmodules)
# include(${CMAKE_CURRENT_SOURCE_DIR}/simplequick.qm)

if (LINK_INSIGHT)
    include(${CMAKE_CURRENT_SOURCE_DIR}/insight)
endif ()

install(TARGETS proj1_node
    BUNDLE DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
    LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
    RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
install(TARGETS proj1_node
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
# make IDEs aware of the QML import path
set(QML_IMPORT_PATH ${PROJECT_BINARY_DIR}/qml CACHE PATH
    "Path to the custom QML components defined by the project")
