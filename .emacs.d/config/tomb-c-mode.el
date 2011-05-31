(defun my-c-mode-common-hook ()
  (c-set-style "bsd")
  (c-set-offset 'innamespace 0)
  (abbrev-mode nil) ;; i hate this
  (setq c-tab-always-indent t
	c-basic-offset 4
	tab-width 4
	intent-tabs-mode nil ;; no tabs please
	)  
)

;;(add-hook 'c-mode-hook 'my-c-mode-hook)
;;(add-hook 'c++-mode-hook 'my-c-mode-hook)
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


