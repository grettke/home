
(when (or
       (not (= emacs-major-version 24))
       (not (= emacs-minor-version 3)))
  (display-warning
   'platform
   (concat
    "Insufficient requirements. Expected v24.3. Found v"
    (number-to-string emacs-major-version) "."
    (number-to-string emacs-minor-version) ".")
   :emergency))
(setq-default user-full-name "Grant Rettke"
              user-mail-address "gcr@wisdomandwonder.com")

(setq-default eval-expression-print-level nil)
(setq-default case-fold-search nil)
;; TODO: Move this to a lib section after Cask (require 'xml-rpc)
(setq gc-cons-threshold (* 25 1024 1024))
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

Attribution: URL http://www.emacswiki.org/emacs/PosTip
Attribution: URL http://blog.jenkster.com/2013/12/popup-help-in-emacs-lisp.html"
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

(defun gcr/smart-open-line ()
  "Insert a new line, indent it, and move the cursor there.

This behavior is different then the typical function bound to return
which may be `open-line' or `newline-and-indent'. When you call with
the cursor between ^ and $, the contents of the line to the right of
it will be moved to the newly inserted line. This function will not
do that. The current line is left alone, a new line is inserted, indented,
and the cursor is moved there.

Attribution: URL http://emacsredux.com/blog/2013/03/26/smarter-open-line/"
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

Attribution: URL http://orgmode.org/manual/System_002dwide-header-arguments.html#System_002dwide-header-arguments
"
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

Attribution: URL http://blog.binchen.org/posts/paste-string-from-clipboard-into-minibuffer-in-emacs.html"
  (interactive)
  (shell-command
   (cond
    (*cygwin* "getclip")
    (*is-a-mac* "pbpaste")
    (t "xsel -ob")
    )
   1))
(let ((cask-runtime "~/.cask/cask.el"))
  (when (not (file-exists-p cask-runtime))
    (warn (concat "Can't seem to find a Cask runtime file where it was expected "
                  "at: " cask-runtime " .")))
  (require 'cask cask-runtime))
(defconst gcr/cask-bundle (cask-initialize))
(require 'exec-path-from-shell)
(gcr/on-osx (exec-path-from-shell-initialize))
(require 'alert)
(setq alert-fade-time 10)
(gcr/on-gui
 (gcr/on-osx
   (setq alert-default-style 'growl)))
(setq alert-reveal-idle-time 120)
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
         )
      (warn "Just stomped the global-map binding for %S, replaced %S with %S"
            key old-command new-command))))
(require 'key-chord)
(key-chord-mode 1)
;; magic x goes here →x
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
(key-chord-define-global "nm" 'ace-window)
(key-chord-define-global "fj" 'goto-line)
(key-chord-define-global "JK" (lambda () (interactive) (other-window 1)))
(key-chord-define-global "KL" (lambda () (interactive) (next-buffer)))
(key-chord-define-global "L:" (lambda () (interactive) (previous-buffer)))
(global-set-key (kbd "C-a") 'beginning-of-line-dwim)
(global-set-key (kbd "C-;") 'vc-next-action)
(global-set-key (kbd "C-'") 'er/expand-region)
(global-set-key (kbd "M-9") 'mc/edit-lines)
(global-set-key (kbd "M-0") 'mc/mark-next-like-this)
(global-set-key (kbd "M--") 'mc/mark-all-like-this)
(global-set-key (kbd "M-8") 'mc/mark-previous-like-this)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "s-p") 'gcr/describe-thing-in-popup)
(global-set-key (kbd "C--") 'ace-window)
(global-set-key (kbd "C-3") 'auto-complete)
(global-set-key (kbd "C-4") 'yas/expand)
(global-set-key (kbd "C-5") 'gcr/comment-or-uncomment)
(global-set-key (kbd "s-d h") 'diff-hl-mode)
(global-set-key (kbd "s-d l") 'vc-diff)
(global-set-key (kbd "s-d u") 'vc-revert)
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
(let ((ditaa-jar "~/java/jar/ditaa0_9.jar"))
  (when (not (file-exists-p ditaa-jar))
    (warn (concat "Can't seem to find a ditaa runtime file where it was "
                  "expected at: " ditaa-jar
                  ". Download a copy here: http://sourceforge.net/projects/ditaa/")))
  (setq org-ditaa-jar-path ditaa-jar))
(setq org-list-allow-alphabetical +1)
(require 'org)
(require 'ox-beamer)
(require 'ox-md)
(require 'htmlize)

(setq org-export-coding-system 'utf-8)

(setq org-export-preserve-breaks nil)

;; (require 'org2blog-autoloads)

(defun gcr/org-mode-hook ()
  (fci-mode)
  (gcr/untabify-buffer-hook)
  (local-set-key (kbd "C-1") 'org-narrow-to-subtree)
  (local-set-key (kbd "M-1") 'widen)
  (local-set-key (kbd "C-2") 'org-edit-special)
;;  (org2blog/wp-mode)
  )

(add-hook 'org-mode-hook 'gcr/org-mode-hook)

(defun gcr/org-src-mode-hook ()
  (local-set-key (kbd "C-2") 'org-edit-src-exit))

(add-hook 'org-src-mode-hook 'gcr/org-src-mode-hook)

(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "REVIEW" "DONE")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((css . t)
   (dot . t)
   (ditaa . t)
   (emacs-lisp . t)
   (js . t)
   (latex . t)
   (lilypond . t)
   (makefile . t)
   (org . t)
   (python . t)
   (plantuml . t)
   (R . t)
   (scheme . t)
   (sh . t)))

(setq org-confirm-babel-evaluate nil)

(setq org-babel-use-quick-and-dirty-noweb-expansion nil)

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

(setq org-src-fontify-natively nil)

(setq org-fontify-emphasized-text +1)

(setq org-src-preserve-indentation +1)

(setq org-edit-src-content-indentation 0)

(setq org-highlight-latex-and-related '(latex script entities))

(mapc (lambda (asc)
        (let ((org-sce-dc (downcase (nth 1 asc))))
          (setf (nth 1 asc) org-sce-dc)))
      org-structure-template-alist)

(when (not (version= (org-version) "8.2.7a"))
  (display-warning
   'org-mode
   (concat
    "Insufficient requirements. Expected 8.2.7a. Found " (org-version))
   :emergency))

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

(when (boundp 'org-html-checkbox-type)
  (display-warning
   'org-mode
   "Org mode now supports HTML export to unicode checkboxes. Please update your configuration to use the variable 'org-html-checkbox-type'."
   :warning))

(defadvice org-latex-export-to-pdf (before org-latex-export-to-pdf-before activate)
  (gcr/save-all-file-buffers))

(defun sacha/org-html-checkbox (checkbox)
  "Format CHECKBOX into HTML. http://sachachua.com/blog/2014/03/emacs-tweaks-export-org-checkboxes-using-utf-8-symbols/?shareadraft=baba27119_533313c944f64"
  (case checkbox (on "<span class=\"check\">&#x2611;</span>") ; checkbox (checked)
        (off "<span class=\"checkbox\">&#x2610;</span>")
        (trans "<code>[-]</code>")
        (t "")))

(defadvice org-html-checkbox (around sacha activate)
  (setq ad-return-value (sacha/org-html-checkbox (ad-get-arg 0))))

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
(setq org-babel-tangle-comment-format-beg "line %start-line in %file\n[[%link][%start-line, %file]]")
(setq org-babel-tangle-comment-format-end (make-string 77 ?=))
(require 'org-ac)
(org-ac/config-default)
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
(setq org-footnote-define-inline +1)
(setq org-footnote-auto-label 'random)
(setq org-footnote-auto-adjust nil)
(setq org-footnote-section nil)
(setq org-catch-invisible-edits 'error)
(setq org-loop-over-headlines-in-active-region t)
(add-to-list 'ispell-skip-region-alist '("#\\+begin_src". "#\\+end_src"))
(gcr/on-gui
  (defconst gcr/font-base "DejaVu Sans Mono" "The preferred font name.")
  (defvar gcr/font-size 10 "The preferred font size.")
  (gcr/on-osx (setq gcr/font-size 17))
  (setq solarized-distinct-fringe-background +1)
  (setq solarized-high-contrast-mode-line +1)
  (setq solarized-use-less-bold +1)
  (setq solarized-use-more-italic nil)
  (setq solarized-emphasize-indicators nil)
  (load-theme 'solarized-dark)
  (require 'pretty-mode)
  (setq make-pointer-invisible +1)
  (defun gcr/font-ok-p ()
    "Is the configured font valid?"
    (interactive)
    (member gcr/font-base (font-family-list)))
  (defun gcr/font-name ()
    "Compute the font name and size string."
    (interactive)
    (let* ((size (number-to-string gcr/font-size))
           (name (concat gcr/font-base "-" size)))
      name))
  (defun gcr/update-font ()
    "Updates the current font given configuration values."
    (interactive)
    (if (gcr/font-ok-p)
        (progn
          (message "Setting font to: %s" (gcr/font-name))
          (set-default-font (gcr/font-name)))
      (message (concat "Your preferred font is not available: " gcr/font-base))))
  (defun gcr/text-scale-increase ()
    "Increase font size"
    (interactive)
    (setq gcr/font-size (+ gcr/font-size 1))
    (gcr/update-font))
  (defun gcr/text-scale-decrease ()
    "Reduce font size."
    (interactive)
    (when (> gcr/font-size 1)
      (setq gcr/font-size (- gcr/font-size 1))
      (gcr/update-font)))

  (gcr/update-font))
(menu-bar-mode 0)
(setq-default fill-column 80)
(blink-cursor-mode 0)
(gcr/on-gui
 (setq-default cursor-type 'box))
(setq x-stretch-cursor 1)
(global-linum-mode 1)
(global-font-lock-mode 1)
(setq blink-matching-paren nil)
(show-paren-mode +1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(setq ring-bell-function 'ignore)
(setq visible-bell +1)
(winner-mode +1)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(gcr/on-osx
 (defadvice yes-or-no-p (around prevent-dialog activate)
   "Prevent yes-or-no-p from activating a dialog"
   (let ((use-dialog-box nil))
     ad-do-it))

 (defadvice y-or-n-p (around prevent-dialog-yorn activate)
   "Prevent y-or-n-p from activating a dialog"
   (let ((use-dialog-box nil))
     ad-do-it)))
(gcr/on-gui
 (setq frame-title-format '("the ultimate…"))
 (scroll-bar-mode -1)
 (tool-bar-mode 0)
 (setq browse-url-browser-function 'browse-url-generic)
 (gcr/on-gnu/linux (setq browse-url-generic-program "chromium-browser"))
 (gcr/on-osx
  (require 'osx-browse)
  (osx-browse-mode 1))
 (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
 (setq mouse-wheel-progressive-speed nil)
 (require 'pos-tip)
 (setq pos-tip-foreground-color "#073642")
 (setq pos-tip-background-color "#839496")
 (gcr/on-windows
  (pos-tip-w32-max-width-height)))
(desktop-save-mode 1)
(setq desktop-restore-eager 10)
(require 'real-auto-save)
(setq real-auto-save-interval 15)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(add-to-list 'load-path "/usr/share/emacs/site-lisp/ccrypt")
(require 'ps-ccrypt "ps-ccrypt.el")
(setq backup-inhibited 1)
(setq auto-save-default nil)
(add-hook 'write-file-hooks
          (lambda ()
            (gcr/delete-trailing-whitespace)))
(prefer-coding-system 'utf-8)
(gcr/on-gui
 (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))
(require 'undo-tree)
(global-undo-tree-mode 1)
(diminish 'undo-tree-mode)
(setq require-final-newline t)
(global-auto-revert-mode 1)
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(require 'sublimity)
(require 'sublimity-scroll)
(require 'sublimity-map)
(require 'sublimity-attractive)
(sublimity-map-set-delay nil)
(let ((text-buffer (get-buffer-create "*text*")))
  (with-current-buffer text-buffer
    (text-mode)
    (insert "Shall we play a game?")
    (beginning-of-line)))

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(define-key global-map (kbd "C-0") 'ace-jump-mode)
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
(setq isearch-lax-whitespace +1)
(setq isearch-regexp-lax-whitespace +1)
(require 'boxquote)
(setq track-eol +1)
(setq line-move-visual nil)
(size-indication-mode)
(column-number-mode 1)
(setq display-time-format "%R %y-%m-%d")
(display-time-mode +1)
(require 'diminish)
(defadvice kill-line (around kill-line-remove-newline activate)
  (let ((kill-whole-line t))
    ad-do-it))
(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq resize-mini-windows +1)
(setq max-mini-window-height 0.33)
(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode 1)
(defun gcr/minibuffer-setup-hook ()
  "Personal setup."
  (local-set-key "ESC y" 'gcr/paste-from-x-clipboard))

(add-hook 'minibuffer-setup-hook 'gcr/minibuffer-setup-hook)
(require 'fuzzy)
(require 'auto-complete)
(require 'auto-complete-config)
(setq ac-quick-help-prefer-pos-tip nil)
(ac-config-default)
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")
(diminish 'auto-complete-mode)
(require 'whitespace)
(setq whitespace-style '(trailing lines tab-mark))
(setq whitespace-line-column 80)
(global-whitespace-mode 1)
(diminish 'global-whitespace-mode)
(diminish 'whitespace-mode)
(require 'rainbow-mode)
(diminish 'rainbow-mode)
(require 'yasnippet)
(let ((yas-snippet-dir (concat (cask-dependency-path gcr/cask-bundle 'yasnippet)
                               "/snippets")))
  (when (not (file-exists-p yas-snippet-dir))
    (warn (concat "Can't seem to find a yas snippert dir where it was expected "
                  "at: " yas-snippet-dir " .")))
  (yas-load-directory yas-snippet-dir))
(diminish 'yas-minor-mode)
(yas-global-mode 1)
(require 'ido)
(require 'flx-ido)
(ido-mode 1)
(require 'ido-hacks nil +1)
(require 'ido-ubiquitous)
(ido-ubiquitous-mode +1)
(setq ido-create-new-buffer 'always)
(flx-ido-mode +1)
(setq ido-use-faces nil)
(require 'ido-vertical-mode)
(ido-vertical-mode +1)
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)
(projectile-global-mode 1)
(diminish 'projectile-mode)
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(diminish 'smartparens-mode)
(setq sp-show-pair-from-inside nil)
(setq tramp-default-user "gcr")
(setq tramp-default-method "ssh")
(require 'expand-region)
(setq dired-listing-switches "-alh")
(setq dired-recursive-deletes  +1)
(require 'dired-details+)
(setq-default dired-details-hidden-string "")
(defun gcr/dired-mode-hook ()
  "Personal dired customizations."
  (diff-hl-dired-mode)
  (load "dired-x"))
(add-hook 'dired-mode-hook 'gcr/dired-mode-hook)
(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))
(require 'wdired)
(setq wdired-allow-to-change-permissions t)
(setq wdired-allow-to-redirect-links t)
(setq wdired-use-interactive-rename +1)
(setq wdired-confirm-overwrite +1)
(setq wdired-use-dired-vertical-movement 'sometimes)
(let ((savehist-file-store "~/.emacs.d/savehist"))
  (when (not (file-exists-p savehist-file-store))
    (warn (concat "Can't seem to find a savehist store file where it was expected "
                  "at: " savehist-file-store " . Savehist should continue "
                  "to function normally; but your history may be lost.")))
  (setq savehist-file savehist-file-store))
(savehist-mode +1)
(setq savehist-save-minibuffer-history +1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
(setq hs-hide-comments-when-hiding-all +1)
(setq hs-isearch-open +1)
(require 'hideshow-org)
(defun display-code-line-counts (ov)
  "Displaying overlay content in echo area or tooltip"
  (when (eq 'code (overlay-get ov 'hs))
    (overlay-put ov 'help-echo
                 (buffer-substring (overlay-start ov)
                                   (overlay-end ov)))))

(setq hs-set-up-overlay 'display-code-line-counts)
(defadvice goto-line (after expand-after-goto-line activate compile)
  "How do I get it to expand upon a goto-line? hideshow-expand affected block when using goto-line in a collapsed buffer."
  (save-excursion
    (hs-show-block)))
(let ((aspell-dict "~/.aspell.en.pws"))
  (when (not (file-symlink-p aspell-dict))
    (warn
     (concat "aspell needs a symlink from " aspell-dict " to its true location. "
             "Please double check this. The fix might be as simple as: "
             "ln -s ~/git/bitbucket-grettke/home/.aspell.en.pws ~/.aspell.en.pws"))))
(require 'smex)
(smex-initialize)
(require 'multiple-cursors)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq eshell-prefer-lisp-functions nil
      eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'")

(eval-after-load 'esh-opt
  '(progn
     (require 'em-cmpl)
     (require 'em-prompt)
     (require 'em-term)
     (setenv "PAGER" "cat")
     (add-hook 'eshell-mode-hook
               (lambda ()
                 (message "Protovision… I have you now.")
                 (setq pcomplete-cycle-completions nil)))
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))))

(let ((eshell-dir "~/.emacs.d/eshell"))
  (when (not (file-symlink-p eshell-dir))
    (warn
     (concat "eshell needs a symlink from " eshell-dir " to its true location. "
             "Please double check this. The fix might be as simple as: "
             "ln -s ~/git/bitbucket-grettke/home/eshell/ ~/.emacs.d/eshell"))))

(setq eshell-prompt-regexp "^.+@.+:.+> ")
(setq eshell-prompt-function
      (lambda ()
        (concat
         (user-login-name)
         "@"
         (system-name)
         ":"
         (eshell/pwd)
         "> ")))
(setq auto-mode-alist
      (append
       '(("\\.scm\\'" . scheme-mode)
         ("\\.rkt\\'" . scheme-mode)
         ("\\.ss\\'" . scheme-mode)
         ("\\.sls\\'" . scheme-mode)
         ("\\.sps\\'" . scheme-mode)
         ("\\.html\\'" . web-mode)
         ("\\.json\\'" . web-mode)
         ("\\.asc" . artist-mode)
         ("\\.art" . artist-mode)
         ("\\.asc" . artist-mode))
       auto-mode-alist))
(require 'fancy-narrow)
(require 'imenu-anywhere)
(require 'auto-complete-chunk)
(defun gcr/text-mode-hook ()
  (rainbow-mode)
  (turn-on-real-auto-save)
  (fci-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook))

(add-hook 'text-mode-hook 'gcr/text-mode-hook)
(defun gcr/log-edit-mode-hook ()
  "Personal mode bindings for log-edit-mode."
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode +1))

(add-hook 'log-edit-mode-hook 'gcr/log-edit-mode-hook)

(defun gcr/log-edit-mode-hook-local-bindings ()
  "Helpful bindings for log edit buffers."
  (local-set-key (kbd "C-;") 'log-edit-done))

(add-hook 'log-edit-mode-hook 'gcr/log-edit-mode-hook-local-bindings)
(defun gcr/graphviz-dot-mode-hook ()
  "Personal mode bindings for Graphviz mode."
  (fci-mode +1)
  (rainbow-mode)
  (visual-line-mode)
  (turn-on-real-auto-save))

(add-hook 'graphviz-dot-mode-hook 'gcr/graphviz-dot-mode-hook)

(let ((f (concat (cask-dependency-path gcr/cask-bundle 'graphviz-dot-mode)
                 "/graphviz-dot-mode.el")))
  (if (file-exists-p f)
      (load-file f)
    (warn "Could not locate a package file for Graphviz support. Expected it here (might be wrong): %s" f)))
(defconst lispy-modes '(emacs-lisp-mode-hook
                        ielm-mode-hook
                        lisp-interaction-mode-hook
                        scheme-mode-hook
                        geiser-repl-mode-hook))

(dolist (h lispy-modes)
  (add-hook h 'rainbow-mode))

(dolist (h lispy-modes)
  (when (not (member h '(ielm-mode-hook)))
    (add-hook h 'turn-on-smartparens-strict-mode)
    (add-hook h 'turn-on-pretty-mode)
    (add-hook h 'gcr/newline)
    (add-hook h 'turn-on-real-auto-save)
    (add-hook h 'gcr/untabify-buffer-hook)
    (add-hook h 'gcr/disable-tabs)
    (add-hook h 'fci-mode)
    (add-hook h 'hs-org/minor-mode +1)
    (add-hook h (function (lambda ()
                            (add-hook 'local-write-file-hooks
                                      'check-parens))))))
(defun gcr/elisp-eval-buffer ()
  "Intelligently evaluate an Elisp buffer."
  (interactive)
  (gcr/save-all-file-buffers)
  (eval-buffer))

(defun gcr/elisp-mode-local-bindings ()
  "Helpful behavior for Elisp buffers."
  (local-set-key (kbd "s-l eb") 'gcr/elisp-eval-buffer)
  (local-set-key (kbd "s-l ep") 'eval-print-last-sexp)
  (local-set-key (kbd "s-l td") 'toggle-debug-on-error)
  (local-set-key (kbd "s-l mef") 'macroexpand)
  (local-set-key (kbd "s-l mea") 'macroexpand-all))

(require 'lexbind-mode)

(defun gcr/elisp-mode-hook ()
  (gcr/elisp-mode-local-bindings)
  (lexbind-mode)
  (turn-on-eldoc-mode))

(add-hook 'emacs-lisp-mode-hook 'gcr/elisp-mode-hook)

(setq initial-scratch-message nil)
(require 'geiser)
(setq geiser-active-implementations '(racket))

(defun gcr/scheme-eval-buffer ()
  "Save and then evaluate the current Scheme buffer with Geiser."
  (interactive)
  (gcr/save-all-file-buffers)
  (geiser-mode-switch-to-repl-and-enter))

(defun gcr/scheme-mode-local-bindings ()
  "Helpful behavior for Scheme buffers."
  (local-set-key (kbd "<f5>") 'gcr/scheme-eval-buffer))

(add-hook 'scheme-mode-hook 'gcr/scheme-mode-local-bindings)
(defun gcr/js-mode-hook ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (setq js-indent-level 2)
  (turn-on-real-auto-save)
  (fci-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook))

(add-hook 'js-mode-hook 'gcr/js-mode-hook)

(let* ((ac-dir (cask-dependency-path gcr/cask-bundle 'auto-complete))
       (f (concat ac-dir "/dict/js-mode")))
  (when (not (file-exists-p f))
    (warn (concat
           "Could not locate a lib file for auto-complete JavaScript support. "
           "You might fix it with: ln -s " ac-dir "/dict/javascript-mode " f))))
(require 'web-mode)

(setq web-mode-enable-block-partial-invalidation t)

(setq web-mode-engines-alist
      '(("ctemplate" . "\\.html$")))

(defun gcr/web-mode-hook ()
  (whitespace-turn-off)
  (rainbow-turn-off)
  (visual-line-mode)
  (local-set-key (kbd "RET") 'newline-and-indent)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-indent-style 2)
  (setq web-mode-style-padding 1)
  (setq web-mode-script-padding 1)
  (setq web-mode-block-padding 0)
  (gcr/untabify-buffer-hook))

(add-hook 'web-mode-hook 'gcr/web-mode-hook)

(require 'json-reformat)
(defun gcr/css-modehook ()
  (fci-mode +1)
  (whitespace-turn-on)
  (rainbow-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook)
  (turn-on-real-auto-save)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'css-mode-hook 'gcr/css-modehook)
(defun gcr/make-modehook ()
  (fci-mode +1)
  (whitespace-turn-on)
  (rainbow-mode)
  (visual-line-mode)
  (turn-on-real-auto-save)
  (visual-line-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'makefile-mode-hook 'gcr/make-modehook)
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" +1)

(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
(defadvice vc-next-action (before save-before-vc first activate)
  "Save all buffers before any VC next-action function calls."
  (gcr/save-all-file-buffers))

(defadvice vc-diff (before save-before-vc-diff first activate)
  "Save all buffers before vc-diff calls."
  (gcr/save-all-file-buffers))

(defadvice vc-revert (before save-before-vc-revert first activate)
  "Save all buffers before vc-revert calls."
  (gcr/save-all-file-buffers))
(diff-hl-mode)
(require 'ess-site)
(setq ess-eldoc-show-on-symbol t)
(setq ess-use-tracebug t)
(setq ess-tracebug-search-path '())
(define-key compilation-minor-mode-map [(?n)] 'next-error-no-select)
(define-key compilation-minor-mode-map [(?p)] 'previous-error-no-select)
(setq ess-watch-scale-amount -1)
(setq ess-describe-at-point-method 'tooltip)
(autoload 'ess-rdired "ess-rdired")
(require 'ess-R-data-view)
(require 'ess-R-object-popup)
(define-key ess-mode-map "\C-c\C-g" 'ess-R-object-popup)
(setq gcr/r-dir "~/.R/")

(setq inferior-ess-program "R")
(setq inferior-R-program-name "R")
(setq ess-local-process-name "R")
(setq inferior-ess-own-frame nil)
(setq inferior-ess-same-window t)
(setq ess-ask-for-ess-directory nil)

(setq comint-scroll-to-bottom-on-input 'this)
(setq comint-scroll-to-bottom-on-output 'others)
(setq comint-show-maximum-output t)
(setq comint-scroll-show-maximum-output t)
(setq comint-move-point-for-output t)
(setq comint-prompt-read-only t)

(setq ess-history-directory gcr/r-dir)

(setq ess-execute-in-process-buffer +1)
(setq ess-switch-to-end-of-proc-buffer t)
(setq ess-eval-visibly nil)

(setq ess-tab-complete-in-script +1)
(setq ess-first-tab-never-complete 'symbol-or-paren-or-punct)

(setq ess-source-directory gcr/r-dir)

(setq ess-help-own-frame nil)

(setq ess-use-ido t)

(add-to-list 'auto-mode-alist '("\\.rd\\'" . Rd-mode))

(setq ess-use-eldoc t)
(setq ess-eldoc-show-on-symbol t)
(setq ess-eldoc-abbreviation-style 'normal)

(local-set-key (kbd "C-c C-. S") 'ess-rutils-rsitesearch)

(require 'ess-rutils)
(setq ess-rutils-keys +1)

(require 'r-autoyas)

(setq r-autoyas-debug t)
(setq r-autoyas-expand-package-functions-only nil)
(setq r-autoyas-remove-explicit-assignments nil)
(setq r-autoyas-number-of-commas-before-return 0)

(defun gcr/ess-mode-hook ()
  (ess-set-style 'RRR 'quiet)
  (turn-on-pretty-mode)
  (local-set-key (kbd "<f7>") 'ess-describe-object-at-point)
  (r-autoyas-ess-activate)
  (visual-line-mode)
  (lambda () (add-hook 'ess-presend-filter-functions
                       (lambda ()
                         (display-warning
                          'ess-mode
                          "ESS now supports a standard pre-send filter hook. Please update your configuration to use it instead of using advice."
                          :warning)))))

(add-hook 'ess-mode-hook 'gcr/ess-mode-hook)

(defun gcr/Rd-mode-hook ()
  (gcr/ess-mode-hook))

(add-hook 'Rd-mode-hook 'gcr/Rd-mode-hook)

(add-to-list 'auto-mode-alist '("\\.Rmd$" . r-mode))

(defun gcr/inferior-ess-mode-hook ()
  (gcr/ess-mode-hook))

(add-hook 'inferior-ess-mode-hook 'gcr/inferior-ess-mode-hook)
(setq ess-keep-dump-files +1)
(setq ess-delete-dump-files nil)
(setq ess-mode-silently-save +1)
(defadvice ess-eval-region-or-line-and-step (before before-ess-eval-region-or-line-and-step activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-region-or-function-or-paragraph (before before-ess-eval-region-or-function-or-paragraph activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-region-or-function-or-paragraph-and-step (before before-ess-eval-region-or-function-or-paragraph-and-step activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-line (before before-ess-eval-line activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-line-and-go (before before-ess-eval-line-and-go activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-function (before before-ess-eval-function activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-function-and-go (before before-ess-eval-function-and-go activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-region (before before-ess-eval-region activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-region-and-go (before before-ess-eval-region-and-go activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-buffer (before before-ess-eval-buffer activate)
  (gcr/save-all-file-buffers))

(defadvice ess-eval-buffer-and-go (before before-ess-eval-buffer-and-go activate)
  (gcr/save-all-file-buffers))
(setq inferior-R-args "--no-save --no-restore")
(sp-local-pair 'ess-mode "{" nil :post-handlers '((gcr/indent-curly-block "RET")))
(ace-link-setup-default)
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
(eval-after-load 'tramp
  '(vagrant-tramp-enable))
(defun gcr/ruby-mode-hook ()
  (fci-mode +1)
  (rainbow-mode)
  (gcr/untabify-buffer-hook)
  (turn-on-real-auto-save)
  (visual-line-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'ruby-mode-hook 'gcr/ruby-mode-hook)
(require 'erc)

(setq gcr/erc-after-connect-hook-BODY nil)

(defun gcr/erc-after-connect-hook ()
  (gcr/erc-after-connect-hook-BODY))

(add-hook 'erc-after-connect 'gcr/erc-after-connect-hook)

(defun gcr/irc ()
  "Connect to my preferred IRC network."
  (interactive)
  (let ((file "~/.irc.el"))
    (when (not (file-exists-p file))
      (warn (concat "Can't seem to find an ERC credential file at: " file)))
    (with-temp-buffer
      (insert-file-contents file)
      (let ((grettke-irc-freenode-net-password (buffer-string)))
        (erc
         :server "irc.freenode.net"
         :port "6667"
         :nick "grettke"
         :password grettke-irc-freenode-net-password
         :full-name "Grant Rettke")
        (let ((gcr/erc-after-connect-hook-IMPL
               (lambda ()
                 (message "It ran…")
                 (erc-message
                  "PRIVMSG"
                  (concat "NickServ identify "
                          grettke-irc-freenode-net-password)))))
          (setq gcr/erc-after-connect-hook-BODY gcr/erc-after-connect-hook-IMPL))))))

(define-key erc-mode-map (kbd "C-c C-RET") 'erc-send-current-line)
(require 'erc-autoaway)
(add-to-list 'erc-modules 'autoaway)
(setq erc-autoaway-idle-seconds 600)
(setq erc-autoaway-message "autoaway just demanded that I step out now")
(setq erc-auto-set-away +1)
(erc-update-modules)
(require 'erc-join)
(erc-autojoin-mode +1)
(setq erc-autojoin-channels-alist
      '((".*freenode.net" "#emacs" "#org-mode" "#scheme" "#r")))
(require 'erc-button)
(erc-button-mode +1)
(setq erc-button-wrap-long-urls  nil
      erc-button-buttonize-nicks nil)
(require 'erc-fill)
(erc-fill-mode +1)
(setq erc-fill-column 72)
(setq erc-fill-function 'erc-fill-static)
(setq erc-fill-static-center 0)
(erc-irccontrols-enable)
(setq erc-current-nick-highlight-type 'keyword)
(setq erc-pals '("leppie"))
(setq erc-fools '("lamer" "dude"))
(remove-hook 'erc-text-matched-hook 'erc-hide-fools)
(require 'erc-netsplit)
(erc-netsplit-mode 1)
(add-to-list 'erc-modules 'notify)
(erc-update-modules)
(add-to-list 'erc-modules 'page)
(require 'erc-page)
(erc-page-mode 1)
(erc-update-modules)
(require 'erc-ring)
(erc-ring-mode 1)
(add-to-list 'erc-modules 'scrolltobottom)
(erc-update-modules)
(add-to-list 'erc-modules 'stamp)
(require 'erc-stamp)
(erc-stamp-mode 1)
(setq erc-insert-timestamp-function      'erc-insert-timestamp-left
      erc-timestamp-only-if-changed-flag t
      erc-timestamp-format               "[%H:%M] "
      erc-insert-away-timestamp-function 'erc-insert-timestamp-left
      erc-away-timestamp-format          "<%H:%M> ")
(erc-update-modules)
(add-to-list 'erc-modules 'track)
(require 'erc-track)
(setq erc-track-switch-direction 'importance)
(setq erc-track-exclude-types
      '("324" "329" "332" "333" "353"
        "JOIN" "NAMES" "NICK" "QUIT" "PART" "TOPIC"))
(setq erc-track-position-in-mode-line +1)
(defvar erc-channels-to-visit nil
  "Channels that have not yet been visited by erc-next-channel-buffer")
(defun erc-next-channel-buffer ()
  "Switch to the next unvisited channel. See erc-channels-to-visit"
  (interactive)
  (when (null erc-channels-to-visit)
    (setq erc-channels-to-visit
          (remove (current-buffer) (erc-channel-list nil))))
  (let ((target (pop erc-channels-to-visit)))
    (if target
        (switch-to-buffer target))))
(erc-update-modules)
(require 'erc-tweet)
(add-to-list 'erc-modules 'tweet)
(erc-update-modules)
(require 'erc-image)
(add-to-list 'erc-modules 'image)
(erc-update-modules)
(require 'erc-youtube)
(add-to-list 'erc-modules 'youtube)
(erc-update-modules)
(require 'erc-hl-nicks)
(add-to-list 'erc-modules 'hl-nicks)
(erc-update-modules)
(eval-after-load "dash" '(dash-enable-font-lock))
(require 'figlet)
(global-visual-line-mode 1)
(diminish 'visual-line-mode)
(diminish 'global-visual-line-mode)
