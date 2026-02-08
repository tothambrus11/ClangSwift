# ClangSwift

ClangSwift is a Swifty wrapper for the `libclang` C API.

The project requires at least LLVM 21.

For setting up the project, install LLVM and make its binaries available on the PATH. Then run `make-pkgconfig.swift`, which will produce `cclang.pc` for pkgconfig. Copy this file to `/usr/local/lib/pkgconfig` (or the appropriate directory for your system), or add it to `PKG_CONFIG_PATH`. This will allow SwiftPM to find `clang` libraries and headers during the build.

# Authors

- Harlan Haskins ([@harlanhaskins](https://github.com/harlanhaskins))
- Robert Widmann ([@CodaFi](https://github.com/CodaFi))
- Ambrus Toth ([@tothambrus11](https://github.com/tothambrus11))

# License

ClangSwift is released under the MIT License, a copy of which is included
in [LICENSE](LICENSE).
