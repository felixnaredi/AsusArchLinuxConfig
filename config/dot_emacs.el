
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("e11569fd7e31321a33358ee4b232c2d3cf05caccd90f896e1df6cab228191109" default)))
 '(font-use-system-font t)
 '(package-selected-packages
   (quote
    (ghc-imported-from ghc flycheck-ghcmod flycheck-clang-analyzer zenburn-theme ample-zen-theme ample-theme abyss-theme swift-mode ruby-electric inf-ruby forth-mode auto-complete-clang ac-clang)))
 '(zenburn-override-colors-alist (quote (("zenburn-bg" . "#18181b")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Meslo LG M" :foundry "PfEd" :slant normal :weight normal :height 90 :width normal)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                            ;;
;;                          Custom                            ;;
;;                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Melpa
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))


;; Util
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun insert-time-string ()
  "Inserts a time string"
  (interactive)
  (insert (format-time-string "%F %X %z")))
(global-set-key (kbd "C-x t") 'insert-time-string)

(defun insert-flat-time-string ()
  (interactive)
  (insert (format-time-string "%Y%m%d%H%M%S")))
(global-set-key (kbd "C-x M-t") 'insert-flat-time-string)

(defun revert-buffer-no-confirm ()
  "Reverts buffer without confirmation"
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))

(global-set-key (kbd "C-x r") 'revert-buffer-no-confirm)

(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; C set up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun init-flycheck-clang-analyze ()
  "Initalizes flycheck-clang-analyze. It is a demanding minor mode"
  (with-eval-after-load 'flycheck
    (require 'flycheck-clang-analyzer)
    (flycheck-clang-analyzer-setup)
    (add-hook 'c-mode-common-hook 'flycheck-mode) nil))

(add-hook 'c-mode-hook '(lambda () (c-set-style "linux")))

(add-hook 'c++-mode-hook
	  '(lambda ()
	     (c-set-style "stroustrup")
	     (c-set-offset 'func-decl-cont 0)
	     (c-set-offset 'inline-open 0)
	     (c-set-offset 'statement-block-intro '+)
	     (c-set-offset 'statement-cont 0)))

(add-hook 'c-mode-common-hook 'auto-complete-mode)
; (init-flycheck-clang-analyze) ;; It slows down too much.

(add-to-list 'auto-mode-alist '("\\.glsl\\'" . c-mode))

;; Ruby set up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'ruby-mode-hook 'ruby-electric-mode)
