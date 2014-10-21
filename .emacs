(add-to-list 'load-path "/Users/aja/.emacs.d/")

(server-start)

(require 'package)
(package-initialize)

(require 'whitespace)
(require 'multiple-cursors)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Added from ryan's setup:
(setq running-xemacs (featurep 'xemacs))
(setq running-emacs  (not running-xemacs))
(setq running-osx    (or (featurep 'mac-carbon) (eq 'ns window-system)))
(require 'bs)
(global-set-key (kbd "C-x C-b") 'bs-show)
(global-set-key (kbd "M-s")     'fixup-whitespace)
(global-set-key (kbd "M-C-y")   'kill-ring-search)
(global-set-key (kbd "C-c C-d")   'delete-trailing-whitespace)

(define-key isearch-mode-map (kbd "C-o")
  (lambda ()
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp
                 isearch-string (regexp-quote isearch-string))))))

(when window-system (global-unset-key "\C-z"))

(defun rwd-previous-line-6 ()
  (interactive)
  (previous-line 6))

(defun rwd-forward-line-6 ()
  (interactive)
  (forward-line 6))

(defun rwd-scroll-up ()
  (interactive)
  (scroll-down 1))

(defun rwd-scroll-down ()
  (interactive)
  (scroll-up 1))

(defun rwd-scroll-top ()
  (interactive)
  (recenter 0))

;; compatibility:
(if running-emacs
    (progn
      (global-set-key (kbd "M-g")      'goto-line)
      (global-set-key (kbd "<C-up>")   'rwd-previous-line-6)
      (global-set-key (kbd "<C-down>") 'rwd-forward-line-6)
      (global-set-key (kbd "<M-up>")   'rwd-scroll-up)
      (global-set-key (kbd "<M-down>") 'rwd-scroll-down)
      (global-set-key (kbd "C-M-l")    'rwd-scroll-top)))

(global-set-key (kbd "C-x C-p") 'find-file-at-point)
(global-set-key (kbd "C-c e") 'erase-buffer)

(defadvice find-file-at-point (around goto-line compile activate)
  (let ((line (and (looking-at ".*?:\\([0-9]+\\)")
                   (string-to-number (match-string 1)))))
    ad-do-it
    (and line (goto-line line))))
(global-set-key (kbd "C-x /")   'align-regexp)

(defun rwd-arrange-frame (w h &optional nosplit)
  "Rearrange the current frame to a custom width and height and split unless prefix."
  (let ((frame (selected-frame)))
    (when (memq (framep frame) '(mac ns))
      (delete-other-windows)
      (set-frame-position frame 5 25)
      (set-frame-size frame w h)
      (if (not nosplit)
          (split-window-horizontally)))))

(defun amh-screen-threeway (w h &optional nosplit)
  (let ((frame (selected-frame)))
    (delete-other-windows)
    (set-frame-position frame 5 25)
    (set-frame-size frame w h)
    (split-window-horizontally)
    (split-window-horizontally)
    (balance-windows)))

(add-hook 'shell-mode-hook
	  (lambda ()
	    (define-key shell-mode-map (kbd "C-z")        'comint-stop-subjob)
	    (define-key shell-mode-map (kbd "M-<return>") 'shell-resync-dirs)))

(transient-mark-mode)

(progn
  (setq ns-is-fullscreen nil)

  (defadvice ns-toggle-fullscreen (before record-state compile activate)
    (setq ns-is-fullscreen (not ns-is-fullscreen))))

(defun rwd-ns-fullscreen ()
  (interactive)
  (or ns-is-fullscreen (ns-toggle-fullscreen)))

(defun rwd-set-font-size (size)
  (interactive "nSize: ")
  (rwd-set-mac-font "DejaVu Sans Mono" size))

(defun rwd-resize-13 (&optional nosplit)
  (interactive "P")
  (rwd-set-font-size 13)
  (rwd-arrange-frame 163 70 nosplit)
  )

(defun amh-resize-2-col (&optional nosplit)
  (interactive "P")
  (rwd-set-font-size 16)
  (rwd-arrange-frame 163 70 nosplit)
  )

(defun amh-resize-3-col (&optional nosplit)
  (interactive "P")
  (rwd-set-font-size 16)
  (amh-screen-threeway 248 70 nosplit)
  )

(defun amh-resize-cinema (&optional nosplit)
  (interactive "P")
  (rwd-set-font-size 16)
  (amh-screen-threeway 248 70 nosplit)
  )

(defun rwd-resize-presentation ()
  "Create a giant font window suitable for doing live demos."
  (interactive)
  (rwd-arrange-frame 92 34 t)
  (rwd-set-font-size 20))

(defun rwd-set-mac-font (name size)
  (interactive
   (list (completing-read "font-name: "
                          (mapcar (lambda (p) (list p p))
                                  (font-family-list)) nil t)
         (read-number "size: " 12)))
  (set-face-attribute 'default nil
                      :family name
                      :slant  'normal
                      :weight 'normal
                      :width  'normal
                      :height (* 10 size))
  (frame-parameter nil 'font))

(if window-system
    (add-hook 'after-init-hook
              (lambda () (run-with-idle-timer 0.25 nil #'rwd-resize-13)
                (server-start)) t))
(require 'uniquify)
(setq
 uniquify-strip-common-suffix t
 uniquify-buffer-name-style 'post-forward
 uniquify-separator ":")

(winner-mode 1)
(require 'window-number)
(window-number-meta-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'autotest)
(put 'erase-buffer 'disabled nil)
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\Rakefile$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

(add-hook 'ruby-mode-hook
          '(lambda ()
             (progn
               (whitespace-mode)
               (inf-ruby-keys))))

;; If you have Emacs 19.2x or older, use rubydb2x
(autoload 'rubydb "rubydb3x" "Ruby debugger" t)

;; uncomment the next line if you want syntax highlighting
(add-hook 'ruby-mode-hook 'turn-on-font-lock)

(add-hook 'ruby-mode-hook
          '(lambda ()
             (define-key ruby-mode-map (kbd "C-c C-a") 'autotest-switch)))

;; rails mode stuff
(add-to-list 'load-path (expand-file-name "~/Projects/emacswiki.org") t)

(if (featurep 'ns)
    ;; deal with OSX's wonky enivronment by forcing PATH to be correct.
    (progn
      (setenv "PATH"
              (shell-command-to-string
               "/bin/bash -lc 'echo -n $PATH'")))
  (setenv "CDPATH"
          (shell-command-to-string
           "/bin/bash -lc 'echo -n $CDPATH'")))

(let ((extra-path-dirs '("/opt/local/bin"
                         "/usr/local/bin"
                         "/MyApplications/dev/lisp/PLTScheme/bin"
                         "/opt/local/lib/postgresql82/bin"))
      (path (split-string (getenv "PATH") ":" t)))
  (progn
    (dolist (dir extra-path-dirs)
      (add-to-list 'path dir t))
    (setenv "PATH" (mapconcat (lambda (x) x) path ":"))))

(dolist (path (split-string (getenv "PATH") ":" t)) ; argh this is stupid
  (add-to-list 'exec-path path t))

(require 'loadhist)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(dirtrack-debug t t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ffap-file-finder (quote find-file-other-window))
 '(history-length 1000)
 '(indent-tabs-mode nil)
 '(magit-default-tracking-name-function (quote magit-tracking-name-unfucked-with))
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
 '(org-journal-dir "~/reference/journal/")
 '(package-archives (quote (("marmalade" . "http://marmalade-repo.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(prolog-program-name "/usr/local/bin/gprolog")
 '(require-final-newline t)
 '(save-place t nil (saveplace))
 '(save-place-limit 250)
 '(save-place-save-skipped nil)
 '(save-place-skip-check-regexp "\\`/\\(cdrom\\|floppy\\|mnt\\|\\([^@/:]*@\\)?[^@/:]*[^@/:.]:\\)")
 '(savehist-ignored-variables (quote (yes-or-no-p-history)))
 '(savehist-mode t nil (savehist))
 '(scheme-program-name "plt-r5rs")
 '(tool-bar-mode nil)
 '(transient-mark-mode t)
 '(truncate-partial-width-windows nil)
 '(whitespace-style (quote (face tabs trailing lines-tail space-before-tab empty))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (min-colors 88) (background light)) (:foreground "Dark Blue"))))
 '(font-lock-string-face ((((class color) (min-colors 88) (background light)) (:foreground "ForestGreen")))))

(require 'haml-mode)

;; MAGIT
(defun magit-tracking-name-unfucked-with (remote branch)
  branch)
(require 'magit)
(global-set-key (kbd "C-c g")   'magit-status)
'(magit-default-tracking-name-function (quote magit-tracking-name-unfucked-with))

(add-hook 'yaml-mode-hook
          '(lambda ()
             (progn
               (whitespace-mode))))

(defun mg-tests ()
  "Fire up the tests for the mansion project"
  (interactive)
  (let ((buffer (shell "*guard-mansion*")))
    (set (make-local-variable 'comint-buffer-maximum-size) 5000)
    (compilation-shell-minor-mode)
    (comint-send-string buffer "bundle exec guard")))

(defun mg-foreman ()
  "Start up foreman for the mansion project"
  (interactive)
  (let ((buffer (shell "*foreman-mansion*")))
    (set (make-local-variable 'comint-buffer-maximum-size) 5000)
    (compilation-shell-minor-mode)
    (comint-send-string buffer "bundle exec foreman")))

;; use utf-8 for everything
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(defun force-save ()
 (interactive)
 (not-modified 1)
 (save-buffer))

(global-set-key (kbd "C-x C-s") 'force-save)

(require 'tramp)

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))


;; UNDER CONSIDERATION

(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))
