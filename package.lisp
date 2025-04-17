;;;; package.lisp

(defpackage #:envoke
  (:use #:cl)
  (:local-nicknames (:alex :alexandria))
  (:export
   #:undefined-env
   #:undefined-env-name
   #:getenv
   #:invoke-set-env-restart))
