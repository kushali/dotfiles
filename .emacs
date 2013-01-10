(add-to-list 'load-path "/Users/aja/.emacs.d/")

(server-start)

(require 'whitespace)

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
(global-set-key (kbd "C-c g")   'magit-status)

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
  (rwd-arrange-frame 163 78 nosplit)
  )

(defun amh-resize-2-col (&optional nosplit)
  (interactive "P")
  (rwd-set-font-size 16)
  (rwd-arrange-frame 163 78 nosplit)
  )

(defun amh-resize-3-col (&optional nosplit)
  (interactive "P")
  (rwd-set-font-size 16)
  (amh-screen-threeway 248 78 nosplit)
  )

(defun amh-resize-cinema (&optional nosplit)
  (interactive "P")
  (rwd-set-font-size 14)
  (amh-screen-threeway 248 78 nosplit)
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
              (lambda () (run-with-idle-timer 0.25 nil #'amh-resize-3-col)
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
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.lob2$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.lob$" . js2-mode))


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
 '(magit-default-tracking-name-function (quote magit-default-tracking-name-branch-only))
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
 '(package-archives (quote (("marmalade" . "http://marmalade-repo.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(prolog-program-name "/usr/local/bin/gprolog")
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

(add-to-list 'auto-mode-alist '("\\.pl$" . prolog-mode))

;; TRYING PROLOG MODE
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'gnu)
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                              auto-mode-alist))

;; TRYING HAML MODE
(require 'haml-mode)
;; (add-hook 'haml-mode-hook
;;           (lambda ()
;;             (setq indent-tabs-mode nil)
;;             (define-key haml-mode-map "\C-m" 'newline-and-indent)))

;; MAGIT
(require 'magit)

(defun amh-start-guard ()
  "Fire up an instance of guard in its own buffer"
  (interactive)
  (let ((buffer (shell "*guard*")))
    (set (make-local-variable 'comint-buffer-maximum-size) 5000)
    (compilation-shell-minor-mode)
    (comint-send-string buffer "guard\n")))

;; Smart indent rigidly
(add-hook 'coffee-mode-hook 'smart-indent-rigidly-mode)

(require 'javascript-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
