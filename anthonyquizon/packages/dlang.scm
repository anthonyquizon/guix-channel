(define-module (anthonyquizon packages dlang)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages commencement)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix download))




(define-public dmd
    (package
      (name "dmd")
      (version "2.092.0")
      (source (origin
                (method url-fetch)
                (uri "http://downloads.dlang.org/releases/2.x/2.092.0/dmd.2.092.0.linux.tar.xz")
                (sha256
                  (base32
                    "0qklprl44mcwjj1p49166wrl4jml7b52ylyvv8bhh8w38cz6cs1h"))))
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
                     [include (string-append out "/include")]
                     [config (string-append bin "/dmd.conf")]
                     [source (assoc-ref %build-inputs "source")]
                     [tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar")]
                     [ls (string-append (assoc-ref %build-inputs "coreutils") "/bin/ls")]
                     [mv (string-append (assoc-ref %build-inputs "coreutils") "/bin/mv")]
                     [extract-path "dmd2"]
                     [extracted-bin (string-append extract-path "/linux/bin64/")]
                     [extracted-lib (string-append extract-path "/linux/lib64/")]
                     [extracted-include (string-append extract-path "/src")]

                     [config-body (string-append "[Environment64]\n"
                                    "DFLAGS=-I%@P%/../include/phobos -I%@P%/../include/druntime/import -L-L%@P%/../lib -L--export-dynamic -fPIC")]
                     ;; Allow tar to find gzip
                     [xz_path (string-append (assoc-ref %build-inputs "xz") "/bin")])
                        (mkdir-p out)

                        (with-directory-excursion out
                            (setenv "PATH" xz_path)
                            (invoke tar "xvf" source)
                            (invoke mv extracted-bin bin)
                            (invoke mv extracted-lib lib)
                            (invoke mv extracted-include include)
                            (let ([port (open-file config "w")])
                                (display config-body port)
                                (close-port port)))))))
      (synopsis #f)
      (description "precompiled x86_64 version of dmd")
      (license #f)
      (home-page #f)))


(define-public dub
    (package
      (name "dub")
      (version "1.21.0")
      (source (origin
                (method url-fetch)
                (uri "https://github.com/dlang/dub/releases/download/v1.21.0/dub-v1.21.0-linux-x86_64.tar.gz")
                (sha256
                  (base32
                    "1pipxf9b0b4cnvbr418azd4npw07x8dbidf1fck4drbgk4c920xi"))))
      (build-system trivial-build-system)
      (native-inputs `(("tar" ,tar)
                       ("gzip" ,gzip)
                       ("coreutils" ,coreutils)))
      (arguments
        '(#:modules
          ((guix build utils))
          #:builder
          (begin
              (use-modules (guix build utils))
              (let* ([out (assoc-ref %outputs "out")]
                     [bin (string-append out "/bin")]
                     [source (assoc-ref %build-inputs "source")]
                     [tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar")]
                     [ls (string-append (assoc-ref %build-inputs "coreutils") "/bin/ls")]
                     [mv (string-append (assoc-ref %build-inputs "coreutils") "/bin/mv")]
                     ;; Allow tar to find gzip
                     [gzip_path (string-append (assoc-ref %build-inputs "gzip") "/bin")])
                        (mkdir-p out)
                        (mkdir-p bin)

                        (with-directory-excursion out
                            (setenv "PATH" gzip_path)
                            (invoke tar "xvf" source "--directory" bin))))))
      (synopsis #f)
      (description "precompiled x86_64 version of dub")
      (license #f)
      (home-page #f)))

(define-public ldc
    (package
      (name "ldc")
      (version "1.24.0")
      (source (origin
                (method url-fetch)
                (uri "https://github.com/ldc-developers/ldc/releases/download/v1.24.0/ldc2-1.24.0-linux-x86_64.tar.xz")
                (sha256
                  (base32
                    "18rbi449yh4zxr77d6yjz990034jiajq565ibygm81hbx47hg3l6"))))
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
                     [etc (string-append out "/etc")]
                     [import (string-append out "/import")]
                     ;[config (string-append etc "/ldc2.conf")]

                     [source (assoc-ref %build-inputs "source")]

                     [tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar")]
                     [ls (string-append (assoc-ref %build-inputs "coreutils") "/bin/ls")]
                     [mv (string-append (assoc-ref %build-inputs "coreutils") "/bin/mv")]
                     [extract-path "ldc2-1.24.0-linux-x86_64"]

                     [extracted-bin (string-append extract-path "/bin/")]
                     [extracted-lib (string-append extract-path "/lib/")]
                     [extracted-etc (string-append extract-path "/etc/")]
                     [extracted-import (string-append extract-path "/import")]
                     
                     ;[config-body (string-append "[Environment64]\n"
                                    ;"DFLAGS=-I%@P%/../include/phobos -I%@P%/../include/druntime/import -L-L%@P%/../lib -L--export-dynamic -fPIC")]

                     ;; Allow tar to find gzip
                     [xz_path (string-append (assoc-ref %build-inputs "xz") "/bin")])
                        (mkdir-p out)

                        (with-directory-excursion out
                            (setenv "PATH" xz_path)
                            (invoke tar "xvf" source)
                            (invoke mv extracted-bin bin)
                            (invoke mv extracted-lib lib)
                            (invoke mv extracted-etc etc)
                            (invoke mv extracted-import import)
                            ;(let ([port (open-file config "w")])
                                ;(display config-body port)
                                ;(close-port port))     
                            )))))
      (synopsis #f)
      (description "precompiled x86_64 version of dmd")
      (license #f)
      (home-page #f)))

