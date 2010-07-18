;; colors
(require 'color-theme)
(color-theme-charcoal-black)

(transient-mark-mode 1)

(global-font-lock-mode 1)

;; browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/home/tbartfai/bin/conkeror")

(setq text-mode-hook 
      (quote (turn-on-auto-fill text-mode-hook-identify)))
(tool-bar-mode nil)
;(menu-bar-mode nil)
(show-paren-mode 1)

(put 'kill-emacs 'disabled t)
(put 'save-buffers-kill-emacs 'disabled t)
