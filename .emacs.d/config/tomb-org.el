;; org mode
(require 'org-install)
(require 'blorg)

(load "~/.emacs.d/config/tomb-org-funcs.el")

(org-remember-insinuate)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cr" 'org-remember)

(setq 
 org-log-done '(state) ;; log everything

 org-agenda-files 
 (quote 
  ("~/org/openadm.org" 
   "~/org/tukir.org"
   "~/org/npsh.org"
   "~/org/timelog.org"
   "~/org/openadm.org_archive"
   "~/org/devel.in.npsh.hu.org"
   "~/org/nka.org"))

 org-agenda-columns-add-appointments-to-effort-sum t
 org-agenda-custom-commands (quote 
			     (("d" todo #("DELEGATED" 0 9 (face org-warning)) nil) 
			      ("c" todo #("DONE|DEFERRED|CANCELLED" 0 23 (face org-warning)) nil) 
			      ("w" todo #("WAITING" 0 7 (face org-warning)) nil) 
			      ("W" agenda "" ((org-agenda-ndays 21))) 
			      ("A" agenda "" ((org-agenda-skip-function 
					       (lambda nil (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]")))
					      (org-agenda-ndays 1) 
					      (org-agenda-overriding-header "Today's Priority #A tasks: "))) 
			      ("u" alltodo "" ((org-agenda-skip-function 
						(lambda nil (org-agenda-skip-entry-if 
							     (quote scheduled) (quote deadline) (quote regexp) "<[^>]+>"))) 
					       (org-agenda-overriding-header "Unscheduled TODO entries: ")))))
 org-agenda-ndays 7
 org-agenda-show-all-dates t
 org-agenda-skip-deadline-if-done t
 org-agenda-skip-scheduled-if-done t
 org-agenda-start-on-weekday nil
 org-cycle-include-plain-lists t
 org-deadline-warning-days 14
 org-default-notes-file "~/org/notes.org"
 org-fast-tag-selection-single-key (quote expert)
 org-remember-store-without-prompt t
 org-reverse-note-order t
 org-time-stamp-custom-formats (quote ("<%Y.%m.%d. %a>" . "<%Y.%m.%d. %a %H:%M>")))



;; ----------------------------------------------------------------------
;; org-mode config copied from Sacha Chua
;; ----------------------------------------------------------------------

(setq org-remember-templates
      '((?t "* TODO %?\n  %i\n  %a" "~/org/todo.org" "Tasks")
	(?j "* %?\n CLOCK-IN  %i\n" "~/org/timelog.org")
	(?d "* %T %?\n" "~/org/devel.in.npsh.hu.org")))


;; publishing
;; (defun org-publish-org-to-xoxo (plist filename pub-dir)
;;   "Publishing an org file to XOXO"
;;   (org-publish-org-to "xoxo" plist filename pub-dir))
(setq org-publish-project-alist
      '(("org"
	 :base-directory "~/org/"
	 :publishing-directory "/var/www/org"
	 :section-numbers nil
	 :table-of-contents nil)
      ("brainstorming"
	 :base-directory "~/org/brainstorm"
	 :publishing-directory "/ssh:TBartfai@devel:~/public_html/brainstorm/"
	 :publishing-function org-publish-org-to-html
	 :section-numbers nil
	 :author "Bártfai Tamás"
	 :email "TBartfai@novell.com"
	 )))

(setq org-export-with-drawers t)

(add-hook 'remember-mode-hook 
	  'my-start-clock-if-needed 'append)

(add-hook 'org-after-todo-state-change-hook
	  'sacha/org-clock-in-if-starting)

(add-hook 'org-after-todo-state-change-hook
	  'sacha/org-clock-out-if-waiting)

(add-hook 'org-after-todo-state-change-hook
	  'sacha/org-clock-out-if-waiting)
