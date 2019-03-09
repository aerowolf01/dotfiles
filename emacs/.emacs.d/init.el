(package-initialize)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; All auto-config generated by customize* actions goes to custom.el
(setq custom-file (concat user-emacs-directory "/custom.el"))
(load-file custom-file)
;; Could this be extracted to a load-user-configfile function?

;; START MANUAL CONFIG
(add-to-list 'load-path "~/.emacs.d/vendor")

(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(defun run-server ()
  "Run the Emacs server if it isn't running."
  (require 'server)
  (unless (server-running-p)
    (server-start)))

(run-server) ; This ensures that emacsclient will work even when there's no running server

;; Change default set-mark-command binding (C-SPC) to C-return
;; so it doesn't shadow the global quick add command from things app
;; (global-unset-key (kbd "C-SPC"))
;; (global-set-key (kbd "<C-return>") 'set-mark-command)

;; remap M-/ to hippie-expand
(global-set-key (kbd "M-/") 'hippie-expand)

;; Global modes
(which-key-mode)
(ido-mode)

;; Local modes
(add-hook 'prog-mode-hook 'linum-mode)

;; Diminish Modes
(diminish 'which-key-mode)
(diminish 'git-gutter-mode)
(diminish 'auto-revert-mode)
(diminish 'eldoc-mode)

;; Global keys
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(global-set-key (kbd "C-c w") 'ace-window) ;; doesn't work in Eshell
(define-key global-map (kbd "C-x C-b") 'ibuffer)

;; Fix some backup/autosave behaviour, save in ~/.emacs-saves
(setq backup-by-copying t      ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.emacs.d/saves"))    ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/saves" t)))

;; ESHELL
;; https://www.youtube.com/watch?v=RhYNu6i_uY4&t=2162s
;; Above shows how to fix eshell not working with special display programs
;; such as git diff
(require 'em-term) ; eshell-visual vars don't exist without this loading first
(add-to-list 'eshell-visual-subcommands
	     '("git" "log" "diff" "show"))
;; Make tab completion case insensitive
(setq eshell-cmpl-ignore-case t)

;; RECENTF
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; MAGIT
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; GIT-GUTTER-FRINGE
(require 'git-gutter-fringe)
(global-git-gutter-mode +1)

;; FLYCHECK
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; RUBY
;; -> CHRUBY
(require 'chruby) ; TODO: Add to package manager whenever that's figured out
(chruby-use "ruby-2.5.3")

;; Haskell
;; -> -mode
(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(eval-after-load 'haskell-mode
  '(progn
     (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-mode)))

;; EXPAND-REGION
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Org-Mode
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c SPC") nil))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   (emacs-lisp . t)))

;; powerline
(require 'powerline)
(powerline-default-theme)
