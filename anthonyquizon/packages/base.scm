(define-module (anthonyquizon packages base)
  #:use-module (gnu packages)
  #:use-module (gnu packages base))

(define-public foo
  (package
    (name "foo")



    ;(inherit binutils)
    ;(arguments
     ;`(#:phases
       ;(modify-phases %standard-phases
         ;(add-after 'patch-source-shebangs 'patch-more-shebangs
           ;(lambda _
             ;(substitute* "gold/Makefile.in"
               ;(("/bin/sh") (which "sh")))
             ;#t)))
       ;,@(substitute-keyword-arguments (package-arguments binutils)
         ;((#:tests? _ #f) #f)
         ;((#:configure-flags flags)
          ;`(cons* "--enable-gold=default"
                  ;(delete "LDFLAGS=-static-libgcc" ,flags))))))
    ;(native-inputs
     ;`(("bc" ,bc)))
    ;(inputs
     ;`(("gcc:lib" ,gcc "lib")))
    
    )
  

  )

;(define-public hello
  ;(package
    ;(name "hello")
    ;(version "2.10")
    ;(source (origin
              ;(method url-fetch)
              ;(uri (string-append "mirror://gnu/hello/hello-" version
                                  ;".tar.gz"))
              ;(sha256
               ;(base32
                ;"0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i"))))
    ;(build-system gnu-build-system)
    ;(synopsis "Hello, GNU world: An example GNU package")
    ;(description
     ;"GNU Hello prints the message \"Hello, world!\" and then exits.  It
;serves as an example of standard GNU coding practices.  As such, it supports
;command-line arguments, multiple languages, and so on.")
    ;(home-page "https://www.gnu.org/software/hello/")
    ;(license gpl3+)))
