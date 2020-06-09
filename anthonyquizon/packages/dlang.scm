(define-module (anthonyquizon packages dlang)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix download))



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
                     [extract-path "dub-v1.21.0-linux-x86_64"]
                     ;; Allow tar to find gzip
                     [gzip_path (string-append (assoc-ref %build-inputs "gzip") "/bin")])
                        (mkdir-p out)

                        (with-directory-excursion out
                            (setenv "PATH" gzip_path)
                            (invoke tar "xvf" source "--directory" out))))))
      (synopsis #f)
      (description "precompiled x86_64 version of dub")
      (license #f)
      (home-page #f)))

