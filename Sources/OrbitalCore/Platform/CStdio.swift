// Platform-safe wrappers for C stdio globals.
// On Linux (Glibc), stdout/stderr are mutable globals that Swift 6 flags as unsafe.
// These wrappers avoid the concurrency diagnostic at each call site.

import Foundation

#if canImport(Darwin)
import Darwin
#else
@preconcurrency import Glibc
#endif

@inline(__always)
func flushStdout() {
    fflush(stdout)
}

@inline(__always)
func writeStderr(_ message: String) {
    fputs(message, stderr)
}
