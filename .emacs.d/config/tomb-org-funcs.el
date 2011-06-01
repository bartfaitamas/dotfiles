(defun my-start-clock-if-needed ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward " *CLOCK-IN *" nil t)
      (replace-match "")
      (org-clock-in))))

;; stolen from sacha chua
(defun sacha/org-clock-in-if-starting ()
  "Clock in when the task is marked STARTED."
  (when (and (string= state "STARTED")
             (not (string= last-state state)))
    (org-clock-in)))

(defun sacha/org-clock-out-if-waiting ()
  "Clock in when the task is marked STARTED."
  (when (and (string= state "WAITING")
             (not (string= last-state state)))
    (org-clock-out)))

(defun sacha/org-clock-out-if-delegated ()
  "Clock in when the task is marked STARTED."
  (when (and (string= state "DELEGATED")
             (not (string= last-state state)))
    (org-clock-out)))


;; org-mode xoxo export
(defun tbartfai/prop-aput (alist key value)
  "((key1 value) (key2 value) (key1 value2)) -> ((key1 (value value2)) (key2 (value)))
http://steve.vinoski.net/blog/2008/01/24/elisp/"
  (let ((al (symbol-value alist))
        cell)
    (cond ((null al) (set alist (list (cons key (list value)))))
          ((setq cell (assoc key al)) (setcdr cell (cons value (cdr cell))))
          (t (set alist (cons (cons key (list value)) al))))))

