(load "/usr/share/common-lisp/source/slime/swank-loader.lisp")
(swank-loader:init)

(defcommand swank (&optional port) ()
 (setf stumpwm:*top-level-error-action* :break)
  (swank:create-server :port (or port 4006)
                       :style swank:*communication-style*
                       :dont-close t)
  (message "Starting swank."))
(define-key *root-map* (kbd "C-s") "swank")
