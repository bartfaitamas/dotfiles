(require 'remember)
(require 'org-install)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(setq
 org-log-done t
 org-directory "~/org"
 org-archive-location "archive/%s::"
 org-default-notes-file "~/org/notes.org"
 org-reverse-note-order t                     ; put new notes on top
 org-remember-store-without-prompt t
)


(org-remember-insinuate)
(setq 
 org-remember-templates
 (list
  (list "Itthon"       ?i "** TODO %^{Title}\n   SCHEDULED: %^t\n   %?" (concat org-directory "/tasks/home.org"))
  (list "Programozás"  ?i "** TODO %^{Title}\n   %i\n   %?" (concat org-directory "/tasks/home.org"))
  (list "Config"       ?c "** TODO %^{Title}\n   %?" (concat org-directory "/tasks/config.org"))
))

(add-hook 'remember-mode-hook 'org-remember-apply-template)


