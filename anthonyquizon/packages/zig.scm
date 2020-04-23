(define-module (anthonyquizon packages zig)
  #:use-module (guix build-system trivial)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (guix download))

;; REFERENCE: https://www.reddit.com/r/GUIX/comments/desnjc/dirty_install_for_precompiled_binaries/

(define-public zig
    (package
      (name "zig")
      (version "0.6.0")

      (source (origin
                (method url-fetch)
                (uri "https://ziglang.org/download/0.6.0/zig-linux-x86_64-0.6.0.tar.xz")
                (sha256
                  (base32 
                    "0lqjvkh5vx493g74zwa41h1988lw5qv749qw8i2hcqv3g5skrz88"))))
      (build-system trivial-build-system)
      (native-inputs `(("tar" ,tar)
                       ("xz" ,xz)
                       ("coreutils" ,coreutils)))
      (arguments
        '(#:modules 
          ((guix build utils))
          #:builder 
          (begin 
              (use-modules (guix build utils))
              (let* ([out (assoc-ref %outputs "out")]
                     [bin (string-append out "/bin")]
                     [lib (string-append out "/lib")]
                     [share (string-append out "/share")]
                     [source (assoc-ref %build-inputs "source")]
                     [tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar")]
                     [ls (string-append (assoc-ref %build-inputs "coreutils") "/bin/ls")]
                     [mv (string-append (assoc-ref %build-inputs "coreutils") "/bin/mv")]
                     [extract-path "zig-linux-x86_64-0.6.0"]
                     [PATH (string-append (assoc-ref %build-inputs "xz") "/bin")])
                        (mkdir-p out)
                        (mkdir-p bin)
                        (mkdir-p lib)

                        (with-directory-excursion out 
                            (setenv "PATH" PATH)

                            (invoke tar "xvf" source)
                            (invoke mv (string-append extract-path "/zig") bin)
                            (invoke mv (string-append extract-path "/lib/zig/include") out)
                            (invoke mv (string-append extract-path "/lib/zig/libc") lib)
                            (invoke mv (string-append extract-path "/lib/zig/libcxx") lib)
                            (invoke mv (string-append extract-path "/lib/zig/libcxxabi") lib)
                            (invoke mv (string-append extract-path "/lib/zig/libunwind") lib)
                            (invoke mv (string-append extract-path "/lib/zig/std") lib))))))
      (synopsis #f)
      (description #f)
      (license #f)
      (home-page #f)))
