;; org mode
(require 'org-install)
(require 'org-jsinfo)
;; (require 'blorg)

(load "~/.emacs.d/config/tomb-org-funcs.el")

(org-remember-insinuate)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cr" 'org-remember)

(setq 
 org-log-done '(state) ;; log everything

 org-agenda-files (quote 
                   ("~/org/tukir/event-bus.org"
                    "~/org/tukir/secret-issues.org"
                    "~/org/tukir/tukir_brainstorm.org"
                    "~/org/tukir/tukir.org"
                    "~/org/OpenAdministrator/notes.org"
                    "~/org/OpenAdministrator/openadm.org"
                    "~/org/OpenAdministrator/openadm.org_archive"
                    "~/org/npsh.org"
                    "~/org/timelog.org"
                    "~/org/devel.in.npsh.hu.org"
                    "~/org/nka.org"
                    "~/Development/NKA/org/timelog.org"
                    "~/Development/NKA/org/adatlap_table_explode.org"
                    "~/Development/NKA/org/GS_szinkron_dokumentalas.org"
                    "~/Development/NKA/org/ktg-visszatervezes.org"
                    "~/Development/NKA/org/tasks.org"
                    "~/Development/NKA/org/timelog.org"
                    "~/Development/Posta/org/posta-tasks.org"
   ))

 org-agenda-columns-add-appointments-to-effort-sum t

 org-agenda-ndays 7
 org-agenda-show-all-dates t
 org-agenda-skip-deadline-if-done t
 org-agenda-skip-scheduled-if-done t
 org-cycle-include-plain-lists t
 org-deadline-warning-days 14
 org-default-notes-file "~/org/notes.org"
 org-fast-tag-selection-single-key (quote expert)
 org-remember-store-without-prompt t
 org-reverse-note-order t
 org-time-stamp-custom-formats (quote ("<%Y.%m.%d. %a>" . "<%Y.%m.%d. %a %H:%M>"))
 org-clock-persist (quote clock)
 org-clock-persist-query-resume t
 org-clock-persist-query-save t
 org-remember-templates (quote (
                                ("" 116 "* TODO %?
  %i
  %a" "~/org/todo.org" "Tasks" nil) 
                                ("" 106 "* %?
 CLOCK-IN  %i
" "~/org/timelog.org" nil nil) 
                                ("" 110 "* %k %?
 CLOCK-IN  %i
" "~/Development/NKA/org/timelog.org" nil nil) 
                                ("" 100 "* %T %?
" "~/org/devel.in.npsh.hu.org" nil nil)))
 
 org-agenda-custom-commands (quote 
			     (("l" "Havi logbook" agenda ""
                               ((org-agenda-show-log t)
                                (org-agenda-ndays 31)
                                (org-agenda-log-mode-items '(clock))
                                (org-agenda-start-day "1")
                                (org-agenda-start-with-log-mode t))
                               "/var/www/nka/agenda-junius.txt"
                               )
                              ("d" todo #("DELEGATED" 0 9 (face org-warning)) nil) 
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
					       (org-agenda-overriding-header "Unscheduled TODO entries: "))))))



;; ----------------------------------------------------------------------
;; org-mode config copied from Sacha Chua
;; ----------------------------------------------------------------------

(setq org-remember-templates
      '((?t "* TODO %?\n  %i\n  %a" "~/org/todo.org" "Tasks")
	(?j "* %?\n CLOCK-IN  %i\n" "~/org/timelog.org")
        (?n "* %?\n CLOCK-IN  %i\n" "~/Development/NKA/org/timelog.org")
	(?d "* %T %?\n" "~/org/devel.in.npsh.hu.org")))


;; publishing
;; (defun org-publish-org-to-xoxo (plist filename pub-dir)
;;   "Publishing an org file to XOXO"
;;   (org-publish-org-to "xoxo" plist filename pub-dir))
(setq org-export-html-use-infojs t)
(setq org-infojs-options '((path . "http://orgmode.org/org-info.js")
 (view . "info")
 (toc . :table-of-contents)
 (ftoc . "0")
 (tdepth . "max")
 (sdepth . "max")
 (mouse . "underline")
 (buttons . "0")
 (ltoc . "0")
 (up . :link-up)
 (home . :link-home))
)
(setq org-publish-project-alist
      '(
	("tukir" :components ("tukir-notes" "tukir-static"))
	("tukir-static"
	 :base-directory "~/org/tukir/"
	 :publishing-directory "/var/www/tukir"
	 :recursive t
	 :publishing-function org-publish-attachment
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 )
	("tukir-notes"
	 :base-directory "~/org/tukir/"
	 :publishing-directory "/var/www/tukir"
	 :author "Bártfai Tamás"
	 :email "TBartfai@novell.com"
	 :publishing-function org-publish-org-to-html
	 :recursive t
	 :style "<link rel=stylesheet href=\"css/org.css\" type=\"text/css\">
<link rel=stylesheet href=\"css/worg.css\" type=\"text/css\">"
	 :table-of-contents 2
	 :toc 2
	 :language hu
	 :auto-index t
	 :index-filename "sitemap.org"
	 :index-title "Sitemap"
	 )
	("nka"
	 :base-directory "~/Development/NKA/org/"
	 :publishing-directory "/var/www/nka"
	 :author "Bártfai Tamás"
	 :email "TBartfai@novell.com"
	 :publishing-function org-publish-org-to-html
	 :recursive t
	 :style "<link rel=stylesheet href=\"css/org.css\" type=\"text/css\">
<link rel=stylesheet href=\"css/worg.css\" type=\"text/css\">"
	 :table-of-contents 5
	 :toc 5
	 :language hu
	 :auto-index t
	 )
	))

(setq org-export-with-drawers t)

(add-hook 'remember-mode-hook 
	  'my-start-clock-if-needed 'append)

;; (add-hook 'org-after-todo-state-change-hook
;; 	  'sacha/org-clock-in-if-starting)

;; (add-hook 'org-after-todo-state-change-hook
;; 	  'sacha/org-clock-out-if-waiting)

;; (add-hook 'org-after-todo-state-change-hook
;; 	  'sacha/org-clock-out-if-waiting)
