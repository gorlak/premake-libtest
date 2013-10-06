solution "libtest"

platforms{ "x64" }
configurations{ "debug", "release" }

configuration "debug"
targetdir "bin/debug"

configuration "release"
targetdir "bin/release"

project "foo"
	language "C++"
	kind "StaticLib"
	files { "foo/*.cpp" }

project "bar"
	language "C++"
	kind "SharedLib"
	files { "bar/*.cpp" }
	links { "foo" }

project "baz"
	language "C++"
	kind "ConsoleApp"
	files { "baz/*.cpp" }
	links { "foo", "bar" }