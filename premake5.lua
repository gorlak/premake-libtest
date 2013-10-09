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

if _OPTIONS[ "fix" ] then
	configuration "macosx" linkoptions { "-Wl,-install_name,@executable_path/libbar.dylib" }
end

project "baz"
	language "C++"
	kind "ConsoleApp"
	files { "baz/*.cpp" }

if _OPTIONS[ "fix" ] then
	configuration "macosx" links { "foo", "bar" }
	configuration "linux" links { "foo" }
	configuration { "linux", "debug" } linkoptions { "-Wl,-rpath=\\$$ORIGIN", "-Lbin/debug", "-lbar" }
	configuration { "linux", "release" } linkoptions { "-Wl,-rpath=\\$$ORIGIN", "-Lbin/release", "-lbar" }
else
	links { "foo", "bar" }
end
