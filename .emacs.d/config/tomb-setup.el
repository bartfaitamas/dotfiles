;; colors
;(require 'color-theme)
;(color-theme-charcoal-black)

(setq load-path
      (append '(
       "~/share/emacs/site-lisp"
       "~/share/emacs/site-lisp/geben"
       "~/.emacs.d/site-lisp"
       "/usr/share/doc/git-core/contrib/emacs"
        "/usr/local/share/emacs/site-lisp")
       load-path))

(global-font-lock-mode 1)


(setq text-mode-hook 
      (quote (turn-on-auto-fill text-mode-hook-identify)))
(tool-bar-mode nil)
;(menu-bar-mode nil)
(show-paren-mode 1)

(put 'kill-emacs 'disabled t)
(put 'save-buffers-kill-emacs 'disabled t)


;; truncate long lines
(set-default 'truncate-lines t)

;; UI
;;(require 'color-theme)
;;(color-theme-charcoal-black)
;;(color-theme-initialize)
;;(color-theme-emacs-21)
;; colorful shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(setq transient-mark-mode t)
(setq use-file-dialog nil)

;; 3rd party programs
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/usr/bin/conkeror")
