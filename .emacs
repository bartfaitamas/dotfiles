;; load-paths
(setq load-path (cons "~/share/emacs/site-lisp" load-path))
(setq load-path (cons "~/Download/emacs/org-mode/org-mode/lisp" load-path))

(load "~/.emacs.d/config/tomb-setup.el")
(load "~/.emacs.d/config/tomb-org.el")
(load "~/.emacs.d/config/tomb-programming.el")



(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(haskell-doc-show-global-types t)
 '(org-agenda-files (quote ("~/org/openadm.org" "~/org/tukir.org" "~/org/npsh.org" "~/org/timelog.org" "~/org/openadm.org_archive" "~/org/nka.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