(defun tbartfai/org-export-as-xoxo-insert-into (buffer &rest output)
  "foo"
  (with-current-buffer buffer
    (apply 'insert output)))
(put 'tbartfai/org-export-as-xoxo-insert-into 'lisp-indent-function 1)

;;;###autoload
(defun tbartfai/org-export-as-xoxo (&optional buffer)
  "Export the org buffer as XOXO.
The XOXO buffer is named *xoxo-<source buffer name>*"
  (interactive (list (current-buffer)))
  ;; A quickie abstraction

  ;; Output everything as XOXO
  (with-current-buffer (get-buffer buffer)
    (let* ((pos (point))
	   (opt-plist (org-combine-plists (org-default-export-plist)
					(org-infile-export-plist)))
	   (filename (concat (file-name-as-directory
			      (org-export-directory :xoxo opt-plist))
			     (file-name-sans-extension
			      (file-name-nondirectory buffer-file-name))
			     ".html"))
	   (out (find-file-noselect filename))
	   (last-level 1)
	   (hanging-li nil))
      (goto-char (point-min))  ;; CD:  beginning-of-buffer is not allowed.
      ;; Check the output buffer is empty.
      (with-current-buffer out (erase-buffer))
      ;; Kick off the output
      (tbartfai/org-export-as-xoxo-insert-into out "<ol class='xoxo'>\n")
      (while (re-search-forward "^\\(\\*+\\)[ \t]+\\(.+\\)" (point-max) 't)
	(let* ((hd (match-string-no-properties 1))
	       (level (length hd))
	       (heading (match-string-no-properties 2)))
          ;; Handle level rendering
          (cond
           ((> level last-level)
            (tbartfai/org-export-as-xoxo-insert-into out "\n<ol>\n"))

           ((< level last-level)
            (dotimes (- (- last-level level) 1)
              (if hanging-li
                  (tbartfai/org-export-as-xoxo-insert-into out "</li>\n"))
              (tbartfai/org-export-as-xoxo-insert-into out "</ol>\n"))
            (when hanging-li
              (tbartfai/org-export-as-xoxo-insert-into out "</li>\n")
              (setq hanging-li nil)))

           ((equal level last-level)
            (if hanging-li
                (tbartfai/org-export-as-xoxo-insert-into out "</li>\n")))
           )

          (setq last-level level)

          ;; And output the new li with the heading
          (setq hanging-li 't)
          (if (equal ?+ (elt heading 0))
              (tbartfai/org-export-as-xoxo-insert-into out "<li class='" (org-html-expand (substring heading 1)) "'>")
            (tbartfai/org-export-as-xoxo-insert-into out "<li>" (org-html-expand heading)))
	  
	  ;; extract properties, and print dl's
	  (setq myprops ())
	  (setq props (org-entry-properties (match-beginning 0)))
	  (while (setq prop (pop props))
	    (tbartfai/prop-aput 'myprops (car prop) (cdr prop)))
	  
	  (if myprops
	      (progn
		(tbartfai/org-export-as-xoxo-insert-into out "\n<dl>\n")
		(while (setq prop (pop myprops))
		  (let* ((p (car prop))
			 (v (cdr prop)))
		    (tbartfai/org-export-as-xoxo-insert-into out "<dt>" (org-html-expand (car prop)) "</dt>\n")
		    (tbartfai/org-export-as-xoxo-insert-into out "<dd>")
		   
		    (if (equal 1 (length v))
			(tbartfai/org-export-as-xoxo-insert-into out (org-html-expand (car v)))
		      (progn
			(tbartfai/org-export-as-xoxo-insert-into out "\n<ul>\n")
			(while (setq singleval (pop v))
			  (tbartfai/org-export-as-xoxo-insert-into out "<li>" (org-html-expand singleval) "</li>\n"))
			(tbartfai/org-export-as-xoxo-insert-into out "</ul>\n")))
		   
		    (tbartfai/org-export-as-xoxo-insert-into out "</dd>\n")))
		    (tbartfai/org-export-as-xoxo-insert-into out "</dl>\n")))
	  ))
      

      ;; Finally finish off the ol
      (dotimes (- last-level 1)
        (if hanging-li
            (tbartfai/org-export-as-xoxo-insert-into out "</li>\n"))
        (tbartfai/org-export-as-xoxo-insert-into out "</ol>\n"))

      (goto-char pos)
      ;; Finish the buffer off and clean it up.
      (switch-to-buffer-other-window out)
      (indent-region (point-min) (point-max) nil)
      (save-buffer)
      (goto-char (point-min))
      )))


;; ============================================================================
;; weekly timesheet from:
;; http://lvalue.blogspot.com/2010/02/weekly-timesheets-in-org-mode.html
;; ============================================================================
(defun egor/org-generate-weekly-timesheet (&optional org-buffer)
  "Generates timesheet for the current week"
  (interactive)

  ;; Source buffer name defaults to <name of session>.org
  ;; (unless org-buffer
  ;;   (setq org-buffer (concat egor/session-name ".org")))
  (setq org-buffer (current-buffer))

  (let* ((seconds-start (time-to-seconds (current-time))))

    ;; Find last Monday.
    (while (not (= 1 (string-to-number (format-time-string "%u" (seconds-to-time seconds-start)))))
      (setq seconds-start (- seconds-start 86400))) ;; minus one day

    ;; Create time-sliced version of the org buffer and save it.
    (let* ((calc-results (egor/org-create-time-slice-buffer
                          org-buffer
                          nil
                          (format-time-string "%Y%m%d0000"
                                              (seconds-to-time seconds-start))))
           (report-end-marker "#+END"))

      (save-excursion
        ;; Switch to buffer with the Org slice.
        (set-buffer
         (nth 3 calc-results))

        ;; Report is broken if there's no empty line before first headline. Fix it.
        (beginning-of-buffer)
        (when (looking-at "^\\*")
          (insert "\n"))

        ;; Insert time report at the end of the buffer and write it to file.
        (end-of-buffer)
        (org-clock-report)
        (re-search-forward "^|")
        (backward-char)
        (set-mark (point))
        (insert "Amount payable: $" (number-to-string (nth 2 calc-results)) "\n\n")
        (search-forward report-end-marker)
        (backward-char (length report-end-marker))
        (write-file (concat egor/org-timesheet-file-name-prefix
                            (substring org-buffer 0 -4)
                            (format-time-string "-%y%m%d" (seconds-to-time seconds-start))
                            (format-time-string "-%y%m%d" (current-time))
                            ".org"))))))

(defun egor/timestamp> (timestamp1 timestamp2)
  "Returns true if the first timestamp is larger than second"

  (string> (replace-regexp-in-string "[^0-9]" "" (or timestamp1 ""))
           (replace-regexp-in-string "[^0-9]" "" (or timestamp2 ""))))


(defun egor/org-create-time-slice-buffer (&optional src-buffer dest-buffer time-start time-end
                                                    hourly-rate)
  "Creates a copy of an Org buffer with all time stamps limited to given period"
  (interactive)

  ;; Default start time to beginning of the day.
  (unless time-start
    (setq time-start (format-time-string "%Y%m%d0000" (current-time))))

  ;; Default end time to now.
  (unless time-end
    (setq time-end (format-time-string "%Y%m%d%H%M" (current-time))))

  ;; Source buffer name defaults to <name of session>.org
  ;; (unless src-buffer
  ;;   (setq src-buffer (concat egor/session-name ".org")))
  (setq src-buffer (current-buffer))

  ;; Destination buffer name defaults to *<source buffer>-<start-time>-<end-time>.org*
  (unless dest-buffer
    (setq dest-buffer (concat "*" src-buffer "-" time-start "-" time-end ".org*")))

  (save-excursion
    (let* ((timestamp-re "[[<]\\([0-9]+-[0-9]+-[0-9]+ [A-Z][a-z][a-z] [0-9]+:[0-9]+\\)[]>]")
           (clock-line-re (concat "^ +" org-clock-string " +" timestamp-re "\\(?:--"
                                  timestamp-re "\\|\\)"))
           (headline-start-re "^\\*+ ")
           (time-total)
           (earnings))

        ;; Select destination buffer, creating it if necessary, and switch it to org-mode.
        (set-buffer (get-buffer-create dest-buffer))
        (unless (string= major-mode 'org-mode)
          (org-mode))

        ;; Copy contents of the source buffer to destination buffer.
        (erase-buffer)
        (insert-buffer-substring src-buffer)

        ;; Edit all clock lines, limiting them to the given range.
        (beginning-of-buffer)
        (while (re-search-forward clock-line-re nil t)
          (let* ((line-time-start (match-string-no-properties 1))
                 (line-time-end (match-string-no-properties 2)))

            ;; If there's no end time, insert current time.
            (unless line-time-end
              (setq line-time-end (org-insert-time-stamp (current-time) t t "--")))

            ;; If it ended before start time, just remove the line from buffer.
            (if (egor/timestamp> time-start line-time-end)
                (progn
                  (beginning-of-line)
                  (kill-line 1))

              ;; If line start time is before start time, replace it with start time.
              (if (egor/timestamp> time-start line-time-start)
                  (replace-match line-time-start nil nil nil 1)))))

        ;; Calculate time totals.
        (org-clock-display)

        ;; Parse totals from message buffer (Org doesn't return the any other way.)
        (save-excursion
          (set-buffer "*Messages*")
          (end-of-buffer)
          (re-search-backward "Total file time: \\([0-9]+\\):\\([0-9]+\\).+\n")

          ;; Assign hour and minute variables.
          (setq hours (string-to-number (match-string-no-properties 1)))
          (setq minutes (string-to-number (match-string-no-properties 2)))

          ;; Remove noise from message buffer and minibuffer.
          (message nil)
          (replace-match ""))

        ;; Calculate time totals.

        ;; Remove tasks not worked on (i.e., not having time totals.)
        (let* ((untimed-headlines (list)))

           ;; Search for headlines from the bottom up.
          (end-of-buffer)
          (while (re-search-backward headline-start-re nil t)

            ;; Check for time totals, and if missing, add headline to the list.
            ;; We can't delete them as we go because that would destroy clock overlays.
            (unless (org-overlays-at (- (line-end-position) 1))
              (add-to-list 'untimed-headlines (line-beginning-position) t)))

          ;; Delete found untimed headlines.
          (dolist (headline-pos untimed-headlines)
            (goto-char headline-pos)
            (end-of-line)
            (when (re-search-forward (concat "\\'\\|" headline-start-re) nil t)
              (backward-char (length (match-string 0)))
              (delete-region headline-pos (point)))))

        ;; Calculate earnings.
        (unless hourly-rate
          (setq hourly-rate egor/org-hourly-rate))
        (if hourly-rate
            (setq earnings
                  (ffloor (* hourly-rate (+ hours (/ minutes 60.0))))))

        ;; Return results as a list.
        (list hours minutes earnings (get-buffer dest-buffer)))))




