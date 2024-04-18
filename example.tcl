#
# Example Package build-info TIP 599
#

namespace eval ::example {
  variable pkgPath
}
  
proc ::example::build-info { {cmd {}} } {
  variable pkgPath

  # TIP 599: Extended build information
  # https://core.tcl-lang.org/tips/doc/trunk/tip/599.md

  set file [file join $pkgPath manifest.txt]

  if {[file readable $file] && ![catch {open $file r} fd]} {
    set manifest [read $fd]
    close $fd

    set uuid [dict get $manifest MANIFEST_UUID]
    set checkin [string map {[ {} ] {}} [dict get $manifest MANIFEST_VERSION]]
    set build [dict get $manifest FOSSIL_BUILD_HASH]
    set datetime [string map {{ } T} [dict get $manifest MANIFEST_DATE]]Z
    set version [dict get $manifest RELEASE_VERSION]
    set compiler {tcl.noarch}

    switch -- $cmd {
      commit {
        return $uuid
      }
      version - patchlevel {
        return $version
      }
      compiler {
        return $compiler
      }
      path {
        return $pkgPath
      }
      default {
        return ${version}+${checkin}.${datetime}.${compiler}
      }
    }
  } else {
    return {?.manifest_not_found}
  }
}

package provide example 1.1

set ::example::pkgPath [file dirname [info script]]
