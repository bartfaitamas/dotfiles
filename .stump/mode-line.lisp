(in-package :stumpwm)

(load-module "cpu")
(load-module "mem")
(load-module "net")

(setf stumpwm:*screen-mode-line-format*
      (list
       "[^B%n^b] " ; group num
       ;; notification
       "^13%N^n"
       "^B%w^b"

       "^>" ; right align
       "%c" ; cpu
       "| %M" ; mem
       "| %l" ; net
       ;;"%d" ; crappy default date
       '(:eval (string-right-trim '(#\Newline) (run-shell-command
                                                ;; "date +'%a %m-%d ^4*^B%l:%M^b^n %p'|tr -d '\\n'"
                                                ;; uses date command so time can be bold
                 "date +'| %a %m-%d ^4*^B%l:%M^b^n %p'" t)))
       ))

(dolist (head
          (list (first (screen-heads (current-screen)))) ; first
         ;; (screen-heads (current-screen)) ; all
         )
  (enable-mode-line (current-screen) head
                    t *screen-mode-line-format*))
