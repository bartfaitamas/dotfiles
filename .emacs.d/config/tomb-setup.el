;; colors
;;(require 'color-theme)
;;(color-theme-charcoal-black)

(transient-mark-mode 1)

(global-font-lock-mode 1)

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

;; browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/home/tbartfai/bin/conkeror")

(setq text-mode-hook 
      (quote (turn-on-auto-fill text-mode-hook-identify)))
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(tool-bar-mode nil)
;(menu-bar-mode nil)
(show-paren-mode 1)
(set-default 'truncate-lines t)

(put 'kill-emacs 'disabled t)
(put 'save-buffers-kill-emacs 'disabled t)

;; shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)