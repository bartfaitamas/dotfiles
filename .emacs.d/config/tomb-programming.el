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

;; =================================================================================================
;; n3 mode
;; =================================================================================================
;;(add-to-list 'load-path "{path}/n3-mode.el")
(autoload 'n3-mode "n3-mode" "Major mode for OWL or N3 files" t)

;; Turn on font lock when in n3 mode
(add-hook 'n3-mode-hook
          'turn-on-font-lock)


;; =================================================================================================
;; cucumber.el aka feature mode
;; =================================================================================================
;; optional configurations
;; default language if .feature doesn't have "# language: fi"
;(setq feature-default-language "hu")
(setq feature-default-language "en")
;; point to cucumber languages.yml or gherkin i18n.yml to use
;; exactly the same localization your cucumber uses
;(setq feature-default-i18n-file "/path/to/gherkin/gem/i18n.yml")
(setq feature-default-i18n-file "/usr/lib/ruby/gems/1.8/gems/gherkin-2.3.8/lib/gherkin/i18n.yml")
;; and load feature-mode
(require 'feature-mode)



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

;; =================================================================================================
;; magic php mode
;; =================================================================================================
(setq magic-fallback-mode-alist
      (cons '("<\\?php" . php-mode)
	    magic-fallback-mode-alist))
(autoload 'geben "geben" "DBGp protocol frontend, a script debugger" t)
;; =================================================================================================
;; yasnippets
;; =================================================================================================
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/snippets")
(yas/load-directory "~/Development/Emacs/snippets")

;; =================================================================================================
;; rinari and rails
;; =================================================================================================
(require 'yaml-mode)

(require 'rinari)
;;(setq rinari-tags-file-name "TAGS")

;;; rhtml-mode
;; (add-to-list 'load-path "~/share/emacs/site-lisp/rhtml")
;; (require 'rhtml-mode)
;; (add-hook 'rhtml-mode-hook
;;      	  (lambda () (rinari-launch)))

;; =================================================================================================
;; nxhtml mode
;; =================================================================================================
(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)
(load "~/share/emacs/site-lisp/nxhtml/autostart.el")

;; =================================================================================================
;; haml es sass mode
;; =================================================================================================
(require 'haml-mode)
;; (setq auto-mode-alist
;;       (append auto-mode-alist
;; 	      '(("\\.rhtml$" . rhtml-mode)
;; 		("\\.erb$" . rhtml-mode)
;; 		("Gemfile" . ruby-mode))))

;; =================================================================================================
;; ruby stuff
;; =================================================================================================
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)
;;; ri
;;(setq ri-ruby-script (expand-file-name "~/share/lib/ri-emacs.rb"))
;;(autoload 'ri "~/share/emacs/site-lisp/ri-ruby.el" nil t)

;;; js-mode and js-comint
;;(require 'js-comint)
;;(setq inferior-js-program-command "/usr/bin/java -cp /usr/share/java/js.jar org.mozilla.javascript.tools.shell.Main")
;; (add-hook 'js2-mode-hook '(lambda () 
;; 			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
;; 			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
;; 			    (local-set-key "\C-cb" 'js-send-buffer)
;; 			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
;; 			    (local-set-key "\C-cl" 'js-load-file-and-go)
;; 			    ))
;; (add-hook 'js-mode-hook '(lambda () 
;; 			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
;; 			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
;; 			    (local-set-key "\C-cb" 'js-send-buffer)
;; 			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
;; 			    (local-set-key "\C-cl" 'js-load-file-and-go)
;; 			    ))

(setq auto-mode-alist
      (append
       (list
        '("\\.n3" . n3-mode)
        '("\\.owl" . n3-mode)
        '("\\.textile$" . textile-mode)
        '("\\.md$" . markdown-mode)
        '("\\.feature$" . feature-mode)
        '("\\.yml$" . yaml-mode)
        '("\\.scss$" . sass-mode)
        '("\\.js$" . js-mode)
        '("\\.json$" . js-mode)
        '("\\.html\\.erb$" . eruby-nxhtml-mumamo-mode)
        '("Gemfile" . ruby-mode)
        '("\\.twig\\.html$" . django-nxhtml-mumamo))
       auto-mode-alist))

