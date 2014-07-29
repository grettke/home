
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org%20Only%20System][Org\ Only\ System:1]]

(defun gcr/warn-emacs-version ()
  "Warn of Emacs inadequacy."
  (interactive)
  (when (or
         (not (= emacs-major-version 24))
         (not (= emacs-minor-version 3)))
    (warn "Insufficient Emacs requirements. Expected v24.3. Found v%s.%s"
          (number-to-string emacs-major-version)
          (number-to-string emacs-minor-version))))
(gcr/warn-emacs-version)
(setq-default user-full-name "Grant Rettke"
              user-mail-address "gcr@wisdomandwonder.com")

(setq-default eval-expression-print-level nil)
(setq-default case-fold-search nil)
(setq gc-cons-threshold (* 064 1024 1024))
(setq debug-on-error t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(display-time-world-list (quote (("America/Los_Angeles" "Los_Angeles") ("America/Denver" "Denver") ("America/Chicago" "Chicago") ("America/New_York" "New York") ("Asia/Kolkata" "Kolkata") ("Asia/Kuala_Lumpur" "Kuala Lumpur")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun gcr/insert-timestamp ()
  "Produces and inserts a full ISO 8601 format timestamp."
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%T%z")))

(defun gcr/insert-datestamp ()
  "Produces and inserts a partial ISO 8601 format timestamp."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(defun gcr/comment-or-uncomment ()
  "Comment or uncomment the current line or selection."
  (interactive)
  (cond ((not mark-active) (comment-or-uncomment-region (line-beginning-position)
                                                      (line-end-position)))
        ((< (point) (mark)) (comment-or-uncomment-region (point) (mark)))
        (t (comment-or-uncomment-region (mark) (point)))))

(defun gcr/no-control-m ()
  "Aka dos2unix."
  (interactive)
  (let ((line (line-number-at-pos))
        (column (current-column)))
    (mark-whole-buffer)
    (replace-string "
          " "")
    (goto-line line)
    (move-to-column column)))

(defun gcr/untabify-buffer ()
  "For untabifying the entire buffer."
  (interactive)
  (untabify (point-min) (point-max)))

(defun gcr/untabify-buffer-hook ()
  "Adds a buffer-local untabify on save hook"
  (interactive)
  (add-hook
   'after-save-hook
   (lambda () (gcr/untabify-buffer))
   nil
   'true))

(defun gcr/disable-tabs ()
  "Disables tabs."
  (setq indent-tabs-mode nil))

(defun gcr/save-all-file-buffers ()
  "Saves every buffer associated with a file."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (buffer-modified-p))
        (save-buffer)))))

(defun gcr/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun gcr/delete-trailing-whitespace ()
  "Apply delete-trailing-whitespace to everything but the current line."
  (interactive)
  (let ((first-part-start (point-min))
        (first-part-end (point-at-bol))
        (second-part-start (point-at-eol))
        (second-part-end (point-max)))
    (delete-trailing-whitespace first-part-start first-part-end)
    (delete-trailing-whitespace second-part-start second-part-end)))

(defun gcr/newline ()
  "Locally binds newline."
  (local-set-key (kbd "RET") 'sp-newline))

(defun gcr/describe-thing-in-popup ()
    "Display help information on the current symbol.

Attribution: URL `http://www.emacswiki.org/emacs/PosTip'
Attribution: URL `http://blog.jenkster.com/2013/12/popup-help-in-emacs-lisp.html'"
    (interactive)
    (let* ((thing (symbol-at-point))
           (help-xref-following t)
           (description (with-temp-buffer
                          (help-mode)
                          (help-xref-interned thing)
                          (buffer-string))))
      (gcr/on-gui (pos-tip-show description nil nil nil 300))
      (gcr/not-on-gui (popup-tip description
                                 :point (point)
                                 :around t
                                 :height 30
                                 :scroll-bar t
                                 :margin t))))

(defun gcr/indent-curly-block (&rest _ignored)
  "Open a new brace or bracket expression, with relevant newlines and indent. Src: https://github.com/Fuco1/smartparens/issues/80"
  (newline)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))

(defmacro gcr/on-gnu/linux (statement &rest statements)
  "Evaluate the enclosed body only when run on GNU/Linux."
  `(when (eq system-type 'gnu/linux)
     ,statement
     ,@statements))

(defmacro gcr/on-osx (statement &rest statements)
  "Evaluate the enclosed body only when run on OSX."
  `(when (eq system-type 'darwin)
     ,statement
     ,@statements))

(defmacro gcr/on-windows (statement &rest statements)
  "Evaluate the enclosed body only when run on Microsoft Windows."
  `(when (eq system-type 'windows-nt)
     ,statement
     ,@statements))

(defmacro gcr/on-gui (statement &rest statements)
  "Evaluate the enclosed body only when run on GUI."
  `(when (display-graphic-p)
     ,statement
     ,@statements))

(defmacro gcr/not-on-gui (statement &rest statements)
  "Evaluate the enclosed body only when run on GUI."
  `(when (not (display-graphic-p))
     ,statement
     ,@statements))

(defun beginning-of-line-dwim ()
  "Toggles between moving point to the first non-whitespace character, and
    the start of the line. Src: http://www.wilfred.me.uk/"
  (interactive)
  (let ((start-position (point)))
    ;; see if going to the beginning of the line changes our position
    (move-beginning-of-line nil)

    (when (= (point) start-position)
      ;; we're already at the beginning of the line, so go to the
      ;; first non-whitespace character
      (back-to-indentation))))

(defun gcr/lazy-new-open-line ()
  "Insert a new line without breaking the current line."
  (interactive)
  (beginning-of-line)
  (next-line)
  (newline)
  (previous-line))

(defun gcr/smart-open-line ()
  "Insert a new line, indent it, and move the cursor there.

This behavior is different then the typical function bound to return
which may be `open-line' or `newline-and-indent'. When you call with
the cursor between ^ and $, the contents of the line to the right of
it will be moved to the newly inserted line. This function will not
do that. The current line is left alone, a new line is inserted, indented,
and the cursor is moved there.

Attribution: URL `http://emacsredux.com/blog/2013/03/26/smarter-open-line/'"
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun gcr/narrow-to-region* (boundary-start boundary-end fun)
  "Edit the current region in a new, cloned, indirect buffer.

  This function is responsible for helping the operator to easily
  manipulate a subset of a buffer's contents within a new buffer. The
  newly created clone buffer is created with `clone-indirect-buffer',
  so all of its behaviors apply. You may care specifically about the
  fact that the clone is really just a 'view' of the source buffer, so
  actions performed within the source buffer or its clone(s) are
  actually occurring only within the source buffer itself. When the
  dynamic extent of this function is entered, the operator is prompted
  for a function to call to make upon entering the new buffer. The intent
  is to specify the desired mode for the new buffer, for example by
  calling `scheme-mode', but any function may be called.

  The subset chosen for manipulation is narrowed by
  `narrow-to-region'. When the clone buffer is created, the lines in
  which the start and end of the boundary occur are included at the
  end the new clone buffer name to serve as a reminder for its
  'true source'. The intent is to facilitate going back from the clone
  buffer to the source buffer with knowledge of where it originated.

  BOUNDARY-START and BOUNDARY-END are provided by delegation of this
  function to `interactive'. FUN is provided interactively by the
  operator via the modeline in the same manner. See Info node
  `(elisp) Eval' for more on why `funcall' was used here instead of
  `eval' for calling the selected function.

  Attribution: URL `http://demonastery.org/2013/04/emacs-narrow-to-region-indirect/'
  Attribution: URL `http://paste.lisp.org/display/135818Attribution'"
  (interactive "*r\naMode name? ")
  (let* ((boundary-start (if (< boundary-start 1) (point-min)
                           boundary-start))
         (boundary-end (if (<= boundary-end boundary-start) (point-max)
                         boundary-end))
         (new-name (concat
                    (buffer-name)
                    "⊃"
                    (number-to-string (line-number-at-pos boundary-start))
                    "-"
                    (number-to-string (line-number-at-pos boundary-end))))
         (buf-name (generate-new-buffer-name new-name))
         (fun (if (fboundp fun) fun
                'fundamental-mode)))
    (with-current-buffer (clone-indirect-buffer buf-name +1 +1)
      (narrow-to-region boundary-start boundary-end)
      (deactivate-mark)
      (goto-char (point-min))
      (funcall fun))))

(defun gcr/set-org-system-header-arg (property value)
  "Easily set system header arguments in org mode.

PROPERTY is the system-wide value that you would like to modify.

VALUE is the new value you wish to store.

Attribution: URL `http://orgmode.org/manual/System_002dwide-header-arguments.html#System_002dwide-header-arguments'"
  (setq org-babel-default-header-args
        (cons (cons property value)
              (assq-delete-all property org-babel-default-header-args))))

(defun gcr/insert-ellipsis ()
  "Insert an ellipsis into the current buffer."
  (interactive)
  (insert "…"))

(defun gcr/insert-noticeable-snip-comment-line ()
  "Insert a noticeable snip comment line (NSCL)."
  (interactive)
  (if (not (bolp))
      (message "I may only insert a NSCL at the beginning of a line.")
    (let ((ncl (make-string 70 ?✂)))
      (newline)
      (previous-line)
      (insert ncl)
      (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))

(defun gcr/paste-from-x-clipboard()
  "Intelligently grab clipboard information per OS.

Attribution: URL `http://blog.binchen.org/posts/paste-string-from-clipboard-into-minibuffer-in-emacs.html'"
  (interactive)
  (shell-command
   (cond
    (*cygwin* "getclip")
    (*is-a-mac* "pbpaste")
    (t "xsel -ob")
    )
   1))

(defun gcr/dired-copy-filename ()
  "Push the path and filename of the file under the point to the kill ring.

Attribution: URL `https://lists.gnu.org/archive/html/help-gnu-emacs/2002-10/msg00556.html'"
  (interactive)
  (message "Added %s to kill ring" (kill-new (dired-get-filename))))

(defun gcr/dired-copy-path ()
  "Push the path of the directory under the point to the kill ring."
  (interactive)
  (message "Added %s to kill ring" (kill-new default-directory)))

(defun gcr/ispell-org-header-lines-regexp (h)
  "Help ispell ignore org header lines."
  (interactive)
  (cons (concat "^#\\+" h ":") ".$"))

(defun gcr/ispell-a2isra (block-def)
  "Add to the ispell skip region alist the BLOCK-DEF."
  (interactive)
  (add-to-list 'ispell-skip-region-alist block-def))

(defmacro gcr/diminish (mode)
  "Diminish this mode after it is loaded."
  (interactive)
  `(eval-after-load ,mode
     (diminish ,mode)))

(defun gcr/file-exists-not-symlink (f)
  "True if F exists and is not a symlink."
  (interactive)
  (and (file-exists-p f)
     (not (file-symlink-p f))))

(progn
  (defvar my-read-expression-map
    (let ((map (make-sparse-keymap)))
      (set-keymap-parent map read-expression-map)
      (define-key map [(control ?g)] #'minibuffer-keyboard-quit)
      (define-key map [up]   nil)
      (define-key map [down] nil)
      map))

  (defun my-read--expression (prompt &optional initial-contents)
    (let ((minibuffer-completing-symbol t))
      (minibuffer-with-setup-hook
          (lambda ()
            (emacs-lisp-mode)
            (use-local-map my-read-expression-map)
            (setq font-lock-mode t)
            (funcall font-lock-function 1))
        (read-from-minibuffer prompt initial-contents
                              my-read-expression-map nil
                              'read-expression-history))))

  (defun my-eval-expression (expression &optional arg)
    (interactive (list (read (my-read--expression ""))
                       current-prefix-arg))
    (if arg
        (insert (pp-to-string (eval expression lexical-binding)))
      (pp-display-expression (eval expression lexical-binding)
                             "*Pp Eval Output*"))))

(defun gcr/util-ielm ()
  "Personal buffer setup for ielm.

Creates enough space for one other permanent buffer beneath it."
  (interactive)
  (split-window-below -20)
  (other-window 1)
  (ielm)
  (set-window-dedicated-p (selected-window) t))

(defun gcr/util-eshell ()
  "Personal buffer setup for eshell.

Depends upon `gcr/util-ielm' being run first."
  (interactive)
  (split-window-below -10)
  (other-window 1)
  (eshell)
  (set-window-dedicated-p (selected-window) t))

(defvar gcr/util-state nil "Track whether the util buffers are displayed or not.")

(defun gcr/util-state-toggle ()
  "Toggle the util state."
  (interactive)
  (setq gcr/util-state (not gcr/util-state)))

(defun gcr/util-start ()
  "Perhaps utility buffers."
  (interactive)
  (gcr/util-ielm)
  (gcr/util-eshell)
  (gcr/util-state-toggle))

(defun gcr/util-stop ()
  "Remove personal utility buffers."
  (interactive)
  (if (get-buffer "*ielm*") (kill-buffer "*ielm*"))
  (if (get-buffer "*eshell*") (kill-buffer "*eshell*"))
  (gcr/util-state-toggle))

(defun gcr/util-cycle ()
  "Display or hide the utility buffers."
  (interactive)
  (if gcr/util-state
      (gcr/util-stop)
    (gcr/util-start)))

(defun gcr/ielm-auto-complete ()
  "Enables `auto-complete' support in \\[ielm].

Attribution: URL `http://www.masteringemacs.org/articles/2010/11/29/evaluating-elisp-emacs/'"
  (setq ac-sources '(ac-source-functions
                     ac-source-variables
                     ac-source-features
                     ac-source-symbols
                     ac-source-words-in-same-mode-buffers))
  (add-to-list 'ac-modes 'inferior-emacs-lisp-mode)
  (auto-complete-mode 1))
(defconst gcr/cask-runtime "~/.cask/cask.el")
(defconst gcr/cask-config "~/.emacs.d/Cask")
(defun gcr/warn-cask-runtime ()
  "Warn of Cask misconfiguration."
  (interactive)
  (unless (gcr/file-exists-not-symlink gcr/cask-runtime)
    (warn
     "Can't seem to find a Cask runtime where it was expected at: %S."
     gcr/cask-runtime))
  (unless (file-readable-p gcr/cask-config)
    (warn
     "Can't seem to find a readable Cask configuration where it was expected at: %S."
     gcr/cask-config)))
(gcr/warn-cask-runtime)
(require 'cask gcr/cask-runtime)
(defconst gcr/cask-bundle (cask-initialize))
(require 'el-get)
(setq gcr/el-get-packages nil)
(add-to-list
 'el-get-sources
 '(:name emacs-name
          :type http
          :url "http://www.splode.com/~friedman/software/emacs-lisp/src/emacs-name.el"
          :features emacs-name
          :autoloads nil
          :website "http://www.splode.com/"
          :description "emacs acronym expansions"))
(add-to-list 'gcr/el-get-packages 'emacs-name)
(add-to-list
 'el-get-sources
 '(:name flame
          :type http
          :url "http://www.splode.com/~friedman/software/emacs-lisp/src/flame.el"
          :features flame
          :autoloads nil
          :website "http://www.splode.com/"
          :description "automatic generation of flamage, as if we needed more"))
(add-to-list 'gcr/el-get-packages 'flame)
(add-to-list
 'el-get-sources
 '(:name horoscope
          :type http
          :url "http://www.splode.com/~friedman/software/emacs-lisp/src/horoscope.el"
          :features horoscope
          :autoloads t
          :website "http://www.splode.com/"
          :description "generate horoscopes"))
(add-to-list 'gcr/el-get-packages 'horoscope)
(add-to-list
 'el-get-sources
 '(:name kibologize
          :type http
          :url "http://www.splode.com/~friedman/software/emacs-lisp/src/kibologize.el"
          :features kibologize
          :autoloads nil
          :website "http://www.splode.com/"
          :description "generate ravings about kibology, in the style of kibo"))
(add-to-list 'gcr/el-get-packages 'kibologize)
(add-to-list
 'el-get-sources
 '(:name shop
          :type http
          :url "http://www.splode.com/~friedman/software/emacs-lisp/src/shop.el"
          :features shop
          :autoloads nil
          :website "http://www.splode.com/"
          :description "generate random shopping lists"))
(add-to-list 'gcr/el-get-packages 'shop)
(add-to-list
 'el-get-sources
 '(:name youwill
          :type http
          :url "http://www.splode.com/~friedman/software/emacs-lisp/src/youwill.el"
          :features youwill
          :autoloads t
          :website "http://www.splode.com/"
          :description "generate meaningless marketing hype"))
(add-to-list 'gcr/el-get-packages 'youwill)
(add-to-list
 'el-get-sources
 '(:name org-show
          :type http
          :url "https://raw.githubusercontent.com/jkitchin/jmax/master/org-show.org"
          :website "https://github.com/jkitchin/jmax/blob/master/org-show.org"
          :description "simple presentations in org-mode"))
(add-to-list 'gcr/el-get-packages 'org-show)
(add-to-list 'gcr/el-get-packages 'sicp)
(el-get 'sync gcr/el-get-packages)
(require 'exec-path-from-shell)
(gcr/on-osx (exec-path-from-shell-initialize))
(require 'alert)
(setq alert-fade-time 10)
(gcr/on-gui
 (gcr/on-osx
   (setq alert-default-style 'growl)))
(setq alert-reveal-idle-time 120)
(gcr/on-windows
 (setq shell-file-name "cmdproxy.exe"))
(defadvice global-set-key (before check-keymapping activate)
  (let* ((key (ad-get-arg 0))
         (new-command (ad-get-arg 1))
         (old-command (lookup-key global-map key)))
    (when
        (and
         old-command
         (not (equal old-command new-command))
         (not (equal old-command 'digit-argument))
         (not (equal old-command 'negative-argument))
         (not (equal old-command 'ns-print-buffer))
         (not (equal old-command 'move-beginning-of-line))
         (not (equal old-command 'execute-extended-command))
         (not (equal new-command 'execute-extended-command))
         (not (equal old-command 'ns-prev-frame))
         (not (equal old-command 'ns-next-frame))
         (not (equal old-command 'mwheel-scroll))
         (not (equal new-command 'diff-hl-mode))
         (not (equal new-command 'my-eval-expression))
         (not (equal old-command 'list-buffers))
         )
      (warn "Just stomped the global-map binding for %S, replaced %S with %S"
            key old-command new-command))))
(require 'key-chord)
(key-chord-mode 1)
;; if there is magic, then the x goes here →
(gcr/on-osx
 (setq mac-control-modifier 'control)
 (setq mac-command-modifier 'meta)
 (setq mac-option-modifier 'super))

(gcr/on-windows
 (setq w32-lwindow-modifier 'super)
 (setq w32-rwindow-modifier 'super))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(setq echo-keystrokes 0.02)
(key-chord-define-global "3." 'gcr/insert-ellipsis)
(key-chord-define-global (concat "A" "{") (lambda () (interactive) (insert "ä")))
(key-chord-define-global (concat "A" "}") (lambda () (interactive) (insert "Ä")))
(key-chord-define-global (concat "O" "{") (lambda () (interactive) (insert "ö")))
(key-chord-define-global (concat "O" "}") (lambda () (interactive) (insert "Ö")))
(key-chord-define-global (concat "U" "{") (lambda () (interactive) (insert "ü")))
(key-chord-define-global (concat "U" "}") (lambda () (interactive) (insert "Ü")))
(key-chord-define-global (concat "<" "_") (lambda () (interactive) (insert "←")))
(key-chord-define-global (concat "_" ">") (lambda () (interactive) (insert "→")))
(key-chord-define-global "<<" (lambda () (interactive) (insert "«")))
(key-chord-define-global ">>" (lambda () (interactive) (insert "»")))
(key-chord-define-global "jk" 'ace-jump-mode)
(key-chord-define-global "ji" 'ace-jump-mode-pop-mark)
(key-chord-define-global "nm" 'ace-window)
(key-chord-define-global "fj" 'goto-line)
(require 'linum-relative)
(key-chord-define-global "dk" 'linum-relative-toggle)
(key-chord-define-global "JK" (lambda () (interactive) (other-window 1)))
(key-chord-define-global "KL" (lambda () (interactive) (next-buffer)))
(key-chord-define-global "L:" (lambda () (interactive) (previous-buffer)))
(key-chord-define-global "ws" 'google-this-mode-submap)
(global-set-key (kbd "C-a") 'beginning-of-line-dwim)
(global-set-key (kbd "C-;") 'vc-next-action)
(global-set-key (kbd "C-'") 'er/expand-region)
(global-set-key (kbd "M-9") 'mc/edit-lines)
(global-set-key (kbd "M-0") 'mc/mark-next-like-this)
(global-set-key (kbd "M--") 'mc/mark-all-like-this)
(global-set-key (kbd "M-8") 'mc/mark-previous-like-this)
(key-chord-define-global "yu" 'move-text-up)
(key-chord-define-global "hj" 'move-text-down)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "s-p") 'gcr/describe-thing-in-popup)
(global-set-key (kbd "C--") 'ace-window)
(global-set-key (kbd "C-3") 'auto-complete)
(global-set-key (kbd "M-3") 'hs-toggle-hiding)
(global-set-key (kbd "C-5") 'gcr/comment-or-uncomment)
(global-set-key (kbd "M-<return>") 'gcr/lazy-new-open-line)
(global-set-key (kbd "s-d h") 'diff-hl-mode)
(global-set-key (kbd "s-d l") 'vc-diff)
(global-set-key (kbd "s-d u") 'vc-revert)
(global-set-key (kbd "M-:") 'my-eval-expression)
(global-set-key (kbd "s-f") 'projectile-find-file)
(global-set-key (kbd "C-4") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-7") 'gcr/insert-timestamp)
(global-set-key (kbd "M-7") 'gcr/insert-datestamp)
(global-set-key (kbd "s-<tab>") 'auto-complete)
(gcr/on-gui
 (global-set-key (kbd "s-<f7>") 'gcr/text-scale-increase)
 (global-set-key (kbd "M-<f7>") 'gcr/text-scale-decrease))
(global-set-key (kbd "C-<f2>") 'emacs-index-search)
(global-set-key (kbd "S-<f2>") 'elisp-index-search)
(global-set-key (kbd "C-<f3>") 'imenu-anywhere)
(global-set-key (kbd "s-<up>") 'enlarge-window)
(global-set-key (kbd "s-<down>") 'shrink-window)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "<f8>") 'list-world-time)
(global-set-key (kbd "<f9>") 'gcr/util-cycle)
(defconst gcr/ditaa-jar (concat (getenv "EELIB") "/ditaa0_9.jar"))
(defun gcr/warn-ditaa-jar ()
  "Warn of ditaa misconfiguration."
  (interactive)
  (unless (f-exists? gcr/ditaa-jar)
    (warn
     "Can't seem to find a ditaa jar where it was expected at: %S. Ditaa will not function without it. Download a copy here: http://sourceforge.net/projects/ditaa/"
     gcr/ditaa-jar)))
(gcr/warn-ditaa-jar)
(setq org-ditaa-jar-path gcr/ditaa-jar)
(add-to-list 'auto-mode-alist '("\\.asc" . artist-mode))
(add-to-list 'auto-mode-alist '("\\.art" . artist-mode))
(add-to-list 'auto-mode-alist '("\\.asc" . artist-mode))
(setq org-list-allow-alphabetical +1)
(require 'org)
(require 'ox-beamer)
(require 'ox-md)
(require 'htmlize)
(let ((pkg 'org-show))
  (if (not (el-get-package-is-installed pkg))
      (warn "You wanted %S to be installed, but it isnt. Fix this." pkg)
    (let ((fil (concat (el-get-package-directory pkg) "org-show.el")))
      (if (not (f-exists? fil))
          (warn "You wanted %S to exist, but it doesn't. Fix this." fil)
        (load fil)))))
(defconst gcr/org-version "8.2.7a")

(defun gcr/warn-org-version ()
  "Warn of org misconfiguration."
  (interactive)
  (when (not (version= (org-version) gcr/org-version))
    (warn "Insufficient org-mode requirements. Expected %S. Found: %S " gcr/org-version (org-version))))
(gcr/warn-org-version)
(setq org-export-coding-system 'utf-8)
(setq org-export-preserve-breaks nil)
(require 'org2blog-autoloads)
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "REVIEW" "DONE")))
(setq org-startup-with-inline-images (display-graphic-p))
(setq org-export-copy-to-kill-ring nil)
(setq org-completion-use-ido +1)
(setq org-use-speed-commands +1)
(setq org-confirm-shell-link-function 'y-or-n-p)
(setq org-confirm-elisp-link-function 'y-or-n-p)
(setq org-enforce-todo-dependencies +1)
(gcr/on-gui
 (require 'org-mouse))
(setq org-pretty-entities +1)
(setq org-ellipsis "…")
(setq org-hide-leading-stars +1)
(setq org-fontify-emphasized-text +1)
(setq org-highlight-latex-and-related '(latex script entities))
(require 'org-ac)
(org-ac/config-default)
(setq org-footnote-define-inline +1)
(setq org-footnote-auto-label 'random)
(setq org-footnote-auto-adjust nil)
(setq org-footnote-section nil)
(setq org-catch-invisible-edits 'error)
(setq org-loop-over-headlines-in-active-region t)
(setq org-export-with-toc nil)
(setq org-startup-folded "nofold")
(setq org-image-actual-width t)
(setq org-hide-emphasis-markers +1)
(defun gcr/org-babel-after-execute-hook ()
  "Personal settings for the `'org-babel-after-execute-hook'."
  (interactive)
  (org-display-inline-images nil t))

(add-hook 'org-babel-after-execute-hook 'gcr/org-babel-after-execute-hook)
(require 'ob-sml nil 'noerror)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((calc . t)
   (css . t)
   (dot . t)
   (ditaa . t)
   (emacs-lisp . t)
   (js . t)
   (latex . t)
   (lilypond . t)
   (makefile . t)
   (org . t)
   (perl . t)
   (python . t)
   (plantuml . t)
   (R . t)
   (scheme . t)
   (sh . t)
   (sml . t)))
(setq org-confirm-babel-evaluate nil)
(setq org-babel-use-quick-and-dirty-noweb-expansion nil)
(setq org-src-fontify-natively nil)
(setq org-src-preserve-indentation +1)
(setq org-src-strip-leading-and-trailing-blank-lines nil)
(setq org-edit-src-content-indentation 0)
(add-to-list
 'org-structure-template-alist
 '("el" "#+begin_src emacs-lisp\n?\n#+end_src" "<src lang=\"emacs-lisp\">\n?\n</src>"))
(add-to-list
 'org-structure-template-alist
 '("r" "#+begin_src R\n?\n#+end_src" "<src lang=\"R\"></src>"))
(mapc (lambda (asc)
        (let ((org-sce-dc (downcase (nth 1 asc))))
          (setf (nth 1 asc) org-sce-dc)))
      org-structure-template-alist)
(defadvice org-babel-tangle (before org-babel-tangle-before activate)
  (gcr/save-all-file-buffers)
  (message (concat "org-babel-tangle BEFORE: <"
                   (format-time-string "%Y-%m-%dT%T%z")
                   ">")))

(defadvice org-babel-tangle (after org-babel-tangle-after activate)
  (message (concat "org-babel-tangle AFTER: <"
                   (format-time-string "%Y-%m-%dT%T%z")
                   ">"))
  (alert "Your tangling is complete." :title "org-mode"))

(defadvice org-ascii-export-as-ascii (before org-ascii-export-as-ascii-before activate)
  (gcr/save-all-file-buffers))

(defadvice org-html-export-to-html (before before-org-html-export-to-html activate)
  (gcr/save-all-file-buffers)
  (message (concat "org-html-export-to-html BEFORE: <"
                   (format-time-string "%Y-%m-%dT%T%z")
                   ">")))

(defadvice org-html-export-to-html (after after-org-html-export-to-html activate)
  (message (concat "org-html-export-to-html AFTER: <"
                   (format-time-string "%Y-%m-%dT%T%z")
                   ">")))
(defun sacha/org-html-checkbox (checkbox)
  "Format CHECKBOX into HTML. http://sachachua.com/blog/2014/03/emacs-tweaks-export-org-checkboxes-using-utf-8-symbols/?shareadraft=baba27119_533313c944f64"
  (case checkbox (on "<span class=\"check\">&#x2611;</span>") ; checkbox (checked)
        (off "<span class=\"checkbox\">&#x2610;</span>")
        (trans "<code>[-]</code>")
        (t "")))

(defadvice org-html-checkbox (around sacha activate)
  (setq ad-return-value (sacha/org-html-checkbox (ad-get-arg 0))))

(defun gcr/warn-org-html-checkbox-type ()
  "Report new feature availability."
  (interactive)
  (when (boundp 'org-html-checkbox-type)
    (warn "Org mode now supports HTML export to unicode checkboxes. Please update your configuration to use the variable 'org-html-checkbox-type'.")))
(gcr/warn-org-html-checkbox-type)

(defadvice org-latex-export-to-pdf (before org-latex-export-to-pdf-before activate)
  (gcr/save-all-file-buffers))
(setq org2blog/wp-blog-alist
      '(("wisdomandwonder"
         :url "http://www.wisdomandwonder.com/wordpress/xmlrpc.php"
         :username "admin"
         :default-title "Title goes here"
         :default-categories ("Article")
         :tags-as-categories nil
         :confirm t
         :show 'show
         :keep-new-lines nil
         :wp-latex t
         :wp-code nil
         :track-posts (list "~/wnw.org2blog.org" "Posts"))))
(let* ((allowed '(exports
                  file
                  noweb
                  noweb-ref
                  session
                  tangle))
       (new-ls
        (--filter (member (car it) allowed)
                  org-babel-common-header-args-w-values)))
  (setq org-babel-common-header-args-w-values new-ls))
(setq org-export-babel-evaluate 'inline-only)
(setq org-babel-min-lines-for-block-output 0)
(setq org-edit-src-auto-save-idle-delay 1)
(setq org-src-window-setup 'current-window)
(setq org-babel-results-keyword "NAME")
(setq org-babel-no-eval-on-ctrl-c-ctrl-c +1)
(setq org-babel-noweb-wrap-start "«")
(setq org-babel-noweb-wrap-end "»")
(gcr/set-org-system-header-arg :comments "link")
(add-to-list 'ispell-skip-region-alist '("^#\\+begin_src ". "#\\+end_src$"))
(add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC ". "#\\+END_SRC$"))
(add-to-list 'ispell-skip-region-alist '("^#\\+begin_example ". "#\\+end_example$"))
(add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXAMPLE ". "#\\+END_EXAMPLE$"))
(add-to-list 'ispell-skip-region-alist '("\:PROPERTIES\:$" . "\:END\:$"))
(add-to-list 'ispell-skip-region-alist '("\\[fn:.+:" . "\\]"))
(add-to-list 'ispell-skip-region-alist '("^http" . "\\]"))
(add-to-list 'ispell-skip-region-alist '("=.*" . ".*="))
(add-to-list 'ispell-skip-region-alist '("- \\*.+" . ".*\\*: "))
(let (void)
  (--each
      '("ATTR_LATEX"
        "AUTHOR"
        "CREATOR"
        "DATE"
        "DESCRIPTION"
        "EMAIL"
        "EXCLUDE_TAGS"
        "HTML_CONTAINER"
        "HTML_DOCTYPE"
        "HTML_HEAD"
        "HTML_HEAD_EXTRA"
        "HTML_LINK_HOME"
        "HTML_LINK_UP"
        "HTML_MATHJAX"
        "INFOJS_OPT"
        "KEYWORDS"
        "LANGUAGE"
        "LATEX_CLASS"
        "LATEX_CLASS_OPTIONS"
        "LATEX_HEADER"
        "LATEX_HEADER_EXTRA"
        "OPTIONS"
        "SELECT_TAGS"
        "STARTUP"
        "TITLE")
    (gcr/ispell-a2isra (gcr/ispell-org-header-lines-regexp it))))
(defun gcr/org-mode-hook ()
  (local-set-key (kbd "C-1") 'org-narrow-to-subtree)
  (local-set-key (kbd "M-1") 'widen)
  (local-set-key (kbd "C-2") 'org-edit-special)
  (local-set-key (kbd "s-h") 'org-babel-check-src-block)
  (local-set-key (kbd "s-j") 'org-babel-demarcate-block)
  (local-set-key (kbd "s-i") 'org-babel-insert-header-arg)
  (local-set-key (kbd "s-k") 'org-babel-previous-src-block)
  (local-set-key (kbd "s-l") 'org-babel-next-src-block)
  (local-set-key (kbd "s-;") 'org-babel-view-src-block-info)
  (local-set-key (kbd "s-b s") 'org-babel-switch-to-session)
  (local-set-key (kbd "s-b c") 'org-babel-switch-to-session-with-code)
  (local-set-key (kbd "s-x") 'org-babel-do-key-sequence-in-edit-buffer)
  (local-set-key (kbd "s-t") 'org-babel-tangle)
  (local-set-key (kbd "s-e") 'org-babel-execute-maybe)
  (when (and (fboundp 'guide-key-mode) guide-key-mode)
    (guide-key/add-local-guide-key-sequence "C-c")
    (guide-key/add-local-guide-key-sequence "C-c C-x")
    (guide-key/add-local-highlight-command-regexp "org-"))
  (org2blog/wp-mode)
  (gcr/diminish 'org2blog/wp-mode)
  (fci-mode)
  (gcr/untabify-buffer-hook))

(add-hook 'org-mode-hook 'gcr/org-mode-hook)
(defun gcr/org-src-mode-hook ()
  (local-set-key (kbd "C-2") 'org-edit-src-exit))

(add-hook 'org-src-mode-hook 'gcr/org-src-mode-hook)
(defconst gcr/keyfreq-file "~/.emacs.keyfreq")
(defun gcr/warn-keyfreq-file ()
  "Warn of keyfreq misconfiguration."
  (interactive)
  (unless (f-symlink? gcr/keyfreq-file)
    (warn "Can't seem to find a symlink at: %S. Keyfreq expeced it there, and will continue to function, but your data will probably be lost." gcr/keyfreq-file)))
(gcr/warn-keyfreq-file)
(require 'keyfreq)
(setq keyfreq-file gcr/keyfreq-file)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

;; Org\ Only\ System:1 ends here
