;;
;; Original path: ~/.emacs
;; -------------------------------------------------------------


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


(defun revert-buffer-no-confirm ()
  "Reverts buffer without confirmation"
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))

(global-set-key (kbd "C-x r") 'revert-buffer-no-confirm)


;; C set up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun dasmodel::init-flycheck-clang-analyze (should-add-hook)
  "Initalizes flycheck-clang-analyze. It is a demanding minor mode"
  (with-eval-after-load 'flycheck
    (require 'flycheck-clang-analyzer)
    (flycheck-clang-analyzer-setup))
  (if should-add-hook
      (add-hook 'c-mode-common-hook 'flycheck-mode) nil))

(add-hook 'c-mode-hook '(lambda ()
			  (c-set-style "linux")))

(add-hook 'c-mode-common-hook 'auto-complete-mode)
; (dasmodel::init-flycheck-clang-analyze 1) ;; It slows down too much.

;; Ruby set up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'ruby-mode-hook 'ruby-electric-mode)
