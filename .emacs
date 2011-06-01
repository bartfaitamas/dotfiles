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

;;(load-library "zeitgeist")

;; ========================================================
;; sr-speedbar
;; ========================================================
;; (require 'sr-speedbar)

;; (setq speedbar-frame-parameters
;;       '((minibuffer)
;; 	(width . 60)
;; 	(border-width . 0)
;; 	(menu-bar-lines . 0)
;; 	(tool-bar-lines . 0)
;; 	(unsplittable . t)
;; 	(left-fringe . 0)))
;; (setq speedbar-hide-button-brackets-flag t)
;; (setq speedbar-show-unknown-files t)
;; (setq speedbar-smart-directory-expand-flag t)
;; (setq speedbar-use-images nil)
;; (setq sr-speedbar-auto-refresh nil)
;; (setq sr-speedbar-max-width 70)
;; (setq sr-speedbar-right-side nil)
;; (setq sr-speedbar-width-console 40)

;; (when window-system
;;   (defadvice sr-speedbar-open (after sr-speedbar-open-resize-frame activate)
;;     (set-frame-width (selected-frame)
;;                      (+ (frame-width) sr-speedbar-width)))
;;   (ad-enable-advice 'sr-speedbar-open 'after 'sr-speedbar-open-resize-frame)

;;   (defadvice sr-speedbar-close (after sr-speedbar-close-resize-frame activate)
;;     (sr-speedbar-recalculate-width)
;;     (set-frame-width (selected-frame)
;;                      (- (frame-width) sr-speedbar-width)))
;;   (ad-enable-advice 'sr-speedbar-close 'after 'sr-speedbar-close-resize-frame))

;; (global-set-key (kbd "C-c C-s s") 'sr-speedbar-toggle)
;; (global-set-key (kbd "C-c C-s w") 'sr-speedbar-select-window)
;; ========================================================
;; ========================================================


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

;;(require 'yasnippet) loaded by ubuntu package
;;(yas/load-directory "~/.emacs.d/snippets")
;;(yas/load-directory "~/.emacs.d/mysnippets")

(load "~/.emacs.d/config/tomb-setup.el")
(load "~/.emacs.d/config/tomb-org.el")
(load "~/.emacs.d/config/tomb-programming.el")
;;(load "~/.emacs.d/config/tomb-sql.el")
;;(require 'ledger)

;; some experimental
(require 'notify)
(require 'dbus)
(defun tbartfai/check-org-clock-and-notify ()
  "Checks whether there is a running clock in org-mode, and if there's none, sends a notfication"
  (unless (org-clock-is-active)
        (notify "Nincs task" "Nincs futo task, nem tudjuk merni, mit csinalunk"))
)

;;(when window-system
;;  (run-at-time nil 300 'tbartfai/check-org-clock-and-notify)
;;)

(color-theme-initialize)
(color-theme-charcoal-black)
;; '(color-theme-selection "Charcoal Black" nil (color-theme_seldefcustom))
;; '(js-indent-level 2)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list (quote ("/usr/local/share/info")))
 '(c-default-style (quote ((java-mode . "java") (awk-mode . "awk") (other . "cc-mode"))))
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(haskell-doc-show-global-types t)
 '(indent-tabs-mode nil)
 '(mail-user-agent (quote gnus-user-agent))
 '(message-send-mail-function (quote message-smtpmail-send-it))
 '(mumamo-background-chunk-major (quote mumamo-background-chunk-major))
 '(mumamo-heredoc-modes (quote (("HTML" html-mode) ("CSS" css-mode) ("JAVASCRIPT" javascript-mode) ("JS" javascript-mode) ("'JS'" javascript-mode) ("JAVA" java-mode) ("GROOVY" groovy-mode) ("SQL" sql-mode))))
 '(nxhtml-default-encoding (quote utf-8))
 '(nxml-attribute-indent 8)
 '(nxml-child-indent 4)
 '(nxml-outline-child-indent 4)
 '(org-agenda-files (quote ("~/org/hatharom.hu.org" "~/org/timelog.org" "~/org/todo.org")))
 '(read-mail-command (quote gnus))
 '(server-window (quote switch-to-buffer-other-frame))
 '(show-paren-mode t)
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 40) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(speedbar-show-unknown-files t)
 '(sql-ms-options nil)
 '(tab-width 4)
 '(truncate-lines t)
 '(user-mail-address "bartfaitamas@gmail.com")
 '(yas/also-auto-indent-first-line t)
 '(yas/prompt-functions (quote (yas/ido-prompt yas/x-prompt yas/dropdown-prompt yas/completing-prompt yas/no-prompt))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "Grey15" :foreground "Grey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "Droid Sans Mono"))))
 '(mumamo-background-chunk-major ((t (:background "Grey15"))))
 '(mumamo-background-chunk-submode1 ((t (:background "Grey20"))))
 '(mumamo-background-chunk-submode2 ((t (:background "DarkSlateBlue"))))
 '(mumamo-background-chunk-submode3 ((t (:background "DarkOliveGreen"))))
 '(mumamo-background-chunk-submode4 ((((class color) (min-colors 88) (background dark)) (:background "SaddleBrown")))))


