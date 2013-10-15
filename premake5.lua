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
	-- Set the install_name (aka install path) of this module
	--  This tells modules that link against this dylib that any entry passed via -rpath will be tried as 
	--  a potential location to load this library from (at runtime).  This plants the seed for linking
	--  other modules that depend on this to specify paths where this module may be found.
	--  See paragraph 3: http://www.kitware.com/blog/home/post/510
	configuration "macosx" linkoptions { "-Wl,-install_name,@rpath/libbar.dylib" }
end

project "baz"
	language "C++"
	kind "ConsoleApp"
	files { "baz/*.cpp" }

if _OPTIONS[ "fix" ] then
	-- Link dependent libraries as normal
	--  Giving ld a relpath to dependent dylibs is fine... no funky relpaths like linux
	configuration "macosx" links { "foo", "bar" }

	-- Set rpath to the location we expect to find dependent dylibs 
	--  Since the location of the executable (or 'loader' in the case of an intermediate dylib) is the same
	--  as where we want to search for dependencies, just specify loader_path as the rpath to use at runtime.
	--  At link time the install_name is copied from each dependent dylib, but this path is what is used to 
	--  complete the path to the modules at runtime.  To say it another way, the install_name is copied wihtout
	--  substitution at link time, but this path specifies what to replace @rpath with at runtime (to the loader).
	configuration { "macosx", "debug" } linkoptions { "-Wl,-rpath,@loader_path/" }
	configuration { "macosx", "release" } linkoptions { "-Wl,-rpath,@loader_path/" }

	-- Link dependent library by name, not by relative path.
	--  Specifying a relative path bakes the relative path from the linker's cwd referenced at link time as the path
	--  to use to resolve the location of the shared object at runtime.  This requires running the program from the
	--  identical relative folder to what the cwd was when running the linker (so that the relative path to the shared object is valid).
	configuration "linux" links { "foo" }
	configuration { "linux", "debug" } linkoptions { "-Lbin/debug", "-lbar" }
	configuration { "linux", "release" } linkoptions { "-Lbin/release", "-lbar" }

	-- Add $ORIGIN as a valid path to use to resolve shared objects at runtime
	--  This adds the directory of the referencing module as a valid location to resolve dependent modules
	configuration "linux" linkoptions { "-Wl,-rpath=\\$$ORIGIN" }
else
	links { "foo", "bar" }
end
