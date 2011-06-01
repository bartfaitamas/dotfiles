(setq column-number-mode t)
(setq indent-tabs-mode nil)

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

(add-to-list 'load-path "{path}/n3-mode.el")
(autoload 'n3-mode "n3-mode" "Major mode for OWL or N3 files" t)

;; Turn on font lock when in n3 mode
(add-hook 'n3-mode-hook
          'turn-on-font-lock)


;; =================================================================================================
;; n3 mode
;; =================================================================================================
(setq auto-mode-alist
      (append
       (list
        '("\\.n3" . n3-mode)
        '("\\.nt" . n3-mode))
       auto-mode-alist))
;; =================================================================================================
;; nxhtml mode
;; =================================================================================================
;;(require 'jinja)
(load "~/share/emacs/site-lisp/nxhtml/autostart.el")
(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mumamo-mode))
(add-to-list 'auto-mode-alist '("\\.twig" . django-nxhtml-mumamo-mode)) ;; twig templates

;; =================================================================================================
;; haml es sass mode
;; =================================================================================================
(require 'haml-mode)

;; (setq auto-mode-alist
;;       (append auto-mode-alist
;;            '(("\\.rhtml$" . rhtml-mode)
;;              ("\\.erb$" . rhtml-mode)
;;              ("Gemfile" . ruby-mode))))


;;; ri
;;(setq ri-ruby-script (expand-file-name "~/share/lib/ri-emacs.rb"))
;;(autoload 'ri "~/share/emacs/site-lisp/ri-ruby.el" nil t)

;;; js-mode and js-comint
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
;; (require 'js-comint)
;; (setq inferior-js-program-command "/usr/bin/java -cp /usr/share/java/js.jar org.mozilla.javascript.tools.shell.Main")
;; (add-hook 'js2-mode-hook '(lambda () 
;;                             (local-set-key "\C-x\C-e" 'js-send-last-sexp)
;;                             (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
;;                             (local-set-key "\C-cb" 'js-send-buffer)
;;                             (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
;;                             (local-set-key "\C-cl" 'js-load-file-and-go)
;;                             ))
;; (add-hook 'js-mode-hook '(lambda () 
;;                             (local-set-key "\C-x\C-e" 'js-send-last-sexp)
;;                             (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
;;                             (local-set-key "\C-cb" 'js-send-buffer)
;;                             (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
;;                             (local-set-key "\C-cl" 'js-load-file-and-go)
;;                             ))

;; settings related to programming modes
;; js2
;; (autoload 'js2-mode "js2-mode" nil t)
;; (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

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

;; sass
(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . sass-mode))