(define-module (anthonyquizon packages elastic-stack)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages commencement)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix download))

(define-public elastic-search
    (package
        (name "elastic-search")
        (version "7.10.0")
        (source (origin 
                  (method url-fetch)
                  (uri "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.0-linux-x86_64.tar.gz")
                  (sha256
                    (base32
                        "1fcn9rbz9xyykjrrdiyazqijij4j518bpahw453c28wqjqc8x178"))))
        (build-system trivial-build-system)
        (native-inputs `(("tar" ,tar)
                         ("xz" ,xz)
                         ("gzip" ,gzip)
                         ("coreutils" ,coreutils)))
        (arguments
          '(#:modules
            ((guix build utils))
            #:builder 
            (begin
              (use-modules (guix build utils))
              (let* ([out (assoc-ref %outputs "out")]
                     [source (assoc-ref %build-inputs "source")]
                     [tar (string-append (assoc-ref %build-inputs "tar") "/bin/tar")]
                     [extracted-files "elasticsearch-7.10.0"]

                     ;; Allow tar to find gzip
                     [gzip_path (string-append (assoc-ref %build-inputs "gzip") "/bin")]
                     )
                (mkdir-p out)
                (with-directory-excursion out
                    (setenv "PATH" gzip_path)
                    (invoke tar "xzvf" source)
                    (copy-recursively extracted-files ".")
                    (delete-file-recursively extracted-files))))))
        (synopsis #f)
        (description "elastic search")
        (license #f)
        (home-page #f)))
