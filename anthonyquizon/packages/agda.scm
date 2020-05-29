(define-module (anthonyquizon packages agda)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (guix download))


(define-public agda-ial
  (package
    (name "agda-stdlib")
    (version "1.2")
    (home-page #f)
    (source (origin
              (method url-fetch)
              (uri "https://github.com/agda/agda-stdlib/archive/v1.2.tar.gz")
              (sha256
               (base32
                "1b98v6rvn5m1c9k4g81zgw847crw4yxk6ax18iq2xa7qafwv7l2p"))))
    (build-system gnu-build-system)
    (inputs
     `(("agda" ,agda)))
    (arguments
     `(#:parallel-build? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-before 'build 'patch-dependencies
           (lambda _ (patch-shebang "find-deps.sh") #t))
         (delete 'check)
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out     (assoc-ref outputs "out"))
                    (include (string-append out "/include/agda/ial")))
               (for-each (lambda (file)
                           (make-file-writable file)
                           (install-file file include))
                         (find-files "." "\\.agdai?(-lib)?$"))
               #t))))))
    (synopsis "The Iowa Agda Library")
    (description
     "The goal is to provide a concrete library focused on verification
examples, as opposed to mathematics.  The library has a good number
of theorems for booleans, natural numbers, and lists.  It also has
trees, tries, vectors, and rudimentary IO.  A number of good ideas
come from Agda's standard library.")
    (license license:expat)))

