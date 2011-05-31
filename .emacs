;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;; ido-mode is cool
(ido-mode)

(load "~/.emacs.d/config/tomb-setup.el")
(load "~/.emacs.d/config/tomb-org-mode.el")
(load "~/.emacs.d/config/tomb-c-mode.el")
(load "~/.emacs.d/config/tomb-programming.el")
(load "~/.emacs.d/config/tomb-haskell-mode.el")
;;(load "~/.emacs.d/config/tomb-kde.el")
;;(load "~/.emacs.d/config/tomb-sql.el")
;;(load "~/.emacs.d/config/tomb-jabber-mode.el")
(load "~/.emacs.d/config/tomb-tile.el")

;; =================================================================================================
;; ledger
;; =================================================================================================
;;(require 'ledger)

;; -- globalmenu workaround
;;(defun menuupdate () (menu-bar-mode -1) (menu-bar-mode 1))
;;(add-hook 'window-configuration-change-hook 'menuupdate)
;; =================================================================================================
;; CUSTOM
;; =================================================================================================
;; '(c-default-style (quote ((c-mode . "bsd") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
;; '(c-offsets-alist (quote ((substatement-open . 0))))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(gnus-select-method (quote (nntp "news.gmane.org")))
 '(haskell-mode-hook (quote (turn-on-haskell-indent turn-on-haskell-doc-mode turn-on-haskell-ghci turn-on-haskell-indentation turn-on-haskell-doc-mode turn-on-haskell-decl-scan turn-on-font-lock)))
 '(indent-tabs-mode nil)
 '(mumamo-heredoc-modes (quote (("HTML" html-mode) ("CSS" css-mode) ("JAVASCRIPT" javascript-mode) ("JS" javascript-mode) ("JAVA" java-mode) ("GROOVY" groovy-mode) ("SQL" sql-mode))))
 '(show-paren-mode t)
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 30) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(speedbar-show-unknown-files t)
 '(tab-width 4)
 '(user-full-name "Bártfai Tamás László")
 '(user-mail-address "bartfai.tamas@gmail.com")
 '(yas/also-auto-indent-first-line t)
 '(yas/prompt-functions (quote (yas/ido-prompt yas/x-prompt yas/dropdown-prompt yas/completing-prompt yas/no-prompt)))
 '(yas/root-directory (quote ("~/.emacs.d/snippets" "/usr/share/emacs/site-lisp/yasnippet/snippets")) nil (yasnippet))
 '(yas/wrap-around-region "cua"))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Inconsolata")))))



;;; Emacs/W3 Configuration
(setq load-path (cons "/home/tomb/share/emacs/site-lisp" load-path))
(condition-case () (require 'w3-auto "w3-auto") (error nil))
