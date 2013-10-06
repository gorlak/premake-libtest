newoption
{
	trigger = "fix",
	description = "Set to fix shared lib loading"
}


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

if _OPTIONS[ "fix"] then
	linkoptions { "-Wl,-install_name,@executable_path/libbar.dylib" }
end

project "baz"
	language "C++"
	kind "ConsoleApp"
	files { "baz/*.cpp" }
	links { "foo", "bar" }
