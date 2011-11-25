;; load-paths
(setq load-path (cons "~/share/emacs/site-lisp" load-path))
(setq load-path (cons "~/share/emacs/site-lisp/geben" load-path))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))


(require 'tramp)
(setq tramp-default-method "scp")
;; gnome2-globalmenu workaround
;;(defun ggm-menuupdate () (menu-bar-mode -1) (menu-bar-mode 1))
;;(add-hook 'window-configuration-change-hook 'ggm-menuupdate)

;; interactively do things
(require 'ido)
    (ido-mode t)
    (setq ido-enable-flex-matching t) ;; enable fuzzy matching

(eval-after-load "htmlize"
  '(progn
     (defadvice htmlize-faces-in-buffer (after org-no-nil-faces activate)
       "Make sure there are no nil faces"
       (setq ad-return-value (delq nil ad-return-value)))))

(require 'compile)
(load "~/.emacs.d/config/tomb-setup.el")
(load "~/.emacs.d/config/tomb-org-mode.el")
(load "~/.emacs.d/config/tomb-c-mode.el")
(load "~/.emacs.d/config/tomb-programming.el")
(load "~/.emacs.d/config/tomb-haskell-mode.el")
;;(load "~/.emacs.d/config/tomb-kde.el")
;;(load "~/.emacs.d/config/tomb-sql.el")
;;(load "~/.emacs.d/config/tomb-jabber-mode.el")
;;(load "~/.emacs.d/config/tomb-tile.el")


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
 '(Info-additional-directory-list (quote ("/usr/local/share/info")))
 '(c-default-style (quote ((java-mode . "java") (awk-mode . "awk") (other . "cc-mode"))))
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(gnus-select-method (quote (nntp "news.gmane.org")))
 '(haskell-mode-hook (quote (turn-on-haskell-indent turn-on-haskell-doc-mode turn-on-haskell-ghci turn-on-haskell-indentation turn-on-haskell-doc-mode turn-on-haskell-decl-scan turn-on-font-lock)))
 '(indent-tabs-mode nil)
 '(javascript-indent-level 2)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(mail-user-agent (quote gnus-user-agent))
 '(message-send-mail-function (quote message-smtpmail-send-it))
 '(mumamo-background-chunk-major (quote mumamo-background-chunk-major))
 '(mumamo-heredoc-modes (quote (("HTML" html-mode) ("CSS" css-mode) ("JAVASCRIPT" javascript-mode) ("JS" javascript-mode) ("'JS'" javascript-mode) ("JAVA" java-mode) ("GROOVY" groovy-mode) ("SQL" sql-mode))))
 '(nxhtml-default-encoding (quote utf-8))
 '(nxml-attribute-indent 8)
 '(nxml-child-indent 2)
 '(nxml-outline-child-indent 4)
 '(org-agenda-files (quote ("~/org/hatharom.hu.org" "~/org/timelog.org" "~/org/todo.org")))
 '(read-mail-command (quote gnus))
 '(rspec-spec-command "rspec")
 '(rspec-use-rake-flag nil)
 '(rspec-use-rvm t)
 '(ruby-block-highlight-toggle t)
 '(server-window (quote switch-to-buffer-other-frame))
 '(show-paren-mode t)
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 40) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(speedbar-show-unknown-files t)
 '(sql-ms-options nil)
 '(tab-width 4)
 '(truncate-lines t)
 '(user-full-name "Bártfai Tamás László")
 '(user-mail-address "bartfaitamas@gmail.com")
 '(yas/also-auto-indent-first-line t)
 '(yas/prompt-functions (quote (yas/ido-prompt yas/x-prompt yas/dropdown-prompt yas/completing-prompt yas/no-prompt)))
 '(yas/snippet-dirs (quote ("~/.emacs.d/snippets" "~/share/emacs/site-lisp/yasnippet/snippets")) nil (yasnippet))
 '(yas/wrap-around-region "cua"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "Ubuntu Mono"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) (:background "#3f3f3f"))))
 '(mumamo-background-chunk-submode1 ((((class color) (min-colors 88) (background dark)) (:background "#363636"))))
 '(mumamo-background-chunk-submode2 ((((class color) (min-colors 88) (background dark)) (:background "#2b2b2b"))))
 '(mumamo-background-chunk-submode3 ((((class color) (min-colors 88) (background dark)) (:background "#242424"))))
 '(mumamo-background-chunk-submode4 ((((class color) (min-colors 88) (background dark)) (:background "#1a1a1a"))))
 '(rst-level-1-face ((t nil)) t)
 '(rst-level-2-face ((t nil)) t))

;; Mumamo colors for the charcoal-black theme
 ;;'(default ((t (:inherit nil :stipple nil :background "Grey15" :foreground "Grey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "Droid Sans Mono"))))
 ;;'(mumamo-background-chunk-major ((t (:background "Grey15"))))
 ;;'(mumamo-background-chunk-submode1 ((t (:background "Grey20"))))
 ;;'(mumamo-background-chunk-submode2 ((t (:background "DarkSlateBlue"))))
 ;;'(mumamo-background-chunk-submode3 ((t (:background "DarkOliveGreen"))))
 ;;'(mumamo-background-chunk-submode4 ((((class color) (min-colors 88) (background dark)) (:background "SaddleBrown")))))


;;; Emacs/W3 Configuration
(setq load-path (cons "/home/tomb/share/emacs/site-lisp" load-path))
(condition-case () (require 'w3-auto "w3-auto") (error nil))
(put 'upcase-region 'disabled nil)
