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
  #:use-module (guix build-system trivial)
  #:use-module (guix download))



(define-public dub
    (package
      (name "zig")
      (version "1.21.0")
      (source (origin
                (method url-fetch)
                (uri "https://github.com/dlang/dub/releases/download/v1.21.0/dub-v1.21.0-linux-x86_64.tar.gz")
                (sha256
                  (base32
                    "1pipxf9b0b4cnvbr418azd4npw07x8dbidf1fck4drbgk4c920xi"))))
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
                     [source (assoc-ref %build-inputs "source")]
                     [tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar")]
                     [ls (string-append (assoc-ref %build-inputs "coreutils") "/bin/ls")]
                     [mv (string-append (assoc-ref %build-inputs "coreutils") "/bin/mv")]
                     [extract-path "dub-v1.21.0-linux-x86_64.tar.gz"]
                     [PATH (string-append (assoc-ref %build-inputs "xz") "/bin")])
                        (mkdir-p out)
                        (mkdir-p bin)

                        (with-directory-excursion out
                            (setenv "PATH" PATH)

                            (invoke tar "xvf" source)
                            (invoke mv (string-append extract-path "/dub") bin))))))
      (synopsis #f)
      (description #f)
      (license #f)
      (home-page #f)))

