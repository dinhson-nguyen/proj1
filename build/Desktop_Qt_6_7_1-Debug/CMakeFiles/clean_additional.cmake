# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Release")
  file(REMOVE_RECURSE
  "CMakeFiles/proj1_node_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/proj1_node_autogen.dir/ParseCache.txt"
  "CMakeFiles/proj1_qds_components_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/proj1_qds_components_autogen.dir/ParseCache.txt"
  "content/CMakeFiles/content_autogen.dir/AutogenUsed.txt"
  "content/CMakeFiles/content_autogen.dir/ParseCache.txt"
  "content/CMakeFiles/contentplugin_autogen.dir/AutogenUsed.txt"
  "content/CMakeFiles/contentplugin_autogen.dir/ParseCache.txt"
  "content/CMakeFiles/contentplugin_init_autogen.dir/AutogenUsed.txt"
  "content/CMakeFiles/contentplugin_init_autogen.dir/ParseCache.txt"
  "content/content_autogen"
  "content/contentplugin_autogen"
  "content/contentplugin_init_autogen"
  "imports/proj1/CMakeFiles/proj1_autogen.dir/AutogenUsed.txt"
  "imports/proj1/CMakeFiles/proj1_autogen.dir/ParseCache.txt"
  "imports/proj1/CMakeFiles/proj1plugin_autogen.dir/AutogenUsed.txt"
  "imports/proj1/CMakeFiles/proj1plugin_autogen.dir/ParseCache.txt"
  "imports/proj1/CMakeFiles/proj1plugin_init_autogen.dir/AutogenUsed.txt"
  "imports/proj1/CMakeFiles/proj1plugin_init_autogen.dir/ParseCache.txt"
  "imports/proj1/proj1_autogen"
  "imports/proj1/proj1plugin_autogen"
  "imports/proj1/proj1plugin_init_autogen"
  "proj1_node_autogen"
  "proj1_qds_components_autogen"
  )
endif()
