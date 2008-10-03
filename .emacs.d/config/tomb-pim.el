;; PIM settings (mail, addressbook, etc)
(setq user-full-name "Bártfai Tamás László")
(setq user-mail-address "TBartfai@novell.com")

;; mail
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
;;(bbdb-insinuate-message)

(setq bbdb-complete-name-allow-cycling t)
(setq calendar-week-start-day 1)
(setq gnus-select-article-hook 
      (quote 
       (gnus-agent-fetch-selected-article 
	spam-stat-store-gnus-article-buffer)))
(setq gnus-use-full-window nil)

(setq message-send-mail-function 
      (quote message-smtpmail-send-it))
(setq mm-external-terminal-program "x-terminal-emulator")


