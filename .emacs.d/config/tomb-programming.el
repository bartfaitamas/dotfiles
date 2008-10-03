;; settings related to programming modes
;; js2
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; -----------------------------------------------------------------------------
;; GIT
;; -----------------------------------------------------------------------------
;;(load "/usr/share/doc/git-core/contrib/emacs/git.el" t)
;;(load "/usr/share/doc/git-core/contrib/emacs/git-blame.el" t)
;;(load "/usr/share/doc/git-core/contrib/emacs/vc-git.el" t)
(add-to-list 'vc-handled-backends 'GIT)

;; -----------------------------------------------------------------------------
;; Ruby
;; -----------------------------------------------------------------------------
(setq ri-ruby-script "/home/tbartfai/bin/ri-emacs.rb")
(autoload 'ri "/home/tbartfai/share/emacs/site-lisp/ri-ruby.el" nil t)