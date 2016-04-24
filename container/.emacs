
;; Setup
(setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
(add-to-list 'load-path "/usr/share/common-lisp/source/slime/")  ; your SLIME directory
(require 'slime-autoloads)
(eval-after-load "slime"
  '(progn
    (add-to-list 'load-path "/usr/share/common-lisp/source/slime/contrib/")  ; your SLIME contrib directory
    (slime-setup '(slime-fancy slime-asdf slime-banner))
    (setq slime-complete-symbol*-fancy t)
    (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)))
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

;; Matching paren highlight
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Powerline
(add-to-list 'load-path "~/.emacs.d/vendor/powerline")
(require 'powerline)
(powerline-default-theme)
(setq powerline-arrow-shape 'curve)   ;; give your mode-line curves
(custom-set-faces
    '(mode-line ((t (:foreground "#030303" :background "#bdbdbd" :box nil))))
    '(mode-line-inactive ((t (:foreground "#f9f9f9" :background "#666666" :box nil)))))






