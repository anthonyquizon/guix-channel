(define-module (anthonyquizon packages node)
  #:use-module ((guix licenses) #:select (expat))
  #:use-module ((guix build utils) #:select (alist-replace))
  #:use-module (guix packages)
  #:use-module (guix derivations)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module ((gnu packages node) #:prefix gnu-node:)
  #:use-module (gnu packages)
  #:use-module (gnu packages adns)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web))

(define-public node-14.15
    (package
      (inherit gnu-node:node)
      (version "14.15.1")
      (source 
        (origin
          (inherit (package-source gnu-node:node))
          (uri (string-append "https://nodejs.org/dist/v" version
                              "/node-v" version ".tar.xz"))
          (sha256
            (base32
              "1g61vqsgq3jsipw2fckj68i4a4pi1iz1kbw7mlw8jmzp8rl46q81"))))
      (inputs
        (alist-replace "nghttp2" (list nghttp2-1.41 "lib")
                       (package-inputs gnu-node:node)))))

