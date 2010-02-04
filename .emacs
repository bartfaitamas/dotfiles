;; load-paths
(setq load-path (cons "~/share/emacs/site-lisp" load-path))

(eval-after-load "htmlize"
  '(progn
     (defadvice htmlize-faces-in-buffer (after org-no-nil-faces activate)
       "Make sure there are no nil faces"
       (setq ad-return-value (delq nil ad-return-value)))))

(require 'yasnippet)

(load "~/.emacs.d/config/tomb-setup.el")
(load "~/.emacs.d/config/tomb-org.el")
(load "~/.emacs.d/config/tomb-programming.el")
(load "~/.emacs.d/config/tomb-sql.el")
(require 'ledger)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list (quote ("/usr/local/share/info")))
 '(current-language-environment "UTF-8")
 '(haskell-doc-show-global-types t)
 '(indent-tabs-mode nil)
 '(mail-user-agent (quote gnus-user-agent))
 '(message-send-mail-function (quote message-smtpmail-send-it))
 '(org-agenda-files (quote ("~/org/openadm.org" "~/org/tukir.org" "~/org/npsh.org" "~/org/timelog.org" "~/org/openadm.org_archive" "~/org/nka.org")))
 '(read-mail-command (quote gnus))
 '(server-window (quote switch-to-buffer-other-frame))
 '(show-paren-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "Grey15" :foreground "Grey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 126 :width normal :foundry "dejavu" :family "dejavu sans mono")))))

