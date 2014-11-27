
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Fully%20Loaded%20System][Fully\ Loaded\ System:1]]

;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org%20Only%20System][base-configuration]]
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Run-time][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*General%20stuff%20%5Bfn:5fa1ff0b:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html%5D%20%5Bfn:13c610e7:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/User-Identification.html%5D%20%5Bfn:2e194253:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-Examples.html%5D%20%5Bfn:374f40df:%20http://nic.ferrier.me.uk/blog/2012_07/tips-and-tricks-for-emacslisp%5D][nil]]
(setq-default user-full-name "Grant Rettke"
              user-mail-address "gcr@wisdomandwonder.com")

(setq-default eval-expression-print-level nil)
(setq-default case-fold-search +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*General%20stuff%20%5Bfn:5fa1ff0b:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html%5D%20%5Bfn:13c610e7:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/User-Identification.html%5D%20%5Bfn:2e194253:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-Examples.html%5D%20%5Bfn:374f40df:%20http://nic.ferrier.me.uk/blog/2012_07/tips-and-tricks-for-emacslisp%5D][nil]]
(setq gc-cons-threshold (* 128 1024 1024))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*General%20stuff%20%5Bfn:5fa1ff0b:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html%5D%20%5Bfn:13c610e7:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/User-Identification.html%5D%20%5Bfn:2e194253:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-Examples.html%5D%20%5Bfn:374f40df:%20http://nic.ferrier.me.uk/blog/2012_07/tips-and-tricks-for-emacslisp%5D][nil]]
(setq max-specpdl-size 1500)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*General%20stuff%20%5Bfn:5fa1ff0b:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html%5D%20%5Bfn:13c610e7:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/User-Identification.html%5D%20%5Bfn:2e194253:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-Examples.html%5D%20%5Bfn:374f40df:%20http://nic.ferrier.me.uk/blog/2012_07/tips-and-tricks-for-emacslisp%5D][nil]]
(setq debug-on-error nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Utility%20functions][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Provisioning%20/%20Cask%20%5Bfn:0d825bc1:%20%5B%5BCask%5D%5Bhttps://github.com/cask/cask%5D%5D%5D%20/%20egl-get%20%5Bfn:9be5a727:%20https://github.com/dimitri/el-get%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
(require 'el-get)
(setq gcr/el-get-packages nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
(add-to-list
 'el-get-sources
 '(:name org-show
          :type http
          :url "https://raw.githubusercontent.com/jkitchin/jmax/master/org-show.org"
          :website "https://github.com/jkitchin/jmax/blob/master/org-show.org"
          :description "simple presentations in org-mode"))
(add-to-list 'gcr/el-get-packages 'org-show)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*el-get%20packages][nil]]
(el-get 'sync gcr/el-get-packages)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Environment][nil]]
(require 'exec-path-from-shell)
(gcr/on-osx (exec-path-from-shell-initialize))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Environment][nil]]
(require 'alert)
(setq alert-fade-time 10)
(gcr/on-gui
 (gcr/on-osx
   (setq alert-default-style 'growl)))
(setq alert-reveal-idle-time 120)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Environment][nil]]
(gcr/on-windows
 (setq shell-file-name "cmdproxy.exe"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Operation,%20Keybindings,%20and%20Keymaps%20%5Bfn:256:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Keymaps.html#Keymaps%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Operation,%20Keybindings,%20and%20Keymaps%20%5Bfn:256:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Keymaps.html#Keymaps%5D][nil]]
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Keyboard][nil]]
(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.1)
;; nil ends here
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Operation,%20Keybindings,%20and%20Keymaps%20%5Bfn:256:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Keymaps.html#Keymaps%5D][nil]]
(gcr/on-osx
 (setq mac-control-modifier 'control)
 (setq mac-command-modifier 'meta)
 (setq mac-option-modifier 'super))

(gcr/on-windows
 (setq w32-lwindow-modifier 'super)
 (setq w32-rwindow-modifier 'super))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Operation,%20Keybindings,%20and%20Keymaps%20%5Bfn:256:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Keymaps.html#Keymaps%5D][nil]]
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Operation,%20Keybindings,%20and%20Keymaps%20%5Bfn:256:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Keymaps.html#Keymaps%5D][nil]]
(setq echo-keystrokes 0.02)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "3." 'gcr/insert-ellipsis)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "4 " (lambda () (interactive) (insert "    ")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global (concat "A" "{") (lambda () (interactive) (insert "ä")))
(key-chord-define-global (concat "A" "}") (lambda () (interactive) (insert "Ä")))
(key-chord-define-global (concat "O" "{") (lambda () (interactive) (insert "ö")))
(key-chord-define-global (concat "O" "}") (lambda () (interactive) (insert "Ö")))
(key-chord-define-global (concat "U" "{") (lambda () (interactive) (insert "ü")))
(key-chord-define-global (concat "U" "}") (lambda () (interactive) (insert "Ü")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(global-set-key (kbd "C-,") (lambda () (interactive) (insert "←")))
(global-set-key (kbd "C-.") (lambda () (interactive) (insert "→")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "<<" (lambda () (interactive) (insert "«")))
(key-chord-define-global ">>" (lambda () (interactive) (insert "»")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "jk" 'ace-jump-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "m," 'ace-jump-mode-pop-mark)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "fg" 'goto-line)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "vb" 'pop-to-mark-command)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(require 'linum-relative)
(key-chord-define-global "dk" 'linum-relative-toggle)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "nm" 'ace-window)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "JK" (lambda () (interactive) (other-window 1)))
(key-chord-define-global "KL" (lambda () (interactive) (next-buffer)))
(key-chord-define-global "L:" (lambda () (interactive) (previous-buffer)))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "ws" 'google-this-mode-submap)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(global-set-key (kbd "C-a") 'beginning-of-line-dwim)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(global-set-key (kbd "C-;") 'vc-next-action)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(global-set-key (kbd "C-'") 'er/expand-region)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(global-set-key (kbd "M-9") 'mc/edit-lines)
(global-set-key (kbd "M-0") 'mc/mark-next-like-this)
(global-set-key (kbd "M--") 'mc/mark-all-like-this)
(global-set-key (kbd "M-8") 'mc/mark-previous-like-this)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(key-chord-define-global "yu" 'move-text-up)
(key-chord-define-global "hj" 'move-text-down)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*NON-DISRUPTIVE][nil]]
(global-set-key (kbd "s-l i") 'gcr/move-line-up)
(global-set-key (kbd "s-l k") 'gcr/move-line-down)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "s-p") 'gcr/describe-thing-in-popup)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "C--") 'ace-window)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "C-3") 'auto-complete)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "M-3") 'hs-toggle-hiding)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "C-5") 'gcr/comment-or-uncomment)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "M-<return>") 'gcr/lazy-new-open-line)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "s-d h") 'diff-hl-mode)
(global-set-key (kbd "s-d l") 'vc-diff)
(global-set-key (kbd "s-d u") 'vc-revert)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "M-:") 'my-eval-expression)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "s-f") 'projectile-find-file)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "C-4") 'ido-switch-buffer)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*SLIGHTLY-DISRUPTIVE][nil]]
(global-set-key (kbd "s-u dse") (lambda () (interactive) (insert "𝔼")))
;; if there is magic, then the x goes here →
(global-set-key (kbd "s-u dsr") (lambda () (interactive) (insert "ℝ")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*DISRUPTIVE][nil]]
(global-set-key (kbd "M-7") 'gcr/insert-datestamp)
(global-set-key (kbd "s-7") 'gcr/insert-timestamp*)
(global-set-key (kbd "C-7") 'gcr/insert-timestamp)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*DISRUPTIVE][nil]]
(global-set-key (kbd "s-<tab>") 'auto-complete)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(gcr/on-gui
 (global-set-key (kbd "s-<f7>") 'gcr/text-scale-increase)
 (global-set-key (kbd "M-<f7>") 'gcr/text-scale-decrease))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(global-set-key (kbd "C-<f2>") 'emacs-index-search)
(global-set-key (kbd "S-<f2>") 'elisp-index-search)
(global-set-key (kbd "C-<f3>") 'imenu-anywhere)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(global-set-key (kbd "s-<up>") 'enlarge-window)
(global-set-key (kbd "s-<down>") 'shrink-window)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(global-set-key (kbd "<f7>") 'list-world-time)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(global-set-key (kbd "<f8>") 'magit-status)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(global-set-key (kbd "<f9>") 'gcr/util-cycle)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(global-set-key (kbd "<f11>") 'other-window)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*VERY%20DISRUPTIVE][nil]]
(global-set-key (kbd "<f12>") 'neotree-toggle)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ditaa][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ditaa][nil]]
(add-to-list 'auto-mode-alist '("\\.asc" . artist-mode))
(add-to-list 'auto-mode-alist '("\\.art" . artist-mode))
(add-to-list 'auto-mode-alist '("\\.asc" . artist-mode))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*plantuml][nil]]
(defconst gcr/plantuml-jar (concat (expand-file-name (getenv "EELIB")) "/plantuml.8008.jar"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*plantuml][nil]]
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
  (rainbow-mode)
  (turn-on-smartparens-strict-mode)
  (local-set-key (kbd "RET") 'newline-and-indent)
  (turn-on-real-auto-save)
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode)
  (hs-minor-mode)
  (linum-mode)
  (wrap-region-mode t)
  (turn-on-stripe-table-mode))
(add-hook 'plantuml-mode-hook 'gcr/plantuml-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(require 'ess-site)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(defconst gcr/ess-version "14.1x")

(defun gcr/warn-ess-version ()
  "Warn of ess misconfiguration."
  (interactive)
  (when (not (version= ess-version gcr/ess-version))
    (warn "Insufficient ess-mode requirements. Expected %S. Found: %S " gcr/ess-version ess-version)))
(gcr/warn-ess-version)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-eldoc-show-on-symbol t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-use-tracebug t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-tracebug-search-path '())
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(define-key compilation-minor-mode-map [(?n)] 'next-error-no-select)
(define-key compilation-minor-mode-map [(?p)] 'previous-error-no-select)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-watch-scale-amount -1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-describe-at-point-method 'tooltip)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(require 'ess-R-object-popup)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(autoload 'ess-rdired "ess-rdired")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(require 'ess-R-data-view)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(require 'inlineR)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq inferior-ess-program "R")
(setq inferior-R-program-name "R")
(setq ess-local-process-name "R")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq inferior-S-prompt "[]a-zA-Z0-9.[]*\\(?:[>+.] \\)*ℝ+> ")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq inferior-ess-same-window nil)
(setq inferior-ess-own-frame nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-help-own-frame nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-ask-for-ess-directory nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq inferior-ess-exit-command "q('no')
")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-execute-in-process-buffer +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-switch-to-end-of-proc-buffer t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-tab-complete-in-script +1)
(setq ess-first-tab-never-complete 'symbol-or-paren-or-punct)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-use-ido t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(add-to-list 'auto-mode-alist '("\\.rd\\'" . Rd-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd$" . r-mode))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-use-eldoc t)
(setq ess-eldoc-show-on-symbol t)
(setq ess-eldoc-abbreviation-style 'normal)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(local-set-key (kbd "C-c C-. S") 'ess-rutils-rsitesearch)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(require 'ess-rutils)
(setq ess-rutils-keys +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(require 'r-autoyas)

(setq r-autoyas-debug t)
(setq r-autoyas-expand-package-functions-only nil)
(setq r-autoyas-remove-explicit-assignments nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-ac-R-argument-suffix "=")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
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
  (smartparens-strict-mode)
  (rainbow-mode)
  (turn-on-real-auto-save)
  (gcr/untabify-buffer-hook)
  (fci-mode)
  (hs-minor-mode)
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq inferior-ess-primary-prompt "ℝ> ")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-keep-dump-files +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-delete-dump-files nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-mode-silently-save +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq inferior-R-args "--no-save --no-restore")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
;;(sp-local-pair 'ess-mode "{" nil :post-handlers '((gcr/indent-curly-block "RET")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Speaks%20Statistics%20(ESS)%20%5Bfn:3bba0c0c:%20http://ess.r-project.org/%5D%20%5Bfn:25441790:%20https://en.wikipedia.org/wiki/Emacs_Speaks_Statistics%5D%20%5Bfn:a2ae633d:%20http://www.emacswiki.org/emacs/EmacsSpeaksStatistics%5D%20%5Bfn:b28cb112:%20http://blog.revolutionanalytics.com/2011/08/ess.html%5D%20%5Bfn:353ffc35:%20http://blog.revolutionanalytics.com/2014/03/emacs-ess-and-r-for-zombies.html%5D%20%5Bfn:3b20a6da:%20https://rstudio-pubs-static.s3.amazonaws.com/2246_6f220d4de90c4cfda4109e62455bc70f.html%5D][nil]]
(setq ess-eval-visibly 'nowait)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Discussion][nil]]
(setq org-edit-src-code nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Configuration][nil]]
(setq org-list-allow-alphabetical +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(require 'org)
(require 'ox-beamer)
(require 'ox-md)
(require 'htmlize)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq htmlize-output-type 'inline-css)
(setq org-html-htmlize-output-type htmlize-output-type)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(let ((pkg 'org-show))
  (gcr/on-gui
   (if (not (el-get-package-is-installed pkg))
       (warn "You wanted %S to be installed, but it isnt. Fix this." pkg)
     (let ((fil (concat (el-get-package-directory pkg) "org-show.el")))
       (if (not (f-exists? fil))
           (warn "You wanted %S to exist, but it doesn't. Fix this." fil)
         (load fil)))))
  (gcr/not-on-gui (warn "You wanted %S to be loaded, but it won't be… it doesn't work without a GUI for some reason." pkg)))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(defconst gcr/org-version "8.2.10")

(defun gcr/warn-org-version ()
  "Warn of org misconfiguration."
  (interactive)
  (when (not (version= (org-version) gcr/org-version))
    (warn "Insufficient org-mode requirements. Expected %S. Found: %S " gcr/org-version (org-version))))
(gcr/warn-org-version)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-export-coding-system 'utf-8)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-export-preserve-breaks nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(require 'org2blog-autoloads)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "REVIEW" "DONE")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-startup-with-inline-images (display-graphic-p))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-export-copy-to-kill-ring nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-completion-use-ido +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-use-speed-commands +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-confirm-shell-link-function 'y-or-n-p)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-confirm-elisp-link-function 'y-or-n-p)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-enforce-todo-dependencies +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(gcr/on-gui
 (require 'org-mouse))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-pretty-entities +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-ellipsis "…")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-hide-leading-stars +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-fontify-emphasized-text +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-highlight-latex-and-related '(latex script entities))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(require 'org-ac)
(org-ac/config-default)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-footnote-define-inline +1)
(setq org-footnote-auto-label 'random)
(setq org-footnote-auto-adjust nil)
(setq org-footnote-section nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-catch-invisible-edits 'error)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-loop-over-headlines-in-active-region t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-export-with-toc nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-startup-folded "nofold")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-image-actual-width t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Org][nil]]
(setq org-hide-emphasis-markers +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(defun gcr/org-babel-after-execute-hook ()
  "Personal settings for the `org-babel-after-execute-hook'."
  (interactive)
  (org-display-inline-images nil t))

(add-hook 'org-babel-after-execute-hook 'gcr/org-babel-after-execute-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(require 'ob-sml nil 'noerror)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-babel-use-quick-and-dirty-noweb-expansion nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-src-fontify-natively nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-src-preserve-indentation +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-src-strip-leading-and-trailing-blank-lines nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-edit-src-content-indentation 0)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(add-to-list
 'org-structure-template-alist
 '("el" "#+begin_src emacs-lisp\n?\n#+end_src" "<src lang=\"emacs-lisp\">\n?\n</src>"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(mapc (lambda (asc)
        (let ((org-sce-dc (downcase (nth 1 asc))))
          (setf (nth 1 asc) org-sce-dc)))
      org-structure-template-alist)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(add-to-list
 'org-structure-template-alist
 '("r" "#+begin_src R\n?\n#+end_src" "<src lang=\"R\"></src>"))
(add-to-list
 'org-structure-template-alist
 '("p" "#+begin_src plantuml\n?\n#+end_src" "<src lang=\"plantuml\"></src>"))
(add-to-list
 'org-structure-template-alist
 '("sh" "#+begin_src sh\n?\n#+end_src" "<src lang=\"sh\"></src>"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
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

;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(defadvice org-latex-export-to-pdf (before org-latex-export-to-pdf-before activate)
  (gcr/save-all-file-buffers))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-babel-min-lines-for-block-output 0)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-edit-src-auto-save-idle-delay 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-src-window-setup 'current-window)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-babel-results-keyword "NAME")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-babel-no-eval-on-ctrl-c-ctrl-c +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(setq org-babel-noweb-wrap-start "«")
(setq org-babel-noweb-wrap-end "»")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Babel][nil]]
(defadvice vc-next-action (before vc-next-action-in-org-src-block last activate)
  "If in org source block, exit it."
  (when (condition-case nil
            (org-src-in-org-buffer)
          (error nil))
    (org-edit-src-exit)))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Comments%20%5Bfn:1e1a7e1f:%20http://orgmode.org/manual/comments.html#comments%5D][nil]]
(gcr/set-org-babel-default-header-args :comments "noweb")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Results%20%5Bfn:1625d11f:%20http://orgmode.org/manual/results.html#results%5D][nil]]
(gcr/set-org-babel-default-header-args :results "output replace")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Exports%20%5Bfn:7dad95aa:%20http://orgmode.org/manual/exports.html#exports%5D][nil]]
(gcr/set-org-babel-default-header-args :exports "both")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Noweb%20%5Bfn:3da67e2d:%20http://orgmode.org/manual/noweb.html#noweb%5D][nil]]
(gcr/set-org-babel-default-header-args :noweb "no-export")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Padline%20%5Bfn:508104fc:%20http://orgmode.org/manual/padline.html%5D][nil]]
(gcr/set-org-babel-default-header-args :padline "yes")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Putting%20the%20Pieces%20Together][nil]]
(setq org-confirm-babel-evaluate nil)
(gcr/set-org-babel-default-header-args :eval "always")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Putting%20the%20Pieces%20Together][nil]]
(setq org-export-babel-evaluate 'inline-only)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Putting%20the%20Pieces%20Together][nil]]
(gcr/set-org-babel-default-inline-header-args :eval "always")
(gcr/set-org-babel-default-inline-header-args :results "value replace")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*%E2%84%9D%20Specific][nil]]
(gcr/set-org-babel-default-header-args:R :session "*R*")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("^#\\+begin_src ". "#\\+end_src$"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC ". "#\\+END_SRC$"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("^#\\+begin_example ". "#\\+end_example$"))
(add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXAMPLE ". "#\\+END_EXAMPLE$"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("\:PROPERTIES\:$" . "\:END\:$"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("\\[fn:.+:" . "\\]"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("^http" . "\\]"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("=.*" . ".*="))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
(add-to-list 'ispell-skip-region-alist '("- \\*.+" . ".*\\*: "))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ispell][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Hooks][nil]]
(define-key org-mode-map (kbd "C-,") (lambda () (interactive) (insert " \\larr ")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Hooks][nil]]
(defun gcr/org-mode-hook ()
  (local-set-key (kbd "C-1") 'org-narrow-to-subtree)
  (local-set-key (kbd "M-1") 'widen)
  (local-set-key (kbd "C-2") 'gcr/org-edit-src-code-plus-name)
  (local-set-key (kbd "s-h") 'org-babel-check-src-block)
  (local-set-key (kbd "s-a i") 'org-babel-insert-header-arg)
  (local-set-key (kbd "s-j") 'org-babel-previous-src-block)
  (local-set-key (kbd "s-k") 'org-babel-next-src-block)
  (local-set-key (kbd "s-l") 'org-babel-demarcate-block)
  (local-set-key (kbd "s-;") 'org-babel-view-src-block-info)
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
  (turn-on-real-auto-save)
  (when (and (fboundp 'guide-key-mode) guide-key-mode)
    (guide-key/add-local-guide-key-sequence "C-c")
    (guide-key/add-local-guide-key-sequence "C-c C-x")
    (guide-key/add-local-highlight-command-regexp "org-"))
  (org2blog/wp-mode)
  (gcr/diminish 'org2blog/wp-mode)
  (fci-mode)
  (gcr/untabify-buffer-hook)
  (turn-on-stripe-table-mode)
  (linum-mode)
  (wrap-region-mode t))

(add-hook 'org-mode-hook 'gcr/org-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Hooks][nil]]
(defun gcr/org-src-mode-hook ()
  (local-set-key (kbd "C-2") 'org-edit-src-exit)
  (visual-line-mode))

(add-hook 'org-src-mode-hook 'gcr/org-src-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Analytics][nil]]
(defconst gcr/keyfreq-file "~/.emacs.keyfreq")
(defun gcr/warn-keyfreq-file ()
  "Warn of keyfreq misconfiguration."
  (interactive)
  (unless (f-exists? gcr/keyfreq-file)
    (warn "Can't seem to find a symlink at: %S. Keyfreq expeced it there, and will continue to function, but your data will probably be lost." gcr/keyfreq-file)))
(gcr/warn-keyfreq-file)
(require 'keyfreq)
(setq keyfreq-file gcr/keyfreq-file)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)
;; nil ends here
;; base-configuration ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(menu-bar-mode +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(setq-default fill-column 80)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(blink-cursor-mode 0)
(gcr/on-gui
 (setq-default cursor-type 'box))
(setq x-stretch-cursor 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(global-linum-mode -1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(global-font-lock-mode 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(setq blink-matching-paren nil)
(show-paren-mode +1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(setq ring-bell-function 'ignore)
(setq visible-bell +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(winner-mode +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Windows%20%5Bfn:3f67f4f3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows.html%5D][nil]]
(gcr/on-osx
 (defadvice yes-or-no-p (around prevent-dialog activate)
   "Prevent yes-or-no-p from activating a dialog"
   (let ((use-dialog-box nil))
     ad-do-it))

 (defadvice y-or-n-p (around prevent-dialog-yorn activate)
   "Prevent y-or-n-p from activating a dialog"
   (let ((use-dialog-box nil))
     ad-do-it)))
;; nil ends here
(gcr/on-gui
 ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Frames%20%5Bfn:88b06925:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Frames.html%5D][nil]]
 (setq frame-title-format '("the ultimate…"))
 ;; nil ends here
 ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Frames%20%5Bfn:88b06925:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Frames.html%5D][nil]]
 (scroll-bar-mode -1)
 ;; nil ends here
 ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Frames%20%5Bfn:88b06925:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Frames.html%5D][nil]]
 (tool-bar-mode 0)
 ;; nil ends here
 ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Frames%20%5Bfn:88b06925:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Frames.html%5D][nil]]
 (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
 (setq mouse-wheel-progressive-speed nil)
 (setq mouse-wheel-follow-mouse +1)
 ;; nil ends here
 ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Frames%20%5Bfn:88b06925:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Frames.html%5D][nil]]
 (require 'pos-tip)
 (setq pos-tip-foreground-color "#073642")
 (setq pos-tip-background-color "#839496")
 (gcr/on-windows
  (pos-tip-w32-max-width-height))
 ;; nil ends here
)
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(desktop-save-mode 1)
(setq desktop-restore-eager 10)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'real-auto-save)
(setq real-auto-save-interval 15)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(add-to-list 'load-path "/usr/share/emacs/site-lisp/ccrypt")
(require 'ps-ccrypt "ps-ccrypt.el")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(setq backup-inhibited 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(setq auto-save-default nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(add-hook 'write-file-hooks
          (lambda ()
            (gcr/delete-trailing-whitespace)))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(prefer-coding-system 'utf-8)
(gcr/on-gui
 (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
 (gcr/on-windows
  (set-clipboard-coding-system 'utf-16le-dos)))

;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'undo-tree)
(global-undo-tree-mode 1)
(gcr/diminish 'undo-tree-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(setq require-final-newline t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(global-auto-revert-mode 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'sublimity)
(require 'sublimity-scroll)
(require 'sublimity-map)
(require 'sublimity-attractive)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(sublimity-map-set-delay nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(let ((text-buffer (get-buffer-create "*text*")))
  (with-current-buffer text-buffer
    (text-mode)
    (insert "Shall we play a game?")
    (beginning-of-line)))

;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(setq isearch-lax-whitespace +1)
(setq isearch-regexp-lax-whitespace +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'boxquote)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(setq track-eol +1)
(setq line-move-visual nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(global-set-key [?\C-x ?t] 'anchored-transpose)
(autoload 'anchored-transpose "anchored-transpose" nil t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'ibuffer)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'smooth-scrolling)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(linum-relative-toggle)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'nyan-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'highlight-tail)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'zone)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'stripe-buffer)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'wrap-region)
(gcr/diminish 'wrap-region-mode)

(wrap-region-add-wrapper "*" "*" nil 'org-mode) ;; bold
(wrap-region-add-wrapper "/" "/" nil 'org-mode) ;; italic
(wrap-region-add-wrapper "_" "_" nil 'org-mode) ;; underlined
(wrap-region-add-wrapper "=" "=" nil 'org-mode) ;; verbatim
(wrap-region-add-wrapper "~" "~" nil 'org-mode) ;; code
(wrap-region-add-wrapper "+" "+" nil 'org-mode) ;; strike-through
;; (wrap-region-add-wrapper "" "w" 'org-mode) ;; noweb blocks
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Buffers%20%5Bfn:595a3296:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Buffers.html#Buffers%5D][nil]]
(require 'fixmee)
(global-fixmee-mode 1)
(gcr/diminish 'fixmee-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Line%20Wrapping%20%5Bfn:46bfb076:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Visual-Line-Mode.html%5D%20%5Bfn:210:%20http://www.emacswiki.org/emacs/VisualLineMode%5D%20/%20Line%20breaking%20%5Bfn:0945b707:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Auto-Fill.html%5D][nil]]
(global-visual-line-mode 1)
(gcr/diminish 'visual-line-mode)
(gcr/diminish 'global-visual-line-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Modeline%20%5Bfn:57e91167:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Format.html%5D][nil]]
(size-indication-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Modeline%20%5Bfn:57e91167:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Format.html%5D][nil]]
(column-number-mode 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Modeline%20%5Bfn:57e91167:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Format.html%5D][nil]]
(require 'diminish)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Modeline%20%5Bfn:57e91167:%20https://www.gnu.org/software/emacs/manual/html_node/elisp/Mode-Line-Format.html%5D][nil]]
(defadvice kill-line (around kill-line-remove-newline activate)
  (let ((kill-whole-line t))
    ad-do-it))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Mark%20and%20Region%20%5Bfn:d05c6bc3:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Mark.html#Mark%5D][nil]]
(delete-selection-mode 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Minibuffer%20%5Bfn:55105827:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Minibuffer.html%5D][nil]]
(fset 'yes-or-no-p 'y-or-n-p)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Minibuffer%20%5Bfn:55105827:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Minibuffer.html%5D][nil]]
(setq resize-mini-windows +1)
(setq max-mini-window-height 0.33)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Minibuffer%20%5Bfn:55105827:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Minibuffer.html%5D][nil]]
(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Minibuffer%20%5Bfn:55105827:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Minibuffer.html%5D][nil]]
(defun gcr/minibuffer-setup-hook ()
  "Personal setup."
  (local-set-key "ESC y" 'gcr/paste-from-x-clipboard))

(add-hook 'minibuffer-setup-hook 'gcr/minibuffer-setup-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Discoverability][nil]]
(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x r" "C-x 4"))
(guide-key-mode 1)
(gcr/diminish 'guide-key-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Discoverability][nil]]
(require 'move-text)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Code%20folding%20%5Bfn:76ed1f1f:%20http://www.emacswiki.org/emacs/HideShow%5D%20%5Bfn:90bfa78a:%20http://gnufool.blogspot.com/2009/03/make-hideshow-behave-more-like-org-mode.html%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Color%20visualizing%20%5Bfn:adb70244:%20http://elpa.gnu.org/packages/rainbow-mode.html%5D][nil]]
(require 'rainbow-mode)
(condition-case nil
    (gcr/diminish 'rainbow-mode)
  (error nil))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Command%20execution%20helper%20%5Bfn:e2221a4d:%20https://github.com/nonsequitur/smex/%5D][nil]]
(require 'smex)
(smex-initialize)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Expression%20Management%20%5Bfn:60c9aa87:%20https://github.com/Fuco1/smartparens%5D][nil]]
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(gcr/diminish 'smartparens-mode)
(setq sp-show-pair-from-inside nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*File-system/directory%20management%20%5Bfn:b2f9070d:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*File-system/directory%20management%20%5Bfn:b2f9070d:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html%5D][nil]]
(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*File-system/directory%20management%20%5Bfn:b2f9070d:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html%5D][nil]]
(require 'wdired)
(setq wdired-allow-to-change-permissions t)
(setq wdired-allow-to-redirect-links t)
(setq wdired-use-interactive-rename +1)
(setq wdired-confirm-overwrite +1)
(setq wdired-use-dired-vertical-movement 'sometimes)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*File-system/directory%20management%20%5Bfn:b2f9070d:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html%5D][nil]]
(require 'dired-imenu)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Intellisense%20(Auto%20Completion)%20%5Bfn:a5ec7f2e:%20http://cx4a.org/software/auto-complete/%5D][nil]]
(require 'fuzzy)
(require 'auto-complete)
(require 'auto-complete-config)
(setq ac-quick-help-prefer-pos-tip nil)
(ac-config-default)
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")
(gcr/diminish 'auto-complete-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Project%20management%20%5Bfn:7a558748:%20http://batsov.com/projectile/%5D][nil]]
(projectile-global-mode 1)
(gcr/diminish 'projectile-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Rectangle%20/%20Cursors%20%5Bfn:8d7c694f:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Rectangles.html%5D%20%5Bfn:178:%20https://github.com/magnars/multiple-cursors.el%5D][nil]]
(require 'multiple-cursors)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Remote%20file%20access%20%5Bfn:4997f5f8:%20https://www.gnu.org/software/tramp/%5D][nil]]
(setq tramp-default-user "gcr")
(setq tramp-default-method "ssh")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Save%20history%20of%20all%20things%20%5Bfn:43a849e2:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Emacs-Sessions.html%5D%20%5Bfn:ac19c66e:%20http://fly.srk.fer.hr/~hniksic/emacs/savehist.el%5D%20%5Bfn:c39d161c:%20https://stackoverflow.com/questions/1229142/how-can-i-save-my-mini-buffer-history-in-emacs%5D][nil]]
(defconst gcr/savehist-file-store "~/.emacs.d/savehist")
(defun gcr/warn-savehist-file-store ()
  "Warn of savehist misconfiguration."
  (interactive)
  (unless (gcr/file-exists-not-symlink gcr/savehist-file-store)
    (warn "Can't seem to find a savehist store file where it was expected at: %S. Savehist should continue to function normally; but your history may be lost."
          gcr/savehist-file-store)))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Save%20history%20of%20all%20things%20%5Bfn:43a849e2:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Emacs-Sessions.html%5D%20%5Bfn:ac19c66e:%20http://fly.srk.fer.hr/~hniksic/emacs/savehist.el%5D%20%5Bfn:c39d161c:%20https://stackoverflow.com/questions/1229142/how-can-i-save-my-mini-buffer-history-in-emacs%5D][nil]]
(gcr/warn-savehist-file-store)
(savehist-mode +1)
(setq savehist-save-minibuffer-history +1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Searching%20/%20Finding%20%5Bfn:350ccf16:%20http://repo.or.cz/w/emacs.git/blob_plain/HEAD:/lisp/ido.el%5D%20%5Bfn:137:%20https://github.com/lewang/flx%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Selection%20style%20%5Bfn:29f58393:%20https://github.com/magnars/expand-region.el%5D][nil]]
(require 'expand-region)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Spell-checking%20%5Bfn:4fc20d0a:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Spelling.html%5D%20%5Bfn:b6f544fd:%20http://www.emacswiki.org/emacs/InteractiveSpell%5D%20%5Bfn:e620b160:%20http://blog.binchen.org/posts/what-s-the-best-spell-check-set-up-in-emacs.html%5D%20%5Bfn:8ce1e37a:%20http://melpa.milkbox.net/#/ac-ispell%5D][nil]]
(defconst gcr/aspell-dict "~/.aspell.en.pws")
(defun gcr/warn-aspell-dict ()
  "Warn of aspell misconfiguration."
  (interactive)
  (unless (f-exists? gcr/aspell-dict)
    (warn
     "Can't seem to find an aspell dictionary where it was expected at: %S. aspell should continue to function normally; but your personal dictionary will not be used."
     gcr/aspell-dict)))
(gcr/warn-aspell-dict)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Syntax%20checking][nil]]
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(gcr/diminish 'flycheck-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Templating%20%5Bfn:c3b8f741:%20https://github.com/capitaomorte/yasnippet%5D][nil]]
(require 'yasnippet)
(defconst gcr/yas-snippet-dir (concat (cask-dependency-path gcr/cask-bundle 'yasnippet)
                               "/snippets"))
(defun gcr/warn-yas-snippet-dir ()
  "Warn of Yas misconfiguration."
  (interactive)
  (unless (f-directory? gcr/yas-snippet-dir)
    (warn
     "Can't seem to find the Yas snippet dir where it was expected at: %S. Yas should continue function but without its standard snippets loaded."
     gcr/yas-snippet-dir)))
(gcr/warn-yas-snippet-dir)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Templating%20%5Bfn:c3b8f741:%20https://github.com/capitaomorte/yasnippet%5D][nil]]
(yas-load-directory gcr/yas-snippet-dir)
(yas-global-mode 1)
(gcr/diminish 'yas-minor-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Templating%20%5Bfn:c3b8f741:%20https://github.com/capitaomorte/yasnippet%5D][nil]]
(defun gcr/yas-minor-mode-hook ()
  "Personal customizations."
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "s-4") 'yas-expand))

(add-hook 'yas-minor-mode-hook 'gcr/yas-minor-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*White-space%20management%20%5Bfn:1283938f:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Useless-Whitespace.html%5D][nil]]
(require 'whitespace)
(setq whitespace-style '(trailing lines tab-mark))
(setq whitespace-line-column 80)
(global-whitespace-mode 1)
(gcr/diminish 'global-whitespace-mode)
(gcr/diminish 'whitespace-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Configuration%20%5Bfn:d8a83c3d:%20http://eschulte.github.io/emacs-starter-kit/starter-kit-eshell.html%5D%20%5Bfn:78c95d3e:%20https://github.com/bbatsov/emacs-dev-kit/blob/master/eshell-config.el%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Configuration%20%5Bfn:d8a83c3d:%20http://eschulte.github.io/emacs-starter-kit/starter-kit-eshell.html%5D%20%5Bfn:78c95d3e:%20https://github.com/bbatsov/emacs-dev-kit/blob/master/eshell-config.el%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Configuration%20%5Bfn:d8a83c3d:%20http://eschulte.github.io/emacs-starter-kit/starter-kit-eshell.html%5D%20%5Bfn:78c95d3e:%20https://github.com/bbatsov/emacs-dev-kit/blob/master/eshell-config.el%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*!%20All][nil]]
(require 'fancy-narrow)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*!%20All][nil]]
(require 'auto-complete-chunk)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*C%20Language%20Integrated%20Production%20System%20(CLIPS)%20%5Bfn:d383cc00:%20http://clipsrules.sourceforge.net/%5D][nil]]
(require 'clips-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Comint][nil]]
(setq comint-scroll-to-bottom-on-input 'this)
(setq comint-scroll-to-bottom-on-output 'others)
(setq comint-show-maximum-output t)
(setq comint-scroll-show-maximum-output t)
(setq comint-move-point-for-output t)
(setq comint-prompt-read-only t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*CSS][nil]]
(defun gcr/css-modehook ()
  (fci-mode)
  (whitespace-turn-on)
  (rainbow-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook)
  (turn-on-real-auto-save)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'css-mode-hook 'gcr/css-modehook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Emacs%20Lisp][nil]]
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
  (local-set-key (kbd "M-:") 'my-eval-expression))

(require 'lexbind-mode)

(defun gcr/emacs-lisp-mode-hook ()
  (gcr/elisp-mode-local-bindings)
  (lexbind-mode)
  (turn-on-eldoc-mode)
  (gcr/diminish 'eldoc-mode)
  (aggressive-indent-mode))

(add-hook 'emacs-lisp-mode-hook 'gcr/emacs-lisp-mode-hook)

(setq initial-scratch-message nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Graphviz%20%5Bfn:d05878c1:%20http://www.graphviz.org/%5D%20%5Bfn:4c7193c2:%20http://marmalade-repo.org/packages/graphviz-dot-mode%5D%20%5Bfn:04ffff20:%20http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-dot.html%5D][nil]]
(defun gcr/graphviz-dot-mode-hook ()
  "Personal mode bindings for Graphviz mode."
  (fci-mode)
  (rainbow-mode)
  (visual-line-mode)
  (turn-on-real-auto-save))

(add-hook 'graphviz-dot-mode-hook 'gcr/graphviz-dot-mode-hook)

;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Graphviz%20%5Bfn:d05878c1:%20http://www.graphviz.org/%5D%20%5Bfn:4c7193c2:%20http://marmalade-repo.org/packages/graphviz-dot-mode%5D%20%5Bfn:04ffff20:%20http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-dot.html%5D][nil]]
(defconst gcr/graphviz-via-cask
  (concat (cask-dependency-path gcr/cask-bundle 'graphviz-dot-mode)
          "/graphviz-dot-mode.el"))
(defun gcr/warn-graphviz-via-cask ()
  "Warn of graphviz misconfiguration."
  (interactive)
  (unless (gcr/file-exists-not-symlink gcr/graphviz-via-cask)
    (warn "Could not find a Graphviz library. Expected it to be here: %S." gcr/graphviz-via-cask)))
(gcr/warn-graphviz-via-cask)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Graphviz%20%5Bfn:d05878c1:%20http://www.graphviz.org/%5D%20%5Bfn:4c7193c2:%20http://marmalade-repo.org/packages/graphviz-dot-mode%5D%20%5Bfn:04ffff20:%20http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-dot.html%5D][nil]]
(load-file gcr/graphviz-via-cask)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*ibuffer][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IELM%20%5Bfn:2ef924b6:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Lisp-Interaction.html%5D%20%5Bfn:8a08ea9e:%20http://www.emacswiki.org/emacs/InferiorEmacsLispMode%5D%20%5Bfn:5c199b8d:%20http://emacs-fu.blogspot.com/2011/03/ielm-repl-for-emacs.html%5D][nil]]
(defun gcr/ielm-mode-hook ()
  "Personal customizations."
  (interactive)
  (gcr/ielm-auto-complete))

(setq ielm-noisy nil)

(setq ielm-prompt "𝔼LISP> ")

(add-hook 'ielm-mode-hook 'gcr/ielm-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Imenu%20%5Bfn:58de53db:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Imenu.html%5D%20%5Bfn:6024eee8:%20http://www.emacswiki.org/emacs/ImenuMode%5D][nil]]
(require 'imenu-anywhere)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Imenu%20%5Bfn:58de53db:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Imenu.html%5D%20%5Bfn:6024eee8:%20http://www.emacswiki.org/emacs/ImenuMode%5D][nil]]
(setq imenu-sort-function 'imenu--sort-by-name)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Imenu%20%5Bfn:58de53db:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Imenu.html%5D%20%5Bfn:6024eee8:%20http://www.emacswiki.org/emacs/ImenuMode%5D][nil]]
(require 'imenu+)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Imenu%20%5Bfn:58de53db:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Imenu.html%5D%20%5Bfn:6024eee8:%20http://www.emacswiki.org/emacs/ImenuMode%5D][nil]]
(defun gcr/try-to-add-imenu ()
  "Add Imenu to modes that have `font-lock-mode' activated.

Attribution: SRC http://www.emacswiki.org/emacs/ImenuMode"
  (condition-case nil (imenu-add-to-menubar "Imenu") (error nil)))
 (add-hook 'font-lock-mode-hook 'gcr/try-to-add-imenu)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Info%20%5Bfn:c9bf4a1e:%20http://www.emacswiki.org/emacs/InfoMode%5D][nil]]
(ace-link-setup-default)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Javascript%20%5Bfn:152bafed:%20https://en.wikipedia.org/wiki/ECMAScript%5D%20%5Bfn:42427fc4:%20http://www.emacswiki.org/emacs/JavaScriptMode%5D][nil]]
(defun gcr/js-mode-hook ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (setq js-indent-level 2)
  (turn-on-real-auto-save)
  (fci-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook)
  (linum-mode))

(add-hook 'js-mode-hook 'gcr/js-mode-hook)

(defun gcr/warn-autocomplete-js ()
  "Warn of auto-complete JS misconfiguration."
  (interactive)
  (let* ((ac-dir (cask-dependency-path gcr/cask-bundle 'auto-complete))
         (js-mode-f (concat ac-dir "/dict/js-mode")))
    (unless (f-exists? js-mode-f)
      (warn
       "Can't seem to find the auto-complete library where it was expected at: %S. You might fix it with: ln -s %s/dict/javascript-mode %s" ac-dir ac-dir js-mode-f))))
(gcr/warn-autocomplete-js)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Lispy][nil]]
(require 'rainbow-delimiters)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Lispy][nil]]
(defconst lispy-modes
  '(clips-mode-hook
    emacs-lisp-mode-hook
    geiser-repl-mode-hook
    ielm-mode-hook
    lisp-interaction-mode-hook
    scheme-mode-hook))

(dolist (h lispy-modes)
  (add-hook h 'rainbow-mode)
  (add-hook h 'turn-on-smartparens-strict-mode)
  (add-hook h 'gcr/newline)
  (add-hook h 'gcr/disable-tabs))

(dolist (h lispy-modes)
  (when (not (member h '(ielm-mode-hook)))
    (add-hook h 'turn-on-pretty-mode)
    (add-hook h 'turn-on-real-auto-save)
    (add-hook h 'gcr/untabify-buffer-hook)
    (add-hook h 'fci-mode)
    (add-hook h 'hs-minor-mode)
    (add-hook h 'linum-mode)
    (add-hook h (function (lambda ()
                            (add-hook 'local-write-file-hooks
                                      'check-parens))))))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Make%20%5Bfn:da03efe9:%20https://www.gnu.org/software/make/manual/make.html%5D%20%5Bfn:202:%20http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-makefile.html%5D%20%5Bfn:203:%20http://www.emacswiki.org/emacs/MakefileMode%5D][nil]]
(defun gcr/make-modehook ()
  (fci-mode)
  (whitespace-turn-on)
  (rainbow-mode)
  (turn-on-real-auto-save)
  (visual-line-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'makefile-mode-hook 'gcr/make-modehook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Markdown%20%5Bfn:e43df485:%20http://jblevins.org/projects/markdown-mode/%5D][nil]]
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" +1)

(add-to-list 'auto-mode-alist '("\.markdown'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\.md'" . gfm-mode))

(defun gcr/markdown-mode-hook ()
  "Markdown mode customizations."
  (interactive)
  (fci-mode)
  (rainbow-mode)
  (visual-line-mode)
  (turn-on-real-auto-save)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'markdown-mode-hook 'gcr/markdown-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Occur][nil]]
(defun gcr/occur-mode-hook ()
  "Personal customizations."
  (interactive)
  (turn-on-stripe-buffer-mode)
  (stripe-listify-buffer))

(add-hook 'occur-mode-hook 'gcr/occur-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Polymode%20%5Bfn:918c4a07:%20https://github.com/vitoshka/polymode%5D][nil]]
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Polymode%20%5Bfn:918c4a07:%20https://github.com/vitoshka/polymode%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Ruby%20%5Bfn:e9aab149:%20https://www.ruby-lang.org/en/%5D][nil]]
(defun gcr/ruby-mode-hook ()
  (fci-mode)
  (rainbow-mode)
  (gcr/untabify-buffer-hook)
  (turn-on-real-auto-save)
  (visual-line-mode)
  (fci-mode)
  (turn-on-smartparens-strict-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'ruby-mode-hook 'gcr/ruby-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Scheme%20%5Bfn:5c0b0c3e:%20http://library.readscheme.org/index.html%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Sh(hell)][nil]]
(defun gcr/sh-mode-hook ()
  "Personal customizations."
  (interactive)
  (rainbow-mode)
  (turn-on-smartparens-strict-mode)
  (turn-on-pretty-mode)
  (turn-on-real-auto-save)
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode)
  (whitespace-turn-on)
  (visual-line-mode)
  (hs-minor-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'sh-mode-hook 'gcr/sh-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Shell][nil]]
(defun gcr/shell-mode-hook ()
  "Personalizations."
  (interactive)
  (rainbow-mode)
  (turn-on-smartparens-strict-mode)
  (turn-on-pretty-mode)
  (gcr/disable-tabs)
  (fci-mode)
  (whitespace-turn-on)
  (visual-line-mode)
  (hs-minor-mode)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'shell-mode-hook 'gcr/shell-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Standard%20ML%20(SML)%20%5Bfn:eb5c01ac:%20https://en.wikipedia.org/wiki/Standard_ML%5D][nil]]
(require 'sml-mode)
(defun gcr/sml-mode-hook ()
  "Personal settings."
  (interactive)
  (turn-on-pretty-mode)
  (rainbow-mode)
  (turn-on-smartparens-strict-mode)
  (local-set-key (kbd "RET") 'newline-and-indent)
  (turn-on-real-auto-save)
  (gcr/untabify-buffer-hook)
  (gcr/disable-tabs)
  (fci-mode)
  (hs-minor-mode)
  (visual-line-mode))
(add-hook 'sml-mode-hook 'gcr/sml-mode-hook)
(setq sml-indent-level 2)
(setq sml-rightalign-and t)
(setq sml-electric-pipe-mode t)
(setq sml-program-name "sml")
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Standard%20ML%20(SML)%20%5Bfn:eb5c01ac:%20https://en.wikipedia.org/wiki/Standard_ML%5D][nil]]
(setq sml-font-lock-symbols nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Standard%20ML%20(SML)%20%5Bfn:eb5c01ac:%20https://en.wikipedia.org/wiki/Standard_ML%5D][nil]]
(defadvice sml-prog-proc-load-file (before beforesml-prog-proc-load-file activate)
  (gcr/save-all-file-buffers))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Structured%20Query%20Language%20(SQL)%20%5Bfn:a018350e:%20https://en.wikipedia.org/wiki/SQL%5D][nil]]
(require 'sqlup-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Table][nil]]
(require 'ctable)

(defun gcr/ctbl:table-mode-hook ()
  "Personal customization"
  (interactive))

(add-hook 'ctbl:table-mode-hook 'gcr/ctbl:table-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Tag][nil]]
(setq
 gcr/tags/milwaukee-data-science
 '(
   "Algorithmic Trading"
   "Big Data"
   "Business Intelligence"
   "Data Analysis and Modeling"
   "Data Mining"
   "Data Science"
   "Data Visualization"
   "Financial Engineering"
   "Machine Learning"
   "Mathematical Modelling"
   "Predictive Analytics"
   "Quantitative Analysis"
   "Quantitative Finance"
   "Risk Management"
   "Statistical Computing"
   ))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*TeX%20%5Bfn:5bb50e18:%20https://en.wikipedia.org/wiki/TeX%5D%20/%20LaTeX%20%5Bfn:a13f106f:%20%5B%5Bhttps://en.wikipedia.org/wiki/LaTeX%5D%5D%5D%20/%20ConTeXt%20%5Bfn:8a78f8ab:%20https://en.wikipedia.org/wiki/ConTeXt%5D][nil]]
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*TeX%20%5Bfn:5bb50e18:%20https://en.wikipedia.org/wiki/TeX%5D%20/%20LaTeX%20%5Bfn:a13f106f:%20%5B%5Bhttps://en.wikipedia.org/wiki/LaTeX%5D%5D%5D%20/%20ConTeXt%20%5Bfn:8a78f8ab:%20https://en.wikipedia.org/wiki/ConTeXt%5D][nil]]
(defun gcr/TeX-mode-hook ()
  "Settings applicable to every AUCTeX supported mode."
  (interactive)
  (turn-on-smartparens-strict-mode)
  (turn-on-real-auto-save)
  (gcr/disable-tabs)
  (fci-mode))

(add-hook 'TeX-mode-hook 'gcr/TeX-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*TeX%20%5Bfn:5bb50e18:%20https://en.wikipedia.org/wiki/TeX%5D%20/%20LaTeX%20%5Bfn:a13f106f:%20%5B%5Bhttps://en.wikipedia.org/wiki/LaTeX%5D%5D%5D%20/%20ConTeXt%20%5Bfn:8a78f8ab:%20https://en.wikipedia.org/wiki/ConTeXt%5D][nil]]
(setq TeX-parse-self t) ;
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*TeX%20%5Bfn:5bb50e18:%20https://en.wikipedia.org/wiki/TeX%5D%20/%20LaTeX%20%5Bfn:a13f106f:%20%5B%5Bhttps://en.wikipedia.org/wiki/LaTeX%5D%5D%5D%20/%20ConTeXt%20%5Bfn:8a78f8ab:%20https://en.wikipedia.org/wiki/ConTeXt%5D][nil]]
(setq TeX-auto-save t) ;
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*TeX%20%5Bfn:5bb50e18:%20https://en.wikipedia.org/wiki/TeX%5D%20/%20LaTeX%20%5Bfn:a13f106f:%20%5B%5Bhttps://en.wikipedia.org/wiki/LaTeX%5D%5D%5D%20/%20ConTeXt%20%5Bfn:8a78f8ab:%20https://en.wikipedia.org/wiki/ConTeXt%5D][nil]]
(setq TeX-auto-untabify t)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*TeX%20%5Bfn:5bb50e18:%20https://en.wikipedia.org/wiki/TeX%5D%20/%20LaTeX%20%5Bfn:a13f106f:%20%5B%5Bhttps://en.wikipedia.org/wiki/LaTeX%5D%5D%5D%20/%20ConTeXt%20%5Bfn:8a78f8ab:%20https://en.wikipedia.org/wiki/ConTeXt%5D][nil]]
(defadvice TeX-command-master (before before-TeX-command-master activate)
  (gcr/save-all-file-buffers))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*TeX%20%5Bfn:5bb50e18:%20https://en.wikipedia.org/wiki/TeX%5D%20/%20LaTeX%20%5Bfn:a13f106f:%20%5B%5Bhttps://en.wikipedia.org/wiki/LaTeX%5D%5D%5D%20/%20ConTeXt%20%5Bfn:8a78f8ab:%20https://en.wikipedia.org/wiki/ConTeXt%5D][nil]]
(setq TeX-PDF-mode +1)
(setq TeX-DVI-via-PDFTeX +1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Text][nil]]
(defun gcr/text-mode-hook ()
  (rainbow-mode)
  (turn-on-real-auto-save)
  (fci-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook))

(add-hook 'text-mode-hook 'gcr/text-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Vagrant%20%5Bfn:a83cf3b8:%20http://www.vagrantup.com/%5D][nil]]
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Vagrant%20%5Bfn:a83cf3b8:%20http://www.vagrantup.com/%5D][nil]]
(eval-after-load 'tramp
  '(vagrant-tramp-enable))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Version%20control%20/%20Git%20%5Bfn:17977be8:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Version-Control.html%5D%20%5Bfn:b573f4e5:%20https://github.com/magit/magit%5D][nil]]
(defadvice vc-next-action (before save-before-vc first activate)
  "Save all buffers before any VC next-action function calls."
  (gcr/save-all-file-buffers))

(defadvice vc-diff (before save-before-vc-diff first activate)
  "Save all buffers before vc-diff calls."
  (gcr/save-all-file-buffers))

(defadvice vc-revert (before save-before-vc-revert first activate)
  "Save all buffers before vc-revert calls."
  (gcr/save-all-file-buffers))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Version%20control%20/%20Git%20%5Bfn:17977be8:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Version-Control.html%5D%20%5Bfn:b573f4e5:%20https://github.com/magit/magit%5D][nil]]
(global-diff-hl-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Version%20control%20/%20Git%20%5Bfn:17977be8:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Version-Control.html%5D%20%5Bfn:b573f4e5:%20https://github.com/magit/magit%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Version%20control%20/%20Git%20%5Bfn:17977be8:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Version-Control.html%5D%20%5Bfn:b573f4e5:%20https://github.com/magit/magit%5D][nil]]
(defun gcr/git-commit-mode-hook ()
  "Personal customizations."
  (local-set-key (kbd "C-;") 'git-commit-commit))

(add-hook 'git-commit-mode-hook 'gcr/git-commit-mode-hook)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Version%20control%20/%20Git%20%5Bfn:17977be8:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Version-Control.html%5D%20%5Bfn:b573f4e5:%20https://github.com/magit/magit%5D][nil]]
(add-to-list 'auto-mode-alist '(".gitignore$" . text-mode))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Version%20control%20/%20Git%20%5Bfn:17977be8:%20https://www.gnu.org/software/emacs/manual/html_node/emacs/Version-Control.html%5D%20%5Bfn:b573f4e5:%20https://github.com/magit/magit%5D][nil]]
(require 'git-timemachine)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Web%20%5Bfn:857fba7f:%20https://en.wikipedia.org/wiki/HTML%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Web%20browsing][nil]]
(setq browse-url-browser-function 'browse-url-generic)
(gcr/on-gnu/linux (setq browse-url-generic-program "chromium-browser"))
(gcr/on-osx
 (require 'osx-browse)
 (osx-browse-mode 1))
(gcr/on-windows (setq browse-url-generic-program "chrome"))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Web%20browsing][nil]]
(require 'google-this)
(google-this-mode 1)
(gcr/diminish 'google-this-mode)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc)

(setq gcr/erc-after-connect-hook-BODY nil)

(defun gcr/erc-after-connect-hook ()
  (gcr/erc-after-connect-hook-BODY))

(add-hook 'erc-after-connect 'gcr/erc-after-connect-hook)

(defconst gcr/irc-freenode-credentials "~/.irc.el")

(defun gcr/warn-irc-freenode-credentials ()
  "Warn of misconfigured Freenode credentials."
  (interactive)
  (unless (f-exists? gcr/irc-freenode-credentials)
    (warn "Can't seem to find an ERC credential file at: %S. ERC should continue to work; but you will be unable to log in to IRC automatically." gcr/irc-freenode-credentials)))
(gcr/warn-irc-freenode-credentials)

(defun gcr/irc ()
  "Connect to my preferred IRC network."
  (interactive)
  (gcr/warn-irc-freenode-credentials)
  (with-temp-buffer
    (insert-file-contents gcr/irc-freenode-credentials)
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
        (setq gcr/erc-after-connect-hook-BODY gcr/erc-after-connect-hook-IMPL)))))

(define-key erc-mode-map (kbd "C-c C-RET") 'erc-send-current-line)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-autoaway)
(add-to-list 'erc-modules 'autoaway)
(setq erc-autoaway-idle-seconds 600)
(setq erc-autoaway-message "autoaway just demanded that I step out now")
(setq erc-auto-set-away +1)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-join)
(erc-autojoin-mode +1)
(setq erc-autojoin-channels-alist
      '((".*freenode.net" "#emacs" "#org-mode" "#scheme" "#r")))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-button)
(erc-button-mode +1)
(setq erc-button-wrap-long-urls  nil
      erc-button-buttonize-nicks nil)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-fill)
(erc-fill-mode +1)
(setq erc-fill-column 72)
(setq erc-fill-function 'erc-fill-static)
(setq erc-fill-static-center 0)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(erc-irccontrols-enable)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(setq erc-current-nick-highlight-type 'keyword)
(setq erc-pals '("leppie"))
(setq erc-fools '("lamer" "dude"))
(remove-hook 'erc-text-matched-hook 'erc-hide-fools)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-netsplit)
(erc-netsplit-mode 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(add-to-list 'erc-modules 'notify)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(add-to-list 'erc-modules 'page)
(require 'erc-page)
(erc-page-mode 1)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-ring)
(erc-ring-mode 1)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(add-to-list 'erc-modules 'scrolltobottom)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(add-to-list 'erc-modules 'stamp)
(require 'erc-stamp)
(erc-stamp-mode 1)
(setq erc-insert-timestamp-function      'erc-insert-timestamp-left
      erc-timestamp-only-if-changed-flag t
      erc-timestamp-format               "[%H:%M] "
      erc-insert-away-timestamp-function 'erc-insert-timestamp-left
      erc-away-timestamp-format          "<%H:%M> ")
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-tweet)
(add-to-list 'erc-modules 'tweet)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-image)
(add-to-list 'erc-modules 'image)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-youtube)
(add-to-list 'erc-modules 'youtube)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-hl-nicks)
(add-to-list 'erc-modules 'hl-nicks)
(erc-update-modules)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*IRC%20%5Bfn:2a4e660d:%20http://mwolson.org/static/doc/erc.html%5D%20%5Bfn:2477b030:%20http://emacs-fu.blogspot.com/2009/06/erc-emacs-irc-client.html%5D%20%5Bfn:7011e6f3:%20http://edward.oconnor.cx/config/.ercrc.el%5D%20%5Bfn:c98e3673:%20http://www.shakthimaan.com/posts/2011/08/13/gnu-emacs-erc/news.html%5D%20%5Bfn:0a57e0d0:%20https://gitcafe.com/Darksair/dotfiles-mac/blob/master/.emacs-erc.el%5D][nil]]
(require 'erc-dcc)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Generally%20nice][nil]]
(eval-after-load "dash" '(dash-enable-font-lock))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Generally%20nice][nil]]
(setq a-tmp-file (make-temp-file "~/"))
(setq a-tmp-link (concat a-tmp-file "-LINK"))
(make-symbolic-link a-tmp-file a-tmp-link 'overwrite)

(print (setq no-file "/infinity"))
(print (f-exists? no-file))

(print a-tmp-file)
(print (f-exists? a-tmp-file))
(print (f-file? a-tmp-file))
(print (f-symlink? a-tmp-file))

(print a-tmp-link)
(print (f-exists? a-tmp-link))
(print (f-file? a-tmp-link))
(print (f-symlink? a-tmp-link))
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Generally%20nice][nil]]
(require 'xml-rpc)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Generally%20nice][nil]]
(require 'metaweblog)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Generally%20nice][nil]]
(require 'uuid)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Characters%20/%20Unicode][nil]]
(require 'figlet)
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Characters%20/%20Unicode][nil]]
(setq figlet-font-directory "/usr/local/bin/")
;; nil ends here

;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Custom%20variables][nil]]
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
;; nil ends here
;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Font%20block][nil]]
(gcr/on-gui
  ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Font%20(Appearance)][nil]]
  (defconst gcr/font-base "DejaVu Sans Mono" "The preferred font name.")
  ;; nil ends here
  ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Font%20(Appearance)][nil]]
  (require 'unicode-fonts)
  (unicode-fonts-setup)
  ;; nil ends here
  ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Font%20(Appearance)][nil]]
  (defvar gcr/font-size 10 "The preferred font size.")
  (gcr/on-osx (setq gcr/font-size 17))
  ;; nil ends here
  ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Font%20(Appearance)][nil]]
  (setq solarized-distinct-fringe-background +1)
  (setq solarized-high-contrast-mode-line +1)
  (setq solarized-use-less-bold +1)
  (setq solarized-use-more-italic nil)
  (setq solarized-emphasize-indicators nil)
  (load-theme 'solarized-dark)
  ;; nil ends here
  ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Font%20(Appearance)][nil]]
  (require 'pretty-mode)
  ;; nil ends here
  ;; [[file:~/git/bitbucket-grettke/home/TC3F.org::*Font%20(Appearance)][nil]]
  (setq make-pointer-invisible +1)
  ;; nil ends here
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
;; nil ends here

;; Fully\ Loaded\ System:1 ends here
