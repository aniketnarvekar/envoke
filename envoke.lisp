;;;; env-helper.lisp

(in-package #:envoke)

(define-condition undefined-env (error)
  ((name :reader undefined-env-name
         :initarg :name
         :type string
         :documentation "The environment variable name."))
  (:report (lambda (condition stream)
             (format stream "The named variable ~s is either not present in libc
environment or is an empty string." (undefined-env-name condition))))
  (:documentation "An object indicates undefined environment variable and
encapsulates the information of the environment variable."))

(defun undefined-env-p (an-object)
  "Return T if AN-OBJECT is of type `undefined-env'."
  (typep an-object 'undefined-env))

;;; Setter

(defun (setf getenv) (new-value name)
  "Sets NEW-VALUE `string' to environment variable NAME."
  (setf (uiop:getenv name) new-value))

;;; UNDEFINED-ENV restarts


(defmacro with-block (&body body)
  "The macro creates a block and executes the BODY within that scope. The
macro also defines an internal function `block-return', which takes a
single value. On call, it returns given value from the block."
  (alex:with-gensyms (blk)
    `(block ,blk
       (flet ((block-return (value)
                (return-from ,blk value)))
         ,@body))))

(defmacro with-undefined-env-restart (name &body body)
  (alex:with-gensyms (var)
    `(with-block
       (let ((,var ,name))
         (flet ((set-env (new-value)
                  (setf (getenv ,var) new-value)
                  (block-return (check-env ,var)))
                (set-env-report (stream)
                  (format stream "Set environment variable ~s" ,var))
                (set-env-interactive ()
                  (prompt-new-value
                   (format nil "Enter value for environment variable ~s: " ,var))))
           (restart-bind ((set-env
                            #'set-env
                            :report-function #'set-env-report
                            :test-function #'undefined-env-p
                            :interactive-function #'set-env-interactive))
             ,@body))))))

;;; Invoke restart

(defun invoke-set-env-restart (condition new-value)
  "Invoke SET-ENV restart for given CONDITION with NEW-VALUE."
  (alex:when-let ((restart (find-restart 'set-env condition)))
    (invoke-restart restart new-value)))

;;; Check

(defun prompt-new-value (prompt)
  "The function prints given PROMPT and require user input. The function
return a list of single value user input of type `string'.

The function uses `*query-io*' object to output the prompt and read
response of it."
  (format *query-io* prompt) ;; *query-io*: the special stream to make user queries.
  (force-output *query-io*)  ;; Ensure the user sees what he types.
  (list (read-line *query-io* nil "")))  ;; We must return a list.

(defun check-env (name)
  "Check if the value for the given environment variable NAME is present or not.

If the value of the given environment variable NAME is NIL or an empty string,
then the function will raise the `undefined-env' condition.

If the `undefined-env' condition is raised, the function provides two restarts:
1. SET-ENV

The SET-ENV allows interactively setting values for a given environment
variable."
  (unless (uiop:getenvp name)
    (with-undefined-env-restart name
      (error 'undefined-env :name name)))
  (values))

;;; Getter

(defun getenv (name)
  "Return the `string' value of the given environment variable NAME.

The function uses the `check-env' function to ensure the value is
present or raise an error.

See `check-env' documentation for more information."
  (check-env name)
  (uiop:getenv name))
