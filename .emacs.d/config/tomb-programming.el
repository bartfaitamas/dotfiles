;; altalanos setup programozasi modokhoz

(setq column-number-mode t)
(setq indent-tabs-mode nil)
(setq show-parent-mode t)

;; =================================================================================================
;; owl mode
;; =================================================================================================
(setq load-path (append '("~/Programok/Emacs/owl/emacs/owl/" 
                          "~/share/emacs/site-lisp/rinari"
                          "~/share/emacs/site-lisp/feature-mode"
                          "~/share/emacs/site-lisp") load-path))
(autoload 'owl-mode "owl-mode" "OWL mode." t)

;; -----------------------------------------------------------------------------
;; yasnippets
;; -----------------------------------------------------------------------------
(add-to-list 'load-path "~/share/emacs/site-lisp/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/share/emacs/site-lisp/yasnippet/snippets")
(yas/load-directory "~/.emacs.d/snippets")
(yas/load-directory "~/.emacs.d/mysnippets")
(yas/define-snippets 'nxhtml-mode nil 'html-mode)

;; -----------------------------------------------------------------------------
;; geben debugger (for Xdebug)
;; -----------------------------------------------------------------------------
(autoload 'geben "geben" "PHP Debugger on Emacs" t)
;; -----------------------------------------------------------------------------
;; magic php mode
;; -----------------------------------------------------------------------------
;;(setq magic-fallback-mode-alist
;;      (cons '("<\\?php" . php-mode)
;;	    magic-fallback-mode-alist))

(autoload 'n3-mode "n3-mode" "Major mode for OWL or N3 files" t)

;; Turn on font lock when in n3 mode
(add-hook 'n3-mode-hook
          'turn-on-font-lock)


;; =================================================================================================
;; cucumber.el aka feature mode
;; =================================================================================================
;;;; optional configurations
;;;; default language if .feature doesn't have "# language: fi"
;;;(setq feature-default-language "hu")
;;(setq feature-default-language "en")
;;;; point to cucumber languages.yml or gherkin i18n.yml to use
;;;; exactly the same localization your cucumber uses
;;;(setq feature-default-i18n-file "/path/to/gherkin/gem/i18n.yml")
;;(setq feature-default-i18n-file "/usr/lib/ruby/gems/1.8/gems/gherkin-2.3.8/lib/gherkin/i18n.yml")
;;;; and load feature-mode
;;(require 'feature-mode)

;; =================================================================================================
;; cmake
;; =================================================================================================
(defun cmake-rename-buffer ()
  "Renames a CMakeLists.txt buffer to cmake-<directory name>."
  (interactive)
  ;(print (concat "buffer-filename = " (buffer-file-name)))
  ;(print (concat "buffer-name     = " (buffer-name)))
  (when (and (buffer-file-name) (string-match "CMakeLists.txt" (buffer-name)))
    ;(setq file-name (file-name-nondirectory (buffer-file-name)))
    (setq parent-dir (file-name-nondirectory (directory-file-name (file-name-directory (buffer-file-name)))))
    ;(print (concat "parent-dir = " parent-dir))
    (setq new-buffer-name (concat "cmake-" parent-dir))
    ;(print (concat "new-buffer-name = " new-buffer-name))
    (rename-buffer new-buffer-name t)
    )
)
(add-hook 'cmake-mode-hook (function cmake-rename-buffer))


(load "~/share/emacs/site-lisp/nxhtml/autostart.el")
(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)


;; =================================================================================================
;; haml es sass mode
;; =================================================================================================
(require 'haml-mode)
(require 'sass-mode)

;; =================================================================================================
;; ruby stuff
;; =================================================================================================
;;(require 'ruby-block)
;;(ruby-block-mode t)
;;(setq ruby-block-highlight-toggle t)

(setq auto-mode-alist
      (append
       (list
        '("\\.n3" . n3-mode)
        '("\\.owl" . n3-mode)
        '("\\.nt" . n3-mode)
        '("\\.textile$" . textile-mode)
        '("\\.md$" . markdown-mode)
;;        '("\\.feature$" . feature-mode)
        '("\\.yml$" . yaml-mode)
        '("\\.scss$" . sass-mode)
        '("\\.js$" . js-mode)
        '("\\.json$" . js-mode)
        '("\\.html\\.erb$" . eruby-nxhtml-mumamo-mode)
        '("Gemfile" . ruby-mode)
        '("\\.xml$" . nxml-mumamo-mode)
        '("\\.twig$" . django-nxhtml-mumamo))
       auto-mode-alist))

