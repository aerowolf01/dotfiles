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

;; C-x O counter-clockwise other-window (C-x o)
(defun reverse-other-window ()
  (interactive)
  (other-window -1))

(global-set-key (kbd "s-o") 'other-window)
(global-set-key (kbd "C-x O") 'reverse-other-window)
(global-set-key (kbd "C-x C-o") 'other-frame)

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
(diminish 'git-gutter-mode)

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
(chruby-use "ruby-2.6.2")

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
(global-set-key (kbd "C-'") 'er/expand-region)

;; Org-Mode
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c SPC") nil)
  (define-key org-mode-map (kbd "C-c l") 'org-store-link))

;; Org-Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ruby . t)
   (emacs-lisp . t)
   (js . t)))

;; Org-Capture
; Default org-directory is ~/org, We switch to ~/Documents/org so we can sync in iCloud
(setq org-directory "~/Dropbox/Org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-default-journal-file (concat org-directory "/journal.org"))

(define-key global-map "\C-cc" 'org-capture)

;; For info on how to customize templates:
; check the org-capture-templates var
; (key description target template)
(setq org-capture-templates
      '(("i" "Inbox Item"
	 entry (file+headline org-default-notes-file "Inbox")
         "* TODO %?")
	("c" "Code Todo (prompts for file link description)"
	 entry (file+headline org-default-notes-file "Code TODOs")
	 "* TODO %?\n  %i\n  %A")
	("j" "Journal Entry"
	 entry (file+datetree org-default-journal-file)
	 "* %?")
	("g" "Grocery List"
	 entry (file+headline org-default-notes-file "Groceries")
	 "* TODO Grocery List%?\n | Item | Est. Price |\n|-+-|\n| | |\n| Total w/ tax: | |\n#+TBLFM: @>$2=vsum(@46..@-1)*1.08"
	 )))

;; Org-Refile
(setq org-refile-targets
      '((org-default-notes-file :maxlevel . 3)))

;; Org-Agenda
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-files
      (list org-default-notes-file))

;; powerline
(require 'powerline)
(powerline-default-theme)

;; Typescript
; http://redgreenrepeat.com/2018/05/04/typescript-in-emacs/
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)

(add-hook 'before-save-hook 'tide-format-before-saves)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; Javascript (https://emacs.cafe/emacs/javascript/setup/2017/04/23/emacs-setup-javascript.html)
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

					; better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(require 'js2-refactor)
(require 'xref-js2)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t )))

(require 'company)
(add-hook 'js2-mode-hook #'setup-tide-mode)
; For type checking, use the jsconfig.json template here:
; https://www.reddit.com/r/emacs/comments/68zacv/using_tidemode_to_typecheck_javascript/

(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

;; DIRED
(load "dired-x") ; gives F command in dired (open all marked files)
; https://stackoverflow.com/questions/1110118/in-emacs-dired-how-to-find-visit-multiple-files

;; MULTIPLE-CURSORS
(require 'multiple-cursors)
(global-set-key (kbd "C-c .") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c S") 'mc/edit-lines)
(global-set-key (kbd "C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-,") 'mc/mark-previous-like-this)

; phi-search settings (replacement for built in isearch that works with multiple-cursors)
(require 'phi-search)
(global-set-key (kbd "C-s") 'phi-search)
(global-set-key (kbd "C-r") 'phi-search-backward)

;; CIRCE (Client for IRC in Emacs)
(setq circe-network-options
      '(("Freenode"
         :tls t
         :nick "my-nick"
         :sasl-username "my-nick"
         :sasl-password "my-password"
         :channels ("#ruby")
         )))

; Hide JOIN, PART, QUIT messages
(setq circe-reduce-lurker-spam t)

; Align messages
(setq circe-format-say "{nick:-16s} {body}")

; Colorize nicks
(require 'circe-color-nicks)
(enable-circe-color-nicks)

;; HELM
(require 'helm)
(helm-mode 1)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-r") 'helm-recentf)

;; PROJECTILE
(projectile-mode +1)

;; HELM-PROJECTILE
(require 'helm-projectile)
(helm-projectile-on)
(global-set-key (kbd "s-p") 'helm-projectile-find-file)
(global-set-key (kbd "s-P") 'helm-projectile-switch-project)

;; EMMET
(require 'emmet-mode)

;; Thanks to Bozhidar Batsov
;; http://emacsredux.com/blog/2013/]05/22/smarter-navigation-to-the-beginning-of-a-line/
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.
Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.
If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))
(global-set-key (kbd "C-a") 'smarter-move-beginning-of-line)

;; HYDRA


;; END CONFIG

(provide 'init)
;;; init ends here
