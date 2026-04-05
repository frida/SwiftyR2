# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code)
when working with code in this repository.

## Project Overview

SwiftyR2 is a Swift wrapper library for Radare2 (the reverse
engineering framework). It provides an async/await-based Swift
API on top of the C Radare2 library. On Apple platforms,
Radare2 is consumed as a pre-built binary XCFramework. On
non-Apple platforms, it links against the system radare2
library found via pkg-config (`r_core`). Targets macOS 11+,
iOS 13+, and any other Swift-supported platform.

## Build & Test Commands

```bash
swift build          # Build the library
swift test           # Run all tests
swift test --filter SwiftyR2Tests/testCoreCreationAndSimpleCommand  # Run a single test
```

On Apple platforms, requires Xcode. On non-Apple platforms,
requires radare2 installed as a system library (pkg-config
`r_core`). `LD_LIBRARY_PATH` may need to include the radare2
lib directory if it is not in the default search path.

## Architecture

**Threading model**: All Radare2 C API calls are serialized
onto a single dedicated thread managed by `CoreThreadExecutor`
(a private class in `R2Core.swift`). The public API is `async`
— callers use Swift concurrency while `R2Core.run()`/`runVoid()`
bridge work to the executor thread via
`withCheckedContinuation`. This is the central design
constraint: Radare2 is not thread-safe, so everything goes
through this single-threaded executor.

**Key types**:
- `R2Core` — Main entry point. Wraps `RCore*`, owns the
  executor thread, and exposes `cmd()`, `openFile()`,
  `binLoad()`, and IO plugin registration.
- `R2Config` — Wraps `RConfig*` with typed setters. Shares
  the same executor via a closure, not a direct reference.
- `R2IOProvider` / `R2IOFile` — Sync protocols for custom IO
  plugins (e.g., reading from non-file sources).
- `R2IOAsyncProvider` / `R2IOAsyncFile` — Async variants of
  the IO protocols.
- `R2IOAsyncProviderAdapter` — Bridges async IO providers to
  the sync protocol using `DispatchSemaphore` +
  `Task.detached`.

**Platform-conditional Radare2 target**: `Package.swift` uses
`#if canImport(Darwin)` to select between a `.binaryTarget`
(xcframework) and a `.systemLibrary` target (pkg-config
`r_core`). Both expose the same `Radare2` module name so
the Swift wrapper code is unchanged across platforms. On
non-Apple platforms, `Sources/Radare2/shim.h` pre-includes
`sys/types.h`, `fcntl.h`, and `dirent.h` before `r_core.h`
to prevent `_FILE_OFFSET_BITS=64` struct conflicts with
SwiftGlibc.

**IO plugin system** (`SwiftRIOPlugin.swift`): A single global
`RIOPlugin` (`swiftRIOPlugin`) is registered with Radare2's IO
subsystem. A `PluginManager` (stored in the plugin's `data`
pointer) tracks per-`RIO` state so multiple `R2Core` instances
can each have their own providers. The C callbacks
(`swift_rio_open`, `swift_rio_read`, etc.) dispatch to the
appropriate Swift `R2IOFile` via a `FileBox` wrapper stored in
`RIODesc.data`.
