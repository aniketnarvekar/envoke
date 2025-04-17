;;;; env-helper.asd

(asdf:defsystem #:envoke
  :description "Describe env-helper here"
  :author "Aniket Narvekar"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on ("alexandria")
  :components ((:file "package")
               (:file "envoke")))
