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

