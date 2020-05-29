(define-module (anthonyquizon packages dlang)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages base)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages dlang)
  #:use-module (gnu packages compression)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix download))

(define-public dub
    (package
      (name "dub")
      (version "1.21.0")
      (source
        (origin
          (method git-fetch)
          (uri (git-reference
                 (url "https://github.com/dlang/dub.git")
                 (commit (string-append "v" version))))
          (file-name (git-file-name name version))
          (sha256
            (base32 "1r8iili2bc8d2pwy9jpibjkbzn19kbxkxc07n5zn6smaya2i747f"))))
      (build-system gnu-build-system)
      (arguments
        `(#:tests? #f ; it would have tested itself by installing some packages (vibe etc)
          #:phases
          (modify-phases %standard-phases
                         (delete 'configure)            ; no configure script
                         (replace 'build
                                  (lambda _
                                    (invoke "./build.sh")))
                         (replace 'install
                                  (lambda* (#:key outputs #:allow-other-keys)
                                           (let* ((out (assoc-ref outputs "out"))
                                                  (bin (string-append out "/bin")))
                                             (install-file "bin/dub" bin)
                                             #t))))))
      (inputs
        `(("curl" ,curl)))

      (native-inputs
        `(("ldc" ,ldc)))

      (home-page "https://code.dlang.org/getting_started")
      (synopsis "Package and build manager for D projects")
      (description
        "DUB is a package and build manager for applications and
        libraries written in the D programming language.  It can
        automatically retrieve a project's dependencies and integrate
        them in the build process.

        The design emphasis is on maximum simplicity for simple projects,
        while providing the opportunity to customize things when
        needed.")
        (license license:expat)))

