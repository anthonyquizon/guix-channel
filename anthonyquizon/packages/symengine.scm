(define-module (anthonyquizon packages symengine)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages ed)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages fltk)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages image)
  #:use-module (gnu packages java)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system ant)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix hg-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public symengine
  (package
    (name "symengine")
    (version "0.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/symengine/symengine")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "129iv9maabmb42ylfdv0l0g94mcbf3y4q3np175008rcqdr8z6h1"))))
    (build-system cmake-build-system)
    (arguments
     '(#:configure-flags
       ;; These are the suggested build options in the README.
       '("-DCMAKE_BUILD_TYPE=Release"
         "-DWITH_GMP=on"
         "-DWITH_MPFR=on"
         "-DWITH_MPC=on"
         "-DINTEGER_CLASS=flint"
         "-DWITH_LLVM=on"
         "-DWITH_SYMENGINE_THREAD_SAFE=on"
         "-DBUILD_SHARED_LIBS=on")))    ;also build libsymengine
    (native-inputs
     `(("llvm" ,llvm)))
    (inputs
     `(("flint" ,flint)
       ("gmp" ,gmp)
       ("mpc" ,mpc)
       ("mpfr" ,mpfr)))
    (home-page "https://github.com/symengine/symengine")
    (synopsis "Fast symbolic manipulation library")
    (description
     "SymEngine is a standalone fast C++ symbolic manipulation library.
Optional thin wrappers allow usage of the library from other languages.")
    (license (list license:expat        ;SymEngine
                   license:bsd-3))))    ;3rd party code

