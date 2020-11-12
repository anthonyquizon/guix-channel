(define-module helpers
    #:use-module (guix store)
    #:use-module (guix derivations)
    #:use-module (guix packages))

(define (build-packages packages)
  (with-store store
              (let ((builds (map (lambda (package)
                                   (package-derivation store package))
                                 packages)))
                (build-derivations store builds))))

(define (build-package package)
  (build-packages (list package)))
