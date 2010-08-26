;; load-paths
(setq load-path (cons "~/share/emacs/site-lisp" load-path))

;; gnome2-globalmenu workaround
;;(defun ggm-menuupdate () (menu-bar-mode -1) (menu-bar-mode 1))
;;(add-hook 'window-configuration-change-hook 'ggm-menuupdate)

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

;; some experimental
(require 'notify)
(require 'dbus)
(defun tbartfai/check-org-clock-and-notify ()
  "Checks whether there is a running clock in org-mode, and if there's none, sends a notfication"
  (unless (org-clock-is-active)
        (notify "Nincs task" "Nincs futo task, nem tudjuk merni, mit csinalunk"))
)

(when window-system
  (run-at-time nil 300 'tbartfai/check-org-clock-and-notify)
)


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
 '(read-mail-command (quote gnus))
 '(server-window (quote switch-to-buffer-other-frame))
 '(show-paren-mode t)
 '(sql-ms-options nil)
 '(truncate-lines t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "Grey15" :foreground "Grey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))



;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
