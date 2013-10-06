Mac

default

		$ otool -L bin/debug/baz
		bin/debug/baz:
			bin/debug/libbar.dylib (compatibility version 0.0.0, current version 0.0.0)
			/usr/lib/libstdc++.6.dylib (compatibility version 7.0.0, current version 56.0.0)
			/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 169.3.0)
		
		$ bin/debug/baz
		2
		
		$ cd bin/debug
		
		$ ./baz
		dyld: Library not loaded: bin/debug/libbar.dylib
		  Referenced from: /Users/geoff/Projects/premake-libtest/bin/debug/./baz
		  Reason: image not found
		Trace/BPT trap: 5

with --fix

		$ otool -L bin/debug/baz
		bin/debug/baz:
			@executable_path/libbar.dylib (compatibility version 0.0.0, current version 0.0.0)
			/usr/lib/libstdc++.6.dylib (compatibility version 7.0.0, current version 56.0.0)
			/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 169.3.0)
		
		$ bin/debug/baz
		2
		
		$ cd bin/debug
		
		$ ./baz
		2

Linux

ldd bin/debug/baz:
