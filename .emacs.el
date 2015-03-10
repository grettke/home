
(setq load-prefer-newer t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(display-time-world-list (quote (("America/Chicago" "Chicago") ("Asia/Kolkata" "Kolkata") ("Asia/Kuala_Lumpur" "Kuala Lumpur"))))
 '(ess-R-font-lock-keywords (quote ((ess-R-fl-keyword:modifiers . t) (ess-R-fl-keyword:fun-defs . t) (ess-R-fl-keyword:keywords . t) (ess-R-fl-keyword:assign-ops . t) (ess-R-fl-keyword:constants . t) (ess-fl-keyword:fun-calls) (ess-fl-keyword:numbers) (ess-fl-keyword:operators) (ess-fl-keyword:delimiters) (ess-fl-keyword:= . t) (ess-R-fl-keyword:F&T))))
 '(inferior-R-font-lock-keywords (quote ((ess-S-fl-keyword:prompt . t) (ess-R-fl-keyword:messages . t) (ess-R-fl-keyword:modifiers . t) (ess-R-fl-keyword:fun-defs . t) (ess-R-fl-keyword:keywords . t) (ess-R-fl-keyword:assign-ops . t) (ess-R-fl-keyword:constants . t) (ess-fl-keyword:matrix-labels . t) (ess-fl-keyword:fun-calls) (ess-fl-keyword:numbers) (ess-fl-keyword:operators) (ess-fl-keyword:delimiters) (ess-fl-keyword:= . t) (ess-R-fl-keyword:F&T))))
 '(linum-format "%5d")
 '(osx-browse-guess-keystrokes (quote ("s-b k")))
 '(osx-browse-url-keystrokes (quote ("s-b u"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun gcr/emacs-version-check ()
  "Enforce version compliance."
  (interactive)
  (when (not (and (= emacs-major-version 24)
              (= emacs-minor-version 4)))
    (error
     "Incorrect Emacs runtime. Expected v24.4. Found v%s.%s"
     (number-to-string emacs-major-version)
     (number-to-string emacs-minor-version))))
(gcr/emacs-version-check)
(package-initialize)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
             '("melpa-non-github" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(setq package-pinned-archives nil)
(add-to-list 'package-pinned-archives '(org-plus-contrib . "org"))
(mapcar (lambda (pkg) (add-to-list 'package-pinned-archives `(,pkg . "melpa-stable")))
        '(
          ace-jump-zap
          ace-link
          ace-window
          alert
          aggressive-indent
          auto-complete
          auto-complete-chunk
          boxquote
          clips-mode
          ctable
          diminish
          dired-imenu
          ess
          ess-R-data-view
          ess-R-object-popup
          esup
          exec-path-from-shell
          expand-region
          f
          fill-column-indicator
          flx-ido
          flycheck
          fuzzy
          geiser
          google-this
          graphviz-dot-mode
          ido-ubiquitous
          ido-vertical-mode
          imenu-anywhere
          inlineR
          json-reformat
          langtool
          magit
          markdown-mode
          metaweblog
          multiple-cursors
          neotree
          ob-sml
          org-ac
          oxs-browse
          package+
          pandoc-mode
          pretty-mode
          projectile
          r-autoyas
          rainbow-delimeters
          s
          smartparens
          smex
          smooth-scrolling
          solarized-theme
          sparkline
          sqlup-mode
          string-edit
          stripe-buffer
          unicode-fonts
          vagrant
          web-mode
          wrap-region
          writegood-mode
          yaml-mode
          ))

(mapcar (lambda (pkg) (add-to-list 'package-pinned-archives `(,pkg . "gnu")))
        '(
          ascii-art-to-unicode
          auctex
          diff-hl
          sml-mode
          ))
(mapcar (lambda (pkg) (add-to-list 'package-pinned-archives `(,pkg . "melpa-non-github")))
        '(
          anchored-transpose
          figlet
          highlight-tail
          htmlize
          imenu+
          key-chord
          move-text
          undo-tree
          ))
(mapcar (lambda (pkg) (add-to-list 'package-pinned-archives `(,pkg . "melpa")))
        '(
          autotetris-mode
          dired-details+
          ido-hacks
          lexbind-mode
          nyan-mode
          plantuml-mode
          polymode
          pos-tip
          xml-rpc
          ))
  (package-refresh-contents)
  (unless (package-installed-p 'package+)
    (package-install 'package+))
(package-manifest
 'ace-jump-mode
 'ace-link
 'ace-window
 'aggressive-indent
 'alert
 'anchored-transpose
 'ascii-art-to-unicode
 'auctex
 'auto-complete
 'auto-complete-chunk
 'autotetris-mode
 'boxquote
 'clips-mode
 'ctable
 'diff-hl
 'diminish
 'dired-details+
 'dired-imenu
 'ess
 'ess-R-data-view
 'ess-R-object-popup
 'esup
 'exec-path-from-shell
 'expand-region
 'f
 'figlet
 'fill-column-indicator
 'flx-ido
 'flycheck
 'fuzzy
 'geiser
 'google-this
 'graphviz-dot-mode
 'highlight-tail
 'htmlize
 'ido-hacks
 'ido-ubiquitous
 'ido-vertical-mode
 'imenu+
 'imenu-anywhere
 'inlineR
 'json-reformat
 'key-chord
 'langtool
 'lexbind-mode
 'magit
 'markdown-mode
 'metaweblog
 'multiple-cursors
 'neotree
 'nyan-mode
 'ob-sml
 'org-ac
 'org-plus-contrib
 'osx-browse
 'package+
 'pandoc-mode
 'plantuml-mode
 'polymode
 'pos-tip
 'pretty-mode
 'projectile
 'r-autoyas
 'rainbow-delimiters
 's
 'smartparens
 'smex
 'sml-mode
 'smooth-scrolling
 'solarized-theme
 'sparkline
 'sqlup-mode
 'string-edit
 'stripe-buffer
 'undo-tree
 'unicode-fonts
 'vagrant
 'web-mode
 'wrap-region
 'writegood-mode
 'xml-rpc
 'yaml-mode
 )
(load "~/.emacs.d/elpa/f-0.17.2/f.el")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(setq gcr/el-get-packages nil)
(add-to-list
 'el-get-sources
 '(:name org-show
          :type http
          :url "https://raw.githubusercontent.com/jkitchin/jmax/master/org/org-show.org"
          :website "https://github.com/jkitchin/jmax/blob/master/org/org-show.org"
          :description "simple presentations in org-mode"))
(add-to-list 'gcr/el-get-packages 'org-show)
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
 '(:name swimmers
          :type http
          :url "http://www.cb1.com/~john/computing/emacs/lisp/games/swimmers.el"
          :features swimmers
          :autoloads nil
          :website "http://www.cb1.com/~john/"
          :description "Draw a swimming-pool screensaver"))
(add-to-list 'gcr/el-get-packages 'swimmers)
(add-to-list 'el-get-sources '(:name emacs-uuid
                                     :type github
                                     :pkgname "nicferrier/emacs-uuid"))
(add-to-list 'gcr/el-get-packages 'emacs-uuid)
(add-to-list 'el-get-sources '(:name emacs-world-time-mode
                                     :type github
                                     :pkgname "nicferrier/emacs-world-time-mode"))
(add-to-list 'gcr/el-get-packages 'emacs-world-time-mode)
(el-get 'sync gcr/el-get-packages)
(defconst +honey-bee-wing-flap+ 5
  "A honey bee's wing flap in milliseconds.

URL: `https://en.wikipedia.org/wiki/Millisecond'")

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

(defmacro gcr/diminish (mode)
  "Diminish this mode after it is loaded."
  (interactive)
  `(eval-after-load ,mode
     (diminish ,mode)))

(defvar gcr/delete-trailing-whitespace-p t
  "Should trailing whitespace be removed?")

(defun gcr/delete-trailing-whitespace ()
  "Delete trailing whitespace for everything but the current line.

If `gcr/delete-trailing-whitespace-p' is non-nil, then delete the whitespace.
This is useful for fringe cases where trailing whitespace is important."
  (interactive)
  (when gcr/delete-trailing-whitespace-p
    (let ((first-part-start (point-min))
          (first-part-end (point-at-bol))
          (second-part-start (point-at-eol))
          (second-part-end (point-max)))
      (delete-trailing-whitespace first-part-start first-part-end)
      (delete-trailing-whitespace second-part-start second-part-end))))

(defun gcr/set-org-babel-default-header-args (property value)
  "Easily set system header arguments in org mode.

PROPERTY is the system-wide value that you would like to modify.

VALUE is the new value you wish to store.

Attribution: URL `http://orgmode.org/manual/System_002dwide-header-arguments.html#System_002dwide-header-arguments'"
  (setq org-babel-default-header-args
        (cons (cons property value)
              (assq-delete-all property org-babel-default-header-args))))

(defun gcr/set-org-babel-default-inline-header-args (property value)
  "See `gcr/set-org-babel-default-header-args'; same but for inline header args."
  (setq org-babel-default-inline-header-args
        (cons (cons property value)
              (assq-delete-all property org-babel-default-inline-header-args))))

(defun gcr/set-org-babel-default-header-args:R (property value)
  "See `gcr/set-org-babel-default-header-args'; same but for R.

This is a copy and paste. Additional languages would warrant a refactor."
  (setq org-babel-default-header-args:R
        (cons (cons property value)
              (assq-delete-all property org-babel-default-header-args:R))))

(defun gcr/ispell-org-header-lines-regexp (h)
  "Help ispell ignore org header lines."
  (interactive)
  (cons (concat "^#\\+" h ":") ".$"))

(defun gcr/ispell-a2isra (block-def)
  "Add to the ispell skip region alist the BLOCK-DEF."
  (interactive)
  (add-to-list 'ispell-skip-region-alist block-def))

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

(defun gcr/insert-timestamp ()
  "Produces and inserts a full ISO 8601 format timestamp."
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%T%z")))

(defun gcr/insert-timestamp* ()
  "Produces and inserts a near-full ISO 8601 format timestamp."
  (interactive)
  (insert (format-time-string "%Y-%m-%dT%T")))

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

(defun gcr/save-all-file-buffers ()
  "Saves every buffer associated with a file."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (buffer-modified-p))
        (save-buffer))))
  (sleep-for 0 (* 3 +honey-bee-wing-flap+)))

(defun gcr/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

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

(defun gcr/dired-copy-filename ()
  "Push the path and filename of the file under the point to the kill ring.

Attribution: URL `https://lists.gnu.org/archive/html/help-gnu-emacs/2002-10/msg00556.html'"
  (interactive)
  (message "Added %s to kill ring" (kill-new (dired-get-filename))))

(defun gcr/dired-copy-path ()
  "Push the path of the directory under the point to the kill ring."
  (interactive)
  (message "Added %s to kill ring" (kill-new default-directory)))

(defun gcr/file-exists-not-symlink (f)
  "True if F exists and is not a symlink."
  (interactive)
  (and (file-exists-p f)
     (not (file-symlink-p f))))

(defun gcr/file-exists-is-symlink (f)
  "True if F exists and is a symlink."
  (interactive)
  (and (file-exists-p f)
     (file-symlink-p f)))

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

(defun gcr/move-line-up ()
  "Move the current line up one.

Attribution: URL `https://github.com/hrs/dotfiles/blob/master/emacs.d/lisp/utils.el'"
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun gcr/move-line-down ()
  "Move the current line down one.

Attribution: URL `https://github.com/hrs/dotfiles/blob/master/emacs.d/lisp/utils.el'"
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun gcr/uuid-string ()
  "Insert a string form of a UUID."
  (interactive)
  (insert (uuid-to-stringy (uuid-create))))

(defun yf/org-electric-dollar nil
  "When called once, insert \\(\\) and leave point in between.
  When called twice, replace the previously inserted \\(\\) by one $.

from Nicolas Richard <theonewiththeevillook@yahoo.fr>
Date: Fri, 8 Mar 2013 16:23:02 +0100
Message-ID: <87vc913oh5.fsf@yahoo.fr>"
  (interactive)
  (if (and (looking-at "\\\\)") (looking-back "\\\\("))
      (progn (delete-char 2)
             (delete-char -2)
             (insert "$"))
    (insert "\\(\\)")
    (backward-char 2)))

(defun endless/sharp ()
  "Insert #' unless in a string or comment.

SRC: URL `http://endlessparentheses.com/get-in-the-habit-of-using-sharp-quote.html?source=rss'"
  (interactive)
  (call-interactively #'self-insert-command)
  (let ((ppss (syntax-ppss)))
    (unless (or (elt ppss 3)
               (elt ppss 4))
      (insert "'"))))

(defun gcr/chs ()
  "Insert opening \"cut here start\" snippet."
  (interactive)
  (insert "--8<---------------cut here---------------start------------->8---"))

(defun gcr/che ()
  "Insert closing \"cut here end\" snippet."
  (interactive)
  (insert "--8<---------------cut here---------------end--------------->8---"))

(defmacro gcr/measure-time (&rest body)
  "Measure the time it takes to evaluate BODY.

Attribution Nikolaj Schumacher: URL `https://lists.gnu.org/archive/html/help-gnu-emacs/2008-06/msg00087.html'"
  `(let ((time (current-time)))
     ,@body
     (message "%.06f" (float-time (time-since time)))))

(defun gcr/create-non-existent-directory ()
  "Attribution URL: `https://iqbalansari.github.io/blog/2014/12/07/automatically-create-parent-directories-on-visiting-a-new-file-in-emacs/'"
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
             (y-or-n-p (format "Directory `%s' does not exist. Create it?" parent-directory)))
      (make-directory parent-directory t))))

(defun gcr/occur-dwim ()
  "Call `occur' with a mostly sane default.

Attribution Oleh Krehel (abo-abo): URL `http://oremacs.com/2015/01/26/occur-dwim/'"
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (let ((sym (thing-at-point 'symbol)))
            (when (stringp sym)
              (regexp-quote sym))))
        regexp-history)
  (call-interactively 'occur))
(defun gcr/util-cycle ()
  "Display or hide the utility buffers."
  (interactive)
  (if gcr/util-state
      (gcr/util-stop)
    (gcr/util-start)))
(defun sacha/unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text.

ATTRIBUTION: SRC https://github.com/sachac/.emacs.d/blob/gh-pages/Sacha.org#unfill-paragraph"
  (interactive (progn
                 (barf-if-buffer-read-only)
                 (list t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))
(setq solarized-distinct-fringe-background +1)
(setq solarized-high-contrast-mode-line +1)
(setq solarized-use-less-bold +1)
(setq solarized-use-more-italic nil)
(setq solarized-emphasize-indicators nil)
(load-theme 'solarized-dark)
(menu-bar-mode +1)
(gcr/on-osx
 (defadvice yes-or-no-p (around prevent-dialog activate)
   "Prevent yes-or-no-p from activating a dialog"
   (let ((use-dialog-box nil))
     ad-do-it))

 (defadvice y-or-n-p (around prevent-dialog-yorn activate)
   "Prevent y-or-n-p from activating a dialog"
   (let ((use-dialog-box nil))
     ad-do-it)))
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
(gcr/on-osx
 (setq mac-control-modifier 'control)
 (setq mac-command-modifier 'meta)
 (setq mac-option-modifier 'super))

(gcr/on-windows
 (setq w32-lwindow-modifier 'super)
 (setq w32-rwindow-modifier 'super))
(setq hs-hide-comments-when-hiding-all +1)
(setq hs-isearch-open +1)
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
(global-linum-mode -1)
(global-font-lock-mode 1)
(setq aw-keys '(?a ?s ?d ?f ?j ?k ?l ?\;))
(setq blink-matching-paren nil)
(show-paren-mode +1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(setq ring-bell-function 'ignore)
(setq visible-bell +1)
(winner-mode +1)
(blink-cursor-mode 0)
(gcr/on-gui
 (setq-default cursor-type 'box))
(setq x-stretch-cursor 1)
(defadvice kill-line (around kill-line-remove-newline activate)
  (let ((kill-whole-line t))
    ad-do-it))
(setq-default fill-column 80)
(global-diff-hl-mode)
(require 'expand-region)
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
(desktop-save-mode 1)
(setq desktop-restore-eager 10)
(setq auto-save-default t)
(setq make-backup-files nil)
(setq auto-save-visited-file-name t)
(setq auto-save-interval 05)
(setq auto-save-timeout 05)
(defadvice switch-to-buffer (before gcr/save-all-file-buffers-now activate)
  (when buffer-file-name (gcr/save-all-file-buffers)))
(defadvice other-window (before other-window-now activate)
  (when buffer-file-name (gcr/save-all-file-buffers)))
(defadvice windmove-up (before other-window-now activate)
  (when buffer-file-name (gcr/save-all-file-buffers)))
(defadvice windmove-down (before other-window-now activate)
  (when buffer-file-name (gcr/save-all-file-buffers)))
(defadvice windmove-left (before other-window-now activate)
  (when buffer-file-name (gcr/save-all-file-buffers)))
(defadvice windmove-right (before other-window-now activate)
  (when buffer-file-name (gcr/save-all-file-buffers)))
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(gcr/on-osx
 (add-to-list 'load-path "/usr/local/Cellar/ccrypt/1.10/share/emacs/site-lisp"))
(gcr/on-windows
 (add-to-list 'load-path "C:\\opt\\ccrypt-1.10.cygwin-i386\\"))
(gcr/on-gnu/linux
 (warn "Please configure ccrypt."))
(require 'ps-ccrypt "ps-ccrypt.el")
(setq backup-inhibited 1)
(add-hook 'write-file-hooks
          (lambda ()
            (gcr/delete-trailing-whitespace)))
(prefer-coding-system 'utf-8)
(gcr/on-gui
 (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
 (gcr/on-windows
  (set-clipboard-coding-system 'utf-16le-dos)))

(require 'undo-tree)
(global-undo-tree-mode 1)
(gcr/diminish 'undo-tree-mode)
(setq require-final-newline t)
(global-auto-revert-mode 1)
(require 'wrap-region)
(gcr/diminish 'wrap-region-mode)

(wrap-region-add-wrapper "*" "*" nil 'org-mode) ;; bold
(wrap-region-add-wrapper "/" "/" nil 'org-mode) ;; italic
(wrap-region-add-wrapper "_" "_" nil 'org-mode) ;; underlined
(wrap-region-add-wrapper "=" "=" nil 'org-mode) ;; verbatim
(wrap-region-add-wrapper "~" "~" nil 'org-mode) ;; code
(wrap-region-add-wrapper "+" "+" nil 'org-mode) ;; strike-through
;; (wrap-region-add-wrapper "" "w" 'org-mode) ;; noweb blocks
(let ((text-buffer (get-buffer-create "*text*")))
  (with-current-buffer text-buffer
    (text-mode)
    (insert "Shall we play a game?")
    (beginning-of-line)))
(require 'boxquote)
(setq track-eol +1)
(setq line-move-visual nil)
(global-set-key [?\C-x ?t] 'anchored-transpose)
(autoload 'anchored-transpose "anchored-transpose" nil t)
(require 'ibuffer)
(require 'smooth-scrolling)
(require 'stripe-buffer)
(defadvice save-buffers-kill-terminal (before save-before-save-buffers-kill-terminal first activate)
  "Save all buffers before save-buffers-kill-terminal calls."
  (gcr/save-all-file-buffers))
(setq sentence-end-double-space nil)
(gcr/diminish 'visual-line-mode)
(eval-after-load "hideshow" '(diminish 'hs-minor-mode))
(gcr/on-osx (setq frame-title-format '("𝔸𝕃𝔼ℂ")))
(gcr/on-windows (setq frame-title-format '("ALEC")))
(scroll-bar-mode 0)
(tool-bar-mode 0)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse +1)
(require 'neotree)
(setq dired-listing-switches "-alh")
(setq dired-recursive-deletes  +1)
(require 'dired-details+)
(setq-default dired-details-hidden-string "")
(defun gcr/dired-mode-hook ()
  "Personal dired customizations."
  (local-set-key "c" 'gcr/dired-copy-filename)
  (local-set-key "]" 'gcr/dired-copy-path)
  (diff-hl-dired-mode)
  (load "dired-x")
  (turn-on-stripe-buffer-mode)
  (stripe-listify-buffer))
(add-hook 'dired-mode-hook 'gcr/dired-mode-hook)
(setq dired-dwim-target t)
(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))
(require 'wdired)
(setq wdired-allow-to-change-permissions t)
(setq wdired-allow-to-redirect-links t)
(setq wdired-use-interactive-rename +1)
(setq wdired-confirm-overwrite +1)
(setq wdired-use-dired-vertical-movement 'sometimes)
(require 'dired-imenu)
(defconst gcr/savehist-file-store "~/.emacs.d/history")
(defun gcr/warn-savehist-file-store ()
  "Warn of savehist misconfiguration."
  (interactive)
  (unless (gcr/file-exists-not-symlink gcr/savehist-file-store)
    (warn "Can't seem to find a savehist store file where it was expected at: %S. Savehist should continue to function normally; but your history may be lost."
          gcr/savehist-file-store)))
(gcr/warn-savehist-file-store)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
(savehist-mode +1)
(defconst gcr/aspell-personal-dictionary "~/.aspell.en.pws")
(defun gcr/warn-aspell-personal-dictionary ()
  "Warn of aspell misconfiguration: personal dictionary."
  (interactive)
  (unless (gcr/file-exists-is-symlink gcr/aspell-personal-dictionary)
    (warn
     "Can't seem to find an aspell personal dictionary where it was expected at: %S. aspell should continue to function normally; but your personal dictionary will not be used."
     gcr/aspell-personal-dictionary)))
(gcr/warn-aspell-personal-dictionary)
(defconst gcr/aspell-personal-replacement-dictionary "~/.aspell.en.prepl")
(defun gcr/warn-aspell-personal-replacement-dictionary ()
  "Warn of aspell misconfiguration: personal replacement dictionary."
  (interactive)
  (unless (gcr/file-exists-is-symlink gcr/aspell-personal-replacement-dictionary)
    (warn
     "Can't seem to find an aspell personal replacement dictionary where it was expected at: %S. aspell should continue to function normally; but your personal replacement dictionary will not be used."
     gcr/aspell-personal-replacement-dictionary)))
(gcr/warn-aspell-personal-replacement-dictionary)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(gcr/diminish 'flycheck-mode)
(require 'yasnippet)
(yas-global-mode 1)
(gcr/diminish 'yas-minor-mode)
(defun gcr/yas-minor-mode-hook ()
  "Personal customizations."
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "s-4") 'yas-expand))

(add-hook 'yas-minor-mode-hook 'gcr/yas-minor-mode-hook)
(require 'whitespace)
(setq whitespace-style '(trailing lines tab-mark))
(setq whitespace-line-column 80)
(global-whitespace-mode 1)
(gcr/diminish 'global-whitespace-mode)
(gcr/diminish 'whitespace-mode)
(delete-selection-mode 1)
(require 'diminish)
(size-indication-mode)
(column-number-mode 1)
(autoload 'esup "esup" "Emacs Start Up Profiler." nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq resize-mini-windows +1)
(setq max-mini-window-height 0.33)
(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode 1)
(defun gcr/minibuffer-setup-hook ()
  "Personal setup."
  (local-set-key "ESC y" 'gcr/paste-from-x-clipboard))

(add-hook 'minibuffer-setup-hook 'gcr/minibuffer-setup-hook)
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
(setq isearch-lax-whitespace +1)
(setq isearch-regexp-lax-whitespace +1)
(setq-default case-fold-search +1)
(require 'pos-tip)
(gcr/on-windows
 (ignore-errors
   (pos-tip-w32-max-width-height)))
(setq pos-tip-foreground-color "#073642")
(setq pos-tip-background-color "#839496")
(require 'fuzzy)
(require 'auto-complete)
(require 'auto-complete-config)
(setq ac-quick-help-prefer-pos-tip nil)
(ac-config-default)
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")
(gcr/diminish 'auto-complete-mode)
(require 'auto-complete-chunk)
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(gcr/diminish 'smartparens-mode)
(setq sp-show-pair-from-inside nil)
(setq-default eval-expression-print-level nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(defadvice vc-next-action (before save-before-vc first activate)
  "Save all buffers before any VC next-action function calls."
  (gcr/save-all-file-buffers))

(defadvice vc-diff (before save-before-vc-diff first activate)
  "Save all buffers before vc-diff calls."
  (gcr/save-all-file-buffers))

(defadvice vc-ediff (before save-before-vc-ediff first activate)
  "Save all buffers before vc-ediff calls."
  (gcr/save-all-file-buffers))

(defadvice vc-revert (before save-before-vc-revert first activate)
  "Save all buffers before vc-revert calls."
  (gcr/save-all-file-buffers))
(defun gcr/log-edit-mode-hook ()
  "Personal mode bindings for log-edit-mode."
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode))

(add-hook 'log-edit-mode-hook 'gcr/log-edit-mode-hook)

(defun gcr/log-edit-mode-hook-local-bindings ()
  "Helpful bindings for log edit buffers."
  (local-set-key (kbd "C-;") 'log-edit-done))

(add-hook 'log-edit-mode-hook 'gcr/log-edit-mode-hook-local-bindings)
(defun gcr/git-commit-mode-hook ()
  "Personal customizations."
  (local-set-key (kbd "C-;") 'git-commit-commit))

(add-hook 'git-commit-mode-hook 'gcr/git-commit-mode-hook)
(eval-after-load 'log-edit
  '(remove-hook 'log-edit-hook 'log-edit-insert-message-template))
(add-to-list 'auto-mode-alist '(".gitignore$" . text-mode))
(eval-after-load "magit" '(diminish 'magit-auto-revert-mode))
(require 'smex)
(smex-initialize)
(eval-after-load "projectile"
  '(progn (setq magit-repo-dirs (mapcar (lambda (dir)
                                          (substring dir 0 -1))
                                        (remove-if-not (lambda (project)
                                                         (file-directory-p (concat project "/.git/")))
                                                       (projectile-relevant-known-projects)))

                magit-repo-dirs-depth 1)))
(require 'multiple-cursors)
(defconst gcr/font-base "DejaVu Sans Mono" "The preferred font name.")
(require 'unicode-fonts)
(unicode-fonts-setup)
(defvar gcr/font-size 10 "The preferred font size.")
(gcr/on-osx (setq gcr/font-size 17))
(gcr/on-windows (setq gcr/font-size 13))
(require 'pretty-mode)
(setq make-pointer-invisible +1)
(gcr/on-gui
  
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
(projectile-global-mode 1)
(gcr/diminish 'projectile-mode)
(require 'ess-site)
(defconst gcr/ess-version "14.11")

(defun gcr/warn-ess-version ()
  "Warn of ess misconfiguration."
  (interactive)
  (when (not (version= ess-version gcr/ess-version))
    (warn "Insufficient ess-mode requirements. Expected %S. Found: %S " gcr/ess-version ess-version)))
(gcr/warn-ess-version)
(setq ess-eldoc-show-on-symbol t)
(setq ess-use-tracebug t)
(setq ess-tracebug-search-path '())
(define-key compilation-minor-mode-map [(?n)] 'next-error-no-select)
(define-key compilation-minor-mode-map [(?p)] 'previous-error-no-select)
(setq ess-watch-scale-amount -1)
(setq ess-describe-at-point-method 'tooltip)
(require 'ess-R-object-popup)
(autoload 'ess-rdired "ess-rdired")
(require 'ess-R-data-view)
(require 'inlineR)
(setq gcr/r-dir "~/.R/")
(defun gcr/make-warn-R-dir ()
  "Handle of R directory misconfiguration."
  (interactive)
  (unless (f-directory? gcr/r-dir)
    (progn
      (message "Couldn't find %S… creating it." gcr/r-dir)
      (f-mkdir gcr/r-dir))))
(gcr/make-warn-R-dir)
(setq ess-history-directory gcr/r-dir)
(setq ess-source-directory gcr/r-dir)
(setq inferior-ess-program "R")
(setq inferior-R-program-name "R")
(setq ess-local-process-name "R")
(setq inferior-S-prompt "[]a-zA-Z0-9.[]*\\(?:[>+.] \\)*ℝ+> ")
(setq inferior-ess-same-window nil)
(setq inferior-ess-own-frame nil)
(setq ess-help-own-frame nil)
(setq ess-ask-for-ess-directory nil)
(setq inferior-ess-exit-command "q('no')
")
(setq ess-execute-in-process-buffer +1)
(setq ess-switch-to-end-of-proc-buffer t)
(setq ess-tab-complete-in-script +1)
(setq ess-first-tab-never-complete 'symbol-or-paren-or-punct)
(setq ess-use-ido t)
(add-to-list 'auto-mode-alist '("\\.rd\\'" . Rd-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd$" . r-mode))
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
(setq ess-ac-R-argument-suffix "=")
(defun gcr/ess-mode-hook ()
  (local-set-key (kbd "s-e") 'ess-switch-to-end-of-ESS)
  (local-set-key (kbd "s-x") 'r-autoyas-expand)
  (local-set-key (kbd "s-p") 'ess-R-object-popup)
  (local-set-key (kbd "s-v o") 'ess-describe-object-at-point)
  (local-set-key (kbd "s-v d") 'ess-rdired)
  (local-set-key (kbd "s-v cc") 'ess-R-dv-ctable)
  (local-set-key (kbd "s-v cp") 'ess-R-dv-pprint)
  (setq ess-S-assign-key (kbd "C-,"))
  (ess-toggle-S-assign-key t)
  (ess-toggle-underscore nil)
  (local-set-key (kbd "C-.") (lambda () (interactive) (insert " -> ")))
  (local-set-key (kbd "C-M-,") (lambda () (interactive) (insert " <<- ")))
  (local-set-key (kbd "C-M-.") (lambda () (interactive) (insert " ->> ")))
  (local-set-key (kbd "C-8") (lambda () (interactive) (insert " %<>% ")))
  (local-set-key (kbd "C-9") (lambda () (interactive) (insert " %>% ")))
  (local-set-key (kbd "C-0") 'ess-eval-buffer)
  (ess-set-style 'RRR 'quiet)
  (turn-on-pretty-mode)
  (r-autoyas-ess-activate)
  (visual-line-mode)
  (smartparens-strict-mode t)
  (gcr/untabify-buffer-hook)
  (fci-mode)
  (hs-minor-mode 1)
  (linum-mode)
  (gcr/turn-on-r-hide-show)
  (aggressive-indent-mode)
  (lambda () (add-hook 'ess-presend-filter-functions
                  (lambda ()
                    (warn
                     "ESS now supports a standard pre-send filter hook. Please update your configuration to use it instead of using advice.")))))

(add-hook 'ess-mode-hook 'gcr/ess-mode-hook)

(defun gcr/turn-on-r-hide-show ()
  "Attribution: SRC https://github.com/mlf176f2/EmacsMate/blob/master/EmacsMate-ess.org"
  (when (string= "S" ess-language)
    (set (make-local-variable 'hs-special-modes-alist) '((ess-mode "{" "}" "#" nil nil)))
    (hs-minor-mode 1)
    (when (fboundp 'foldit-mode)
      (foldit-mode 1))
    (when (fboundp 'fold-dwim-org/minor-mode)
      (fold-dwim-org/minor-mode))))

(defun gcr/Rd-mode-hook ()
  (gcr/ess-mode-hook))

(add-hook 'Rd-mode-hook 'gcr/Rd-mode-hook)

(defun gcr/inferior-ess-mode-hook ()
  (gcr/ess-mode-hook))

(add-hook 'inferior-ess-mode-hook 'gcr/inferior-ess-mode-hook)

(defun gcr/ess-rdired-mode-hook ()
  "Personal customizations."
  (interactive)
  (turn-on-stripe-buffer-mode)
  (stripe-listify-buffer))

(add-hook 'ess-rdired-mode-hook 'gcr/ess-rdired-mode-hook)
(setq inferior-ess-primary-prompt "ℝ> ")
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
(setq ess-eval-visibly 'nowait)
(setq org-list-allow-alphabetical +1)
(require 'org)
(require 'ox-beamer)
(require 'ox-md)
(require 'htmlize)
(setq htmlize-output-type 'inline-css)
(setq org-html-htmlize-output-type htmlize-output-type)
(let ((pkg 'org-show))
  (gcr/on-gui
   (if (not (el-get-package-is-installed pkg))
       (warn "You wanted %S to be installed, but it isnt. Fix this." pkg)
     (let ((fil (concat (el-get-package-directory pkg) "org-show.el")))
       (if (not (f-exists? fil))
           (warn "You wanted %S to exist, but it doesn't. Fix this." fil)
         (load fil)))))
  (gcr/not-on-gui (warn "You wanted %S to be loaded, but it won't be… it doesn't work without a GUI for some reason." pkg)))
(defconst gcr/org-version "8.2.10")

(defun gcr/warn-org-version ()
  "Warn of org misconfiguration."
  (interactive)
  (when (not (version= (org-version) gcr/org-version))
    (warn "Insufficient org-mode requirements. Expected %S. Found: %S " gcr/org-version (org-version))))
(gcr/warn-org-version)
(setq org-export-coding-system 'utf-8)
(setq org-export-preserve-breaks nil)
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
(setq org-startup-align-all-tables +1)
(defun gcr/org-babel-after-execute-hook ()
  "Personal settings for the `org-babel-after-execute-hook'."
  (interactive)
  (org-redisplay-inline-images))

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
   (sml . t)
   (sql . t)))
(setq org-babel-use-quick-and-dirty-noweb-expansion nil)
(setq org-src-fontify-natively nil)
(setq org-src-preserve-indentation +1)
(setq org-edit-src-content-indentation 0)
(setq org-src-strip-leading-and-trailing-blank-lines nil)
(add-to-list
 'org-structure-template-alist
 '("el" "#+begin_src emacs-lisp\n?\n#+end_src" "<src lang=\"emacs-lisp\">\n?\n</src>"))
(mapc (lambda (asc)
        (let ((org-sce-dc (downcase (nth 1 asc))))
          (setf (nth 1 asc) org-sce-dc)))
      org-structure-template-alist)
(add-to-list
 'org-structure-template-alist
 '("r" "#+begin_src R\n?\n#+end_src" "<src lang=\"R\"></src>"))
(add-to-list
 'org-structure-template-alist
 '("p" "#+begin_src plantuml\n?\n#+end_src" "<src lang=\"plantuml\"></src>"))
(add-to-list
 'org-structure-template-alist
 '("sh" "#+begin_src sh\n?\n#+end_src" "<src lang=\"sh\"></src>"))
(defadvice org-babel-tangle (before org-babel-tangle-before activate)
  (gcr/save-all-file-buffers)
  (message (concat "org-babel-tangle BEFORE: <"
                   (format-time-string "%Y-%m-%dT%T%z")
                   ">"))
  (setq gcr/tmp (current-time)))

(defadvice org-babel-tangle (after org-babel-tangle-after activate)
  (let* ((dur (float-time (time-since gcr/tmp)))
         (msg (format "Tangling complete after: %.06f seconds" dur)))
    (message (concat "org-babel-tangle AFTER: <"
                     (format-time-string "%Y-%m-%dT%T%z")
                     ">"))
    (message msg)
    (gcr/on-gui (alert msg :title "org-mode"))))

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
(setq org-html-checkbox-type 'unicode)
(defadvice org-latex-export-to-pdf (before org-latex-export-to-pdf-before activate)
  (gcr/save-all-file-buffers))
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
(setq org-babel-min-lines-for-block-output 0)
(setq org-edit-src-auto-save-idle-delay 1)
(setq org-src-window-setup 'current-window)
(setq org-babel-results-keyword "NAME")
(setq org-babel-no-eval-on-ctrl-c-ctrl-c +1)
(setq org-babel-noweb-wrap-start "«")
(setq org-babel-noweb-wrap-end "»")
(defun gcr/org-edit-src-code-plus-name ()
  "Edit the well-described source code block.

Attribution: URL `https://lists.gnu.org/archive/html/emacs-orgmode/2014-09/msg00778.html'"
  (interactive)
  (let* ((eop  (org-element-at-point))
         (name (or (org-element-property :name (org-element-context eop))
                  "ॐ"))
         (lang (org-element-property :language eop))
         (buff-name (concat "*Org Src " name "[" lang "]*")))
    (org-edit-src-code nil nil buff-name)))
(defadvice vc-next-action (before vc-next-action-in-org-src-block last activate)
  "If in org source block, exit it."
  (when (condition-case nil
            (org-src-in-org-buffer)
          (error nil))
    (org-edit-src-exit)))
(defun gcr/src-block-check ()
  (interactive)
  (org-element-map (org-element-parse-buffer 'element) 'src-block
    (lambda (src-block)
      (let ((language (org-element-property :language src-block)))
        (cond ((null language)
               (error "Missing language at position %d"
                      (org-element-property :post-affiliated src-block)))
              ((not (assoc-string language org-babel-load-languages))
               (error "Unknown language at position %d"
                      (org-element-property :post-affiliated src-block)))))))
  (message "Source blocks checked in %s." (buffer-name (buffer-base-buffer))))
(defadvice gcr/org-edit-src-code-plus-name (around set-buffer-file-name activate compile)
  (let ((file-name (buffer-file-name)))
    ad-do-it
    (setq buffer-file-name file-name)))
(setq org-edit-src-code nil)
(gcr/set-org-babel-default-header-args :comments "noweb")
(gcr/set-org-babel-default-header-args :results "output replace")
(gcr/set-org-babel-default-header-args :exports "both")
(gcr/set-org-babel-default-header-args :noweb "no-export")
(gcr/set-org-babel-default-header-args :padline "yes")
(setq org-confirm-babel-evaluate nil)
(gcr/set-org-babel-default-header-args :eval "always")
(setq org-export-babel-evaluate 'inline-only)
(gcr/set-org-babel-default-inline-header-args :eval "always")
(gcr/set-org-babel-default-inline-header-args :results "value replace")
(gcr/set-org-babel-default-header-args:R :session "*R*")
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
(define-key org-mode-map (kbd "C-,") (lambda () (interactive) (insert " \\larr ")))
(defun gcr/org-mode-hook ()
  (local-set-key (kbd "C-1") 'org-narrow-to-subtree)
  (local-set-key (kbd "M-1") 'widen)
  (local-set-key (kbd "C-2") 'gcr/org-edit-src-code-plus-name)
  (local-set-key (kbd "C-3") 'org-table-edit-field)
  (local-set-key (kbd "s-h") 'org-babel-check-src-block)
  (local-set-key (kbd "s-a i") 'org-babel-insert-header-arg)
  (local-set-key (kbd "s-j") 'org-babel-previous-src-block)
  (local-set-key (kbd "s-k") 'org-babel-next-src-block)
  (local-set-key (kbd "s-l") 'org-babel-demarcate-block)
  (local-set-key (kbd "s-;") 'org-babel-view-src-block-info)
  (local-set-key (kbd "s-b x") 'org-babel-expand-src-block)
  (local-set-key (kbd "s-b s") 'org-babel-switch-to-session)
  (local-set-key (kbd "s-b c") 'org-babel-switch-to-session-with-code)
  (local-set-key (kbd "s-o") 'org-babel-execute-maybe)
  (local-set-key (kbd "s-t") 'org-babel-tangle)
  (local-set-key (kbd "s-x") 'org-babel-do-key-sequence-in-edit-buffer)
  (local-set-key (kbd "s-w w") 'org-export-dispatch)
  (local-set-key (kbd "s-<f5>") 'org-babel-execute-buffer)
  (local-set-key (kbd "s-i d") 'org-display-inline-images)
  (local-set-key (kbd "s-i r") 'org-remove-inline-images)
  (local-set-key (kbd "C-.") (lambda () (interactive) (insert " \\rarr ")))
  (local-set-key (kbd "$") 'yf/org-electric-dollar)
  (when (and (fboundp 'guide-key-mode) guide-key-mode)
    (guide-key/add-local-guide-key-sequence "C-c")
    (guide-key/add-local-guide-key-sequence "C-c C-x")
    (guide-key/add-local-highlight-command-regexp "org-"))
  (fci-mode)
  (gcr/untabify-buffer-hook)
  (turn-on-stripe-table-mode)
  (linum-mode)
  (wrap-region-mode t))

(add-hook 'org-mode-hook 'gcr/org-mode-hook)
(defun gcr/org-src-mode-hook ()
  (local-set-key (kbd "C-2") 'org-edit-src-exit)
  (visual-line-mode))

(add-hook 'org-src-mode-hook 'gcr/org-src-mode-hook)
(setq echo-keystrokes 0.02)
(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.1)
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
         (not (equal new-command 'gcr/move-line-up))
         )
      (warn "Just stomped the global-map binding for %S, replaced %S with %S"
            key old-command new-command))))
(global-set-key (kbd "C-'") 'er/expand-region)
(key-chord-define-global "jk" 'ace-jump-mode)
(key-chord-define-global "m," 'ace-jump-mode-pop-mark)
(global-set-key (kbd "M-9") 'mc/edit-lines)
(global-set-key (kbd "M-0") 'mc/mark-next-like-this)
(global-set-key (kbd "M--") 'mc/mark-all-like-this)
(global-set-key (kbd "M-8") 'mc/mark-previous-like-this)
(key-chord-define-global "nm" 'ace-window)
(key-chord-define-global "3." 'gcr/insert-ellipsis)
(key-chord-define-global "4 " (lambda () (interactive) (insert "    ")))
(key-chord-define-global (concat "A" "{") (lambda () (interactive) (insert "ä")))
(key-chord-define-global (concat "A" "}") (lambda () (interactive) (insert "Ä")))
(key-chord-define-global (concat "O" "{") (lambda () (interactive) (insert "ö")))
(key-chord-define-global (concat "O" "}") (lambda () (interactive) (insert "Ö")))
(key-chord-define-global (concat "U" "{") (lambda () (interactive) (insert "ü")))
(key-chord-define-global (concat "U" "}") (lambda () (interactive) (insert "Ü")))
(global-set-key (kbd "C-,") (lambda () (interactive) (insert "←")))
(global-set-key (kbd "C-.") (lambda () (interactive) (insert "→")))
(key-chord-define-global "<<" (lambda () (interactive) (insert "«")))
(key-chord-define-global ">>" (lambda () (interactive) (insert "»")))
(key-chord-define-global "jl" 'ace-jump-zap-up-to-char)
(key-chord-define-global "j;" 'ace-jump-zap-to-char)
(key-chord-define-global "fg" 'goto-line)
(key-chord-define-global "vb" 'pop-to-mark-command)
(key-chord-define-global "JK" (lambda () (interactive) (other-window 1)))
(key-chord-define-global "KL" (lambda () (interactive) (next-buffer)))
(key-chord-define-global "L:" (lambda () (interactive) (previous-buffer)))
(key-chord-define-global "gt" 'google-this-mode-submap)
(global-set-key (kbd "C-a") 'beginning-of-line-dwim)
(global-set-key (kbd "C-;") 'vc-next-action)
(key-chord-define-global "yu" 'move-text-up)
(key-chord-define-global "hj" 'move-text-down)
(global-set-key (kbd "C-s-<up>") 'gcr/move-line-up)
(global-set-key (kbd "C-s-<down>") 'gcr/move-line-down)
(key-chord-define-global "qp" 'ispell)
(key-chord-define-global "qo" 'ispell-word)
(key-chord-define-global "wm" 'writegood-mode)
(key-chord-define-global "wl" 'writegood-grade-level)
(key-chord-define-global "wz" 'writegood-reading-ease)
(define-prefix-command 'gcr/langtool-map)
(key-chord-define-global "qk" 'gcr/langtool-map)
(define-key gcr/langtool-map "c" 'langtool-check)
(define-key gcr/langtool-map "C" 'langtool-correct-buffer)
(define-key gcr/langtool-map "s" 'langtool-show-message-at-point)
(define-key gcr/langtool-map "q" 'langtool-check-done)
(key-chord-define-global "wm" 'writegood-mode)
(global-set-key (kbd "M-s p") 'gcr/occur-dwim)
(key-chord-define-global "eo" 'gcr/comment-or-uncomment)
(global-set-key (kbd "s-d h") 'diff-hl-mode)
(global-set-key (kbd "s-d e") 'vc-ediff)
(global-set-key (kbd "s-d d") 'vc-diff)
(global-set-key (kbd "s-d u") 'vc-revert)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "s-f") 'projectile-find-file)
(global-set-key (kbd "C-4") 'auto-complete)
(key-chord-define-global "sb" 'ido-switch-buffer)
(global-set-key (kbd "C--") 'ace-window)
(define-prefix-command 'gcr/two-key-map)
(global-set-key (kbd "s-2") 'gcr/two-key-map)
(define-prefix-command 'gcr/double-struck-map)
(define-key gcr/two-key-map "s" 'gcr/double-struck-map)
(define-key gcr/double-struck-map "A" (lambda () (interactive) (insert "𝔸")))
(define-key gcr/double-struck-map "B" (lambda () (interactive) (insert "𝔹")))
(define-key gcr/double-struck-map "C" (lambda () (interactive) (insert "ℂ")))
(define-key gcr/double-struck-map "D" (lambda () (interactive) (insert "𝔻")))
(define-key gcr/double-struck-map "E" (lambda () (interactive) (insert "𝔼")))
(define-key gcr/double-struck-map "F" (lambda () (interactive) (insert "𝔽")))
(define-key gcr/double-struck-map "G" (lambda () (interactive) (insert "𝔾")))
(define-key gcr/double-struck-map "H" (lambda () (interactive) (insert "ℍ")))
(define-key gcr/double-struck-map "I" (lambda () (interactive) (insert "𝕀")))
(define-key gcr/double-struck-map "J" (lambda () (interactive) (insert "𝕁")))
(define-key gcr/double-struck-map "K" (lambda () (interactive) (insert "𝕂")))
(define-key gcr/double-struck-map "L" (lambda () (interactive) (insert "𝕃")))
(define-key gcr/double-struck-map "M" (lambda () (interactive) (insert "𝕄")))
(define-key gcr/double-struck-map "N" (lambda () (interactive) (insert "ℕ")))
(define-key gcr/double-struck-map "O" (lambda () (interactive) (insert "𝕆")))
(define-key gcr/double-struck-map "P" (lambda () (interactive) (insert "ℙ")))
(define-key gcr/double-struck-map "Q" (lambda () (interactive) (insert "ℚ")))
(define-key gcr/double-struck-map "R" (lambda () (interactive) (insert "ℝ")))
(define-key gcr/double-struck-map "S" (lambda () (interactive) (insert "𝕊")))
(define-key gcr/double-struck-map "T" (lambda () (interactive) (insert "𝕋")))
(define-key gcr/double-struck-map "U" (lambda () (interactive) (insert "𝕌")))
(define-key gcr/double-struck-map "V" (lambda () (interactive) (insert "𝕍")))
(define-key gcr/double-struck-map "W" (lambda () (interactive) (insert "𝕎")))
(define-key gcr/double-struck-map "X" (lambda () (interactive) (insert "𝕏")))
(define-key gcr/double-struck-map "Y" (lambda () (interactive) (insert "𝕐")))
(define-key gcr/double-struck-map "Z" (lambda () (interactive) (insert "ℤ")))
(define-key gcr/double-struck-map "a" (lambda () (interactive) (insert "𝕒")))
(define-key gcr/double-struck-map "b" (lambda () (interactive) (insert "𝕓")))
(define-key gcr/double-struck-map "c" (lambda () (interactive) (insert "𝕔")))
(define-key gcr/double-struck-map "d" (lambda () (interactive) (insert "𝕕")))
(define-key gcr/double-struck-map "e" (lambda () (interactive) (insert "𝕖")))
(define-key gcr/double-struck-map "f" (lambda () (interactive) (insert "𝕗")))
(define-key gcr/double-struck-map "g" (lambda () (interactive) (insert "𝕘")))
(define-key gcr/double-struck-map "h" (lambda () (interactive) (insert "𝕙")))
(define-key gcr/double-struck-map "i" (lambda () (interactive) (insert "𝕚")))
(define-key gcr/double-struck-map "j" (lambda () (interactive) (insert "𝕛")))
(define-key gcr/double-struck-map "k" (lambda () (interactive) (insert "𝕜")))
(define-key gcr/double-struck-map "l" (lambda () (interactive) (insert "𝕝")))
(define-key gcr/double-struck-map "m" (lambda () (interactive) (insert "𝕞")))
(define-key gcr/double-struck-map "n" (lambda () (interactive) (insert "𝕟")))
(define-key gcr/double-struck-map "o" (lambda () (interactive) (insert "𝕠")))
(define-key gcr/double-struck-map "p" (lambda () (interactive) (insert "𝕡")))
(define-key gcr/double-struck-map "q" (lambda () (interactive) (insert "𝕢")))
(define-key gcr/double-struck-map "r" (lambda () (interactive) (insert "𝕣")))
(define-key gcr/double-struck-map "s" (lambda () (interactive) (insert "𝕤")))
(define-key gcr/double-struck-map "t" (lambda () (interactive) (insert "𝕥")))
(define-key gcr/double-struck-map "u" (lambda () (interactive) (insert "𝕦")))
(define-key gcr/double-struck-map "v" (lambda () (interactive) (insert "𝕧")))
(define-key gcr/double-struck-map "w" (lambda () (interactive) (insert "𝕨")))
(define-key gcr/double-struck-map "x" (lambda () (interactive) (insert "𝕩")))
(define-key gcr/double-struck-map "y" (lambda () (interactive) (insert "𝕪")))
(define-key gcr/double-struck-map "z" (lambda () (interactive) (insert "𝕫")))
(define-key gcr/double-struck-map "0" (lambda () (interactive) (insert "𝟘")))
(define-key gcr/double-struck-map "1" (lambda () (interactive) (insert "𝟙")))
(define-key gcr/double-struck-map "2" (lambda () (interactive) (insert "𝟚")))
(define-key gcr/double-struck-map "3" (lambda () (interactive) (insert "𝟛")))
(define-key gcr/double-struck-map "4" (lambda () (interactive) (insert "𝟜")))
(define-key gcr/double-struck-map "5" (lambda () (interactive) (insert "𝟝")))
(define-key gcr/double-struck-map "6" (lambda () (interactive) (insert "𝟞")))
(define-key gcr/double-struck-map "7" (lambda () (interactive) (insert "𝟟")))
(define-key gcr/double-struck-map "8" (lambda () (interactive) (insert "𝟠")))
(define-key gcr/double-struck-map "9" (lambda () (interactive) (insert "𝟡")))
(global-set-key (kbd "s-p") 'gcr/describe-thing-in-popup)
(global-set-key (kbd "M-3") 'hs-toggle-hiding)
(global-set-key (kbd "s-<return>") 'gcr/smart-open-line)
(global-set-key (kbd "M-<return>") 'gcr/lazy-new-open-line)
(global-set-key (kbd "M-:") 'my-eval-expression)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "<f8>") 'magit-status)
(global-set-key (kbd "<f9>") 'gcr/util-cycle)
(global-set-key (kbd "<f12>") 'neotree-toggle)
(global-set-key (kbd "M-7") 'gcr/insert-timestamp)
(global-set-key (kbd "s-7") 'gcr/insert-timestamp*)
(global-set-key (kbd "C-7") 'gcr/insert-datestamp)

(gcr/on-gui
 (global-set-key (kbd "s-<f7>") 'gcr/text-scale-increase)
 (global-set-key (kbd "M-<f7>") 'gcr/text-scale-decrease))
(global-set-key (kbd "C-<f2>") 'emacs-index-search)
(global-set-key (kbd "S-<f2>") 'elisp-index-search)
(global-set-key (kbd "C-<f3>") 'imenu-anywhere)
(global-set-key (kbd "s-<up>") 'shrink-window)
(global-set-key (kbd "s-<down>") 'enlarge-window)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)

(global-set-key (kbd "<f7>") 'list-world-time)
(gcr/on-windows
 (defun gcr/ymh-h ()
   (define-key yas-minor-mode-map (kbd "M-s-4") 'yas-expand))
 (add-hook 'yas-minor-mode-hook 'gcr/ymh-h)
 (defun gcr/omh-h ()
   (local-set-key (kbd "M-s-h") 'org-babel-check-src-block)
   (local-set-key (kbd "M-s-a i") 'org-babel-insert-header-arg)
   (local-set-key (kbd "M-s-j") 'org-babel-previous-src-block)
   (local-set-key (kbd "M-s-k") 'org-babel-next-src-block)
   (local-set-key (kbd "M-s-l") 'org-babel-demarcate-block)
   (local-set-key (kbd "M-s-;") 'org-babel-view-src-block-info)
   (local-set-key (kbd "M-s-b s") 'org-babel-switch-to-session)
   (local-set-key (kbd "M-s-b c") 'org-babel-switch-to-session-with-code)
   (local-set-key (kbd "M-s-o") 'org-babel-execute-maybe)
   (local-set-key (kbd "M-s-t") 'org-babel-tangle)
   (local-set-key (kbd "M-s-x") 'org-babel-do-key-sequence-in-edit-buffer)
   (local-set-key (kbd "M-s-w w") 'org-export-dispatch)
   (local-set-key (kbd "M-s-<f5>") 'org-babel-execute-buffer)
   (local-set-key (kbd "M-s-i d") 'org-display-inline-images)
   (local-set-key (kbd "M-s-i r") 'org-remove-inline-images))
 (add-hook 'org-mode-hook 'gcr/omh-h)
 (defun gcr/emh-h ()
   (local-set-key (kbd "M-s-l eb") 'gcr/elisp-eval-buffer)
   (local-set-key (kbd "M-s-l ep") 'eval-print-last-sexp)
   (local-set-key (kbd "M-s-l td") 'toggle-debug-on-error)
   (local-set-key (kbd "M-s-l mef") 'macroexpand)
   (local-set-key (kbd "M-s-l mea") 'macroexpand-all)
   (local-set-key (kbd "M-s-p") 'gcr/describe-thing-in-popup)
   )
 
 (global-set-key (kbd "M-s-d h") 'diff-hl-mode)
 (global-set-key (kbd "M-s-d e") 'vc-ediff)
 (global-set-key (kbd "M-s-d d") 'vc-diff)
 (global-set-key (kbd "M-s-d u") 'vc-revert)
 (global-set-key (kbd "M-s-f") 'projectile-find-file)
 (global-set-key (kbd "M-s-2") 'gcr/two-key-map)
 (global-set-key (kbd "M-s-p") 'gcr/describe-thing-in-popup)
 (global-set-key (kbd "M-s-<return>") 'gcr/smart-open-line)
 (global-set-key (kbd "M-s-7") 'gcr/insert-timestamp*)
 (global-set-key (kbd "M-s-<f7>") 'gcr/text-scale-increase)
 (global-set-key (kbd "M-s-<up>") 'enlarge-window)
 (global-set-key (kbd "M-s-<down>") 'shrink-window)
 (global-set-key (kbd "M-s-<right>") 'enlarge-window-horizontally)
 (global-set-key (kbd "M-s-<left>") 'shrink-window-horizontally))
(require 'clips-mode)
(setq comint-scroll-to-bottom-on-input 'this)
(setq comint-scroll-to-bottom-on-output 'others)
(setq comint-move-point-for-output 'others)
(setq comint-show-maximum-output t)
(setq comint-scroll-show-maximum-output t)
(setq comint-move-point-for-output t)
(setq comint-prompt-read-only nil)
(defun gcr/css-modehook ()
  (fci-mode)
  (whitespace-turn-on)
  (visual-line-mode)
  (gcr/untabify-buffer-hook)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'css-mode-hook 'gcr/css-modehook)
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
  (local-set-key (kbd "s-l mea") 'macroexpand-all)
  (local-set-key (kbd "s-p") 'gcr/describe-thing-in-popup)
  (local-set-key (kbd "M-:") 'my-eval-expression)
  (local-set-key (kbd "#") 'endless/sharp))

(require 'lexbind-mode)

(defun gcr/emacs-lisp-mode-hook ()
  (gcr/elisp-mode-local-bindings)
  (lexbind-mode)
  (turn-on-eldoc-mode)
  (gcr/diminish 'eldoc-mode)
  (aggressive-indent-mode))

(add-hook 'emacs-lisp-mode-hook 'gcr/emacs-lisp-mode-hook)

(setq initial-scratch-message nil)
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
(defconst gcr/eshell-dir "~/.emacs.d/eshell")
(defun gcr/warn-eshell-dir ()
  "Warn of eshell misconfiguration."
  (interactive)
  (unless (and (f-symlink? gcr/eshell-dir)
             (f-directory? gcr/eshell-dir))
    (warn
     "Could not find the eshell directory at: %S. Eshell will continue to function albeit without your customizations."
     gcr/eshell-dir)))
(gcr/warn-eshell-dir)
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
(add-to-list 'find-file-not-found-functions #'gcr/create-non-existent-directory)
(defun gcr/graphviz-dot-mode-hook ()
  "Personal mode bindings for Graphviz mode."
  (fci-mode)
  (visual-line-mode))

(add-hook 'graphviz-dot-mode-hook 'gcr/graphviz-dot-mode-hook)
(require 'writegood-mode)
(require 'langtool)
(setq langtool-language-tool-jar (concat (getenv "EELIB") "/LanguageTool-2.8/languagetool-commandline.jar"))
(setq langtool-mother-tongue "en")
(setq langtool-java-bin (concat (getenv "JAVA_HOME") "/bin/java"))
(setq help-window-select t)
(defun gcr/ibuffer-hook ()
  "Personal customizations"
  (interactive)
  (ibuffer-vc-set-filter-groups-by-vc-root)
  (unless (eq ibuffer-sorting-mode 'alphabetic)
    (ibuffer-do-sort-by-alphabetic)))

(add-hook 'ibuffer-hook 'gcr/ibuffer-hook)

(setq ibuffer-formats
      '((mark modified read-only vc-status-mini " "
              (name 18 18 :left :elide)
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              (vc-status 16 16 :left)
              " "
              filename-and-process)))
(defun gcr/ielm-mode-hook ()
  "Personal customizations."
  (interactive)
  (gcr/ielm-auto-complete))

(setq ielm-noisy nil)

(setq ielm-prompt "𝔼LISP> ")

(add-hook 'ielm-mode-hook 'gcr/ielm-mode-hook)
(require 'imenu-anywhere)
(setq imenu-sort-function 'imenu--sort-by-name)
(require 'imenu+)
(defun gcr/try-to-add-imenu ()
  "Add Imenu to modes that have `font-lock-mode' activated.

Attribution: SRC http://www.emacswiki.org/emacs/ImenuMode"
  (condition-case nil (imenu-add-to-menubar "Imenu") (error nil)))
 (add-hook 'font-lock-mode-hook 'gcr/try-to-add-imenu)
(ace-link-setup-default)
(defun gcr/js-mode-hook ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (setq js-indent-level 2)
  (fci-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook)
  (linum-mode))

(add-hook 'js-mode-hook 'gcr/js-mode-hook)
(require 'rainbow-delimiters)
(defconst lispy-modes
  '(clips-mode-hook
    emacs-lisp-mode-hook
    geiser-repl-mode-hook
    ielm-mode-hook
    lisp-interaction-mode-hook
    scheme-mode-hook))

(dolist (h lispy-modes)
  (add-hook h 'turn-on-smartparens-strict-mode)
  (add-hook h 'gcr/newline)
  (add-hook h 'gcr/disable-tabs))

(dolist (h lispy-modes)
  (when (not (member h '(ielm-mode-hook)))
    (add-hook h 'turn-on-pretty-mode)
    (add-hook h 'gcr/untabify-buffer-hook)
    (add-hook h 'fci-mode)
    (add-hook h (function (lambda () (hs-minor-mode 1))))
    (add-hook h 'linum-mode)
    (add-hook h 'visual-line-mode)
    (add-hook h (function (lambda ()
                            (add-hook 'local-write-file-hooks
                                      'check-parens))))))
(defun gcr/make-modehook ()
  (fci-mode)
  (whitespace-turn-on)
  (visual-line-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'makefile-mode-hook 'gcr/make-modehook)
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" +1)

(add-to-list 'auto-mode-alist '("\.markdown'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\.md'" . gfm-mode))

(defun gcr/markdown-mode-hook ()
  "Markdown mode customizations."
  (interactive)
  (fci-mode)
  (visual-line-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'markdown-mode-hook 'gcr/markdown-mode-hook)
(defun gcr/occur-mode-hook ()
  "Personal customizations."
  (interactive)
  (turn-on-stripe-buffer-mode)
  (stripe-listify-buffer))

(add-hook 'occur-mode-hook 'gcr/occur-mode-hook)
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
(define-key polymode-mode-map (kbd "s-e E") 'polymode-set-exporter)
(define-key polymode-mode-map (kbd "s-e e") 'polymode-weave)
(define-key polymode-mode-map (kbd "s-w s") 'polymode-set-weaver)
(define-key polymode-mode-map (kbd "s-w w") 'polymode-weave)
(define-key polymode-mode-map (kbd "s-w p") 'polymode-show-process-buffer)
(define-key polymode-mode-map (kbd "s-j") 'polymode-previous-chunk)
(define-key polymode-mode-map (kbd "s-k") 'polymode-next-chunk)
(define-key polymode-mode-map (kbd "s-o k") 'polymode-kill-chunk)
(define-key polymode-mode-map (kbd "s-o i") 'polymode-insert-new-chunk)
(define-key polymode-mode-map (kbd "s-o m") 'polymode-mark-or-extend-chunk)
(define-key polymode-mode-map (kbd "s-o t") 'polymode-toggle-chunk-narrowing)
(defun gcr/ruby-mode-hook ()
  (fci-mode)
  (gcr/untabify-buffer-hook)
  (visual-line-mode)
  (fci-mode)
  (turn-on-smartparens-strict-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'ruby-mode-hook 'gcr/ruby-mode-hook)
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

(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.rkt\\'" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.ss\\'" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.sls\\'" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.sps\\'" . scheme-mode))
(defun gcr/sh-mode-hook ()
  "Personal customizations."
  (interactive)
  (turn-on-smartparens-strict-mode)
  (turn-on-pretty-mode)
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode)
  (whitespace-turn-on)
  (visual-line-mode)
  (hs-minor-mode 1)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'sh-mode-hook 'gcr/sh-mode-hook)
(defun gcr/shell-mode-hook ()
  "Personalizations."
  (interactive)
  (turn-on-smartparens-strict-mode)
  (turn-on-pretty-mode)
  (gcr/disable-tabs)
  (fci-mode)
  (whitespace-turn-on)
  (visual-line-mode)
  (hs-minor-mode 1)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'shell-mode-hook 'gcr/shell-mode-hook)
(require 'sml-mode)
(defun gcr/sml-mode-hook ()
  "Personal settings."
  (interactive)
  (turn-on-pretty-mode)
  (turn-on-smartparens-strict-mode)
  (local-set-key (kbd "RET") 'newline-and-indent)
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode)
  (hs-minor-mode 1)
  (visual-line-mode))
(add-hook 'sml-mode-hook 'gcr/sml-mode-hook)
(setq sml-indent-level 2)
(setq sml-rightalign-and t)
(setq sml-electric-pipe-mode t)
(setq sml-program-name "sml")
(setq sml-font-lock-symbols nil)
(defadvice sml-prog-proc-load-file (before beforesml-prog-proc-load-file activate)
  (gcr/save-all-file-buffers))
(require 'sqlup-mode)
(require 'ctable)

(defun gcr/ctbl:table-mode-hook ()
  "Personal customization"
  (interactive))

(add-hook 'ctbl:table-mode-hook 'gcr/ctbl:table-mode-hook)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(defun gcr/TeX-mode-hook ()
  "Settings applicable to every AUCTeX supported mode."
  (interactive)
  (turn-on-smartparens-strict-mode)
  (gcr/disable-tabs)
  (fci-mode))

(add-hook 'TeX-mode-hook 'gcr/TeX-mode-hook)
(setq TeX-parse-self t) ;
(setq TeX-auto-save t) ;
(setq TeX-auto-untabify t)
(defadvice TeX-command-master (before before-TeX-command-master activate)
  (gcr/save-all-file-buffers))
(setq TeX-PDF-mode +1)
(setq TeX-DVI-via-PDFTeX +1)
(setq TeX-save-query nil)
(defun gcr/text-mode-hook ()
  (fci-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook))

(add-hook 'text-mode-hook 'gcr/text-mode-hook)
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
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

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))
(setq browse-url-browser-function 'browse-url-generic)
(gcr/on-gnu/linux (setq browse-url-generic-program "chromium-browser"))
(gcr/on-osx
 (setq browse-url-browser-function 'browse-url-default-macosx-browser)
 (require 'osx-browse)
 (osx-browse-mode 1))
(gcr/on-windows
 (setq browse-url-browser-function 'browse-url-default-windows-browser))
(require 'google-this)
(google-this-mode 1)
(gcr/diminish 'google-this-mode)
(setq tramp-default-user "gcr")
(setq tramp-default-method "ssh")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(defun gcr/yaml-mode-hook ()
  "Helpful behavior for YAML buffers."
  (interactive)
  (turn-on-smartparens-strict-mode)
  (gcr/newline)
  (gcr/disable-tabs)
  (turn-on-pretty-mode)
  (gcr/untabify-buffer)
  (fci-mode)
  (hs-minor-mode 1)
  (linum-mode)
  (visual-line-mode))

(require 'sparkline)
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
(defconst gcr/plantuml-jar (concat (expand-file-name (getenv "EELIB")) "/plantuml.8020.jar"))
(defun gcr/warn-plantuml-jar ()
  "Warn of plantuml misconfiguration."
  (interactive)
  (unless (f-exists? gcr/plantuml-jar)
    (warn
     "Can't seem to find a plantuml jar where it was expected at: %S. Plantuml will not function without it. Download a copy here: http://plantuml.sourceforge.net/"
     gcr/plantuml-jar)))
(gcr/warn-plantuml-jar)
(setq plantuml-jar-path gcr/plantuml-jar)
(require 'plantuml-mode)
(eval-after-load "ob-plantuml"
  (setq org-plantuml-jar-path gcr/plantuml-jar))
(defun gcr/plantuml-mode-hook ()
  "Personal settings."
  (interactive)
  (turn-on-pretty-mode)
  (turn-on-smartparens-strict-mode)
  (local-set-key (kbd "RET") 'newline-and-indent)
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode)
  (hs-minor-mode 1)
  (linum-mode)
  (wrap-region-mode t)
  (turn-on-stripe-table-mode))
(add-hook 'plantuml-mode-hook 'gcr/plantuml-mode-hook)
(eval-after-load "dash" '(dash-enable-font-lock))
(require 'f)
(require 'xml-rpc)
(require 'metaweblog)
(require 'uuid)
(require 'figlet)
(setq figlet-font-directory "/usr/local/bin/")
(require 'nyan-mode)
(require 'highlight-tail)
(require 'zone)
