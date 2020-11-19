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
  ;; Phobos, druntime and dmd-testsuite library dependencies do
  ;; not always have a newer release than the compiler, hence we
  ;; retain this variable.
  (let ((older-version "1.24.0")) ;; retain this because sometimes the libs are older
    (package
      (inherit ldc-bootstrap)
      (name "ldc")
      (version "1.24.0")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ldc-developers/ldc")
               (commit (string-append "v" version))))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0g5svf55i0kq55q49awmwqj9qi1n907cyrn1vjdjgs8nx6nn35gx"))))
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'unpack-submodule-sources
             (lambda* (#:key inputs #:allow-other-keys)
               (let ((unpack (lambda (input target)
                               (let ((source (assoc-ref inputs input)))
                                 ;; Git checkouts are directories as long as
                                 ;; there are no patches; tarballs otherwise.
                                 (if (file-is-directory? source)
                                     (copy-recursively source target)
                                     (with-directory-excursion target
                                       (invoke "tar" "xvf" source
                                               "--strip-components=1")))))))
                 (unpack "phobos-src" "runtime/phobos")
                 (unpack "druntime-src" "runtime/druntime")
                 (unpack "dmd-testsuite-src" "tests/d2/dmd-testsuite")
                 #t)))
           (add-after 'unpack-submodule-sources 'patch-phobos
             (lambda* (#:key inputs #:allow-other-keys)
               (substitute* '("runtime/phobos/std/process.d"
                              "tests/linking/linker_switches.d")
                 (("/bin/sh") (which "sh"))
                 (("echo") (which "echo")))
               (substitute* "tests/d2/dmd-testsuite/Makefile"
                 (("/bin/bash") (which "bash")))
               ;; disable unittests in the following files. We are discussing with
               ;; upstream
               (substitute* '("runtime/phobos/std/net/curl.d"
                              "runtime/phobos/std/datetime/systime.d"
                              "runtime/phobos/std/datetime/timezone.d"
                              )
                 (("version(unittest)") "version(skipunittest)")
                 ((" unittest") " version(skipunittest) unittest"))
               ;; the following tests require a more recent LLVM
               (delete-file "tests/compilable/ctfe_math.d")
               (delete-file "tests/debuginfo/nested_gdb.d")
               (delete-file "tests/debuginfo/classtypes_gdb.d")
               ;; the following tests plugins we don't have.
               (delete-file "tests/plugins/addFuncEntryCall/testPlugin.d")
               ;; the following tests requires AVX instruction set in the CPU.
               (substitute* "tests/d2/dmd-testsuite/runnable/test_cdvecfill.d"
                 (("^// DISABLED: ") "^// DISABLED: linux64 "))
               #t))
           (replace 'check
             (lambda* (#:key inputs outputs #:allow-other-keys)
               ;; some tests call into gdb binary which needs SHELL and CC set
               (setenv "SHELL" (which "sh"))
               (setenv "CC" (string-append (assoc-ref inputs "gcc") "/bin/gcc"))
               (invoke "make" "test" "-j" (number->string (parallel-job-count))))))))
      (native-inputs
       `(("llvm" ,llvm-6)
         ("clang" ,clang-6)
         ("ldc" ,ldc-bootstrap)
         ("python-lit" ,python-lit)
         ("python-wrapper" ,python-wrapper)
         ("unzip" ,unzip)
         ("gdb" ,gdb)
         ("phobos-src"
          ,(origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/ldc-developers/phobos")
                   (commit (string-append "ldc-v" older-version))))
             (file-name (git-file-name "phobos" older-version))
             (sha256
              (base32 "1gmlwnjdcf6s5aahadxsif9l5nyaj0rrn379g6fmhcvdk64kf509"))
             ;; This patch deactivates some tests that depend on network access
             ;; to pass.  It also deactivates some tests that have some reliance
             ;; on timezone.
             ;;
             ;; For the network tests, there's an effort to get a version flag
             ;; added to deactivate these tests for distribution packagers
             ;; that is being pursued at
             ;; <https://forum.dlang.org/post/zmdbdgnzrxyvtpqafvyg@forum.dlang.org>.
             ;; It also deactivates a test that requires /root
             (patches (search-patches "ldc-disable-phobos-tests.patch"))))
         ("druntime-src"
          ,(origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/ldc-developers/druntime")
                   (commit (string-append "ldc-v" older-version))))
             (file-name (git-file-name "druntime" older-version))
             (sha256
              (base32 "0a3yyjcnpvm5fbdczf76fx08kl154w17w06hlxf0j3p1p4jc85aj"))))
         ("dmd-testsuite-src"
          ,(origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/ldc-developers/dmd-testsuite")
                   (commit (string-append "ldc-v" older-version))))
             (file-name (git-file-name "dmd-testsuite" older-version))
             (sha256
              (base32 "0mm3rliki1nqiqfaha7ssvm156aa398vpvf4v6895m7nn1mz7rss")))))))))


