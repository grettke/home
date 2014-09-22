
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
(setq-default case-fold-search +1)
(setq gc-cons-threshold (* 128 1024 1024))
(setq max-specpdl-size 1500)
(setq debug-on-error nil)
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
 '(:name swimmers
          :type http
          :url "http://www.cb1.com/~john/computing/emacs/lisp/games/swimmers.el"
          :features swimmers
          :autoloads nil
          :website "http://www.cb1.com/~john/"
          :description "Draw a swimming-pool screensaver"))
(add-to-list 'gcr/el-get-packages 'swimmers)
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
         (not (equal new-command 'gcr/move-line-up))
         )
      (warn "Just stomped the global-map binding for %S, replaced %S with %S"
            key old-command new-command))))
(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.1)
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
(key-chord-define-global "4 " (lambda () (interactive) (insert "    ")))
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
(key-chord-define-global "m," 'ace-jump-mode-pop-mark)
(key-chord-define-global "fg" 'goto-line)
(key-chord-define-global "vb" 'pop-to-mark-command)
(require 'linum-relative)
(key-chord-define-global "dk" 'linum-relative-toggle)
(key-chord-define-global "nm" 'ace-window)
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
(global-set-key (kbd "s-l i") 'gcr/move-line-up)
(global-set-key (kbd "s-l k") 'gcr/move-line-down)
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
(global-set-key (kbd "s-u dse") (lambda () (interactive) (insert "𝔼")))
(global-set-key (kbd "s-u dsr") (lambda () (interactive) (insert "ℝ")))
(global-set-key (kbd "M-7") 'gcr/insert-datestamp)
(global-set-key (kbd "s-7") 'gcr/insert-timestamp*)
(global-set-key (kbd "C-7") 'gcr/insert-timestamp)
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
(global-set-key (kbd "<f7>") 'list-world-time)
(global-set-key (kbd "<f8>") 'magit-status)
(global-set-key (kbd "<f9>") 'gcr/util-cycle)
(global-set-key (kbd "<f11>") 'other-window)
(global-set-key (kbd "<f12>") 'neotree-toggle)
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
(setq org-edit-src-code nil)
(setq org-list-allow-alphabetical +1)
(require 'org)
(require 'ox-beamer)
(require 'ox-md)
(require 'htmlize)
(setq htmlize-output-type 'inline-css)
(setq org-html-htmlize-output-type htmlize-output-type)
(let ((pkg 'org-show))
  (if (not (el-get-package-is-installed pkg))
      (warn "You wanted %S to be installed, but it isnt. Fix this." pkg)
    (let ((fil (concat (el-get-package-directory pkg) "org-show.el")))
      (if (not (f-exists? fil))
          (warn "You wanted %S to exist, but it doesn't. Fix this." fil)
        (load fil)))))
(defconst gcr/org-version "8.2.7c")

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
  "Personal settings for the `org-babel-after-execute-hook'."
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
(mapc (lambda (asc)
        (let ((org-sce-dc (downcase (nth 1 asc))))
          (setf (nth 1 asc) org-sce-dc)))
      org-structure-template-alist)
(add-to-list
 'org-structure-template-alist
 '("r" "#+begin_src R\n?\n#+end_src" "<src lang=\"R\"></src>"))
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
(gcr/set-org-system-header-arg :comments "no")
(gcr/set-org-system-header-arg :results "output")
(gcr/set-org-system-header-arg :exports "both")
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
  (local-set-key (kbd "s-a i") 'org-babel-insert-header-arg)
  (local-set-key (kbd "s-k") 'org-babel-previous-src-block)
  (local-set-key (kbd "s-l") 'org-babel-next-src-block)
  (local-set-key (kbd "s-;") 'org-babel-view-src-block-info)
  (local-set-key (kbd "s-b s") 'org-babel-switch-to-session)
  (local-set-key (kbd "s-b c") 'org-babel-switch-to-session-with-code)
  (local-set-key (kbd "s-x") 'org-babel-do-key-sequence-in-edit-buffer)
  (local-set-key (kbd "s-t") 'org-babel-tangle)
  (local-set-key (kbd "s-w") 'org-babel-execute-buffer)
  (local-set-key (kbd "s-e") 'org-babel-execute-maybe)
  (local-set-key (kbd "s-i d") 'org-display-inline-images)
  (local-set-key (kbd "s-i r") 'org-remove-inline-images)
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
(defun gcr/org-src-mode-hook ()
  (local-set-key (kbd "C-2") 'org-edit-src-exit)
  (visual-line-mode))

(add-hook 'org-src-mode-hook 'gcr/org-src-mode-hook)
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
(menu-bar-mode +1)
(setq-default fill-column 80)
(blink-cursor-mode 0)
(gcr/on-gui
 (setq-default cursor-type 'box))
(setq x-stretch-cursor 1)
(global-linum-mode -1)
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
 (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
 (setq mouse-wheel-progressive-speed nil)
 (setq mouse-wheel-follow-mouse +1)
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
 (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
 (gcr/on-windows
  (set-clipboard-coding-system 'utf-16le-dos)))

(require 'undo-tree)
(global-undo-tree-mode 1)
(gcr/diminish 'undo-tree-mode)
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
(global-set-key [?\C-x ?t] 'anchored-transpose)
(autoload 'anchored-transpose "anchored-transpose" nil t)
(require 'ibuffer)
(require 'smooth-scrolling)
(linum-relative-toggle)
(require 'nyan-mode)
(require 'highlight-tail)
(require 'zone)
(require 'stripe-buffer)
(require 'wrap-region)
(gcr/diminish 'wrap-region-mode)

(wrap-region-add-wrapper "*" "*" nil 'org-mode) ;; bold
(wrap-region-add-wrapper "/" "/" nil 'org-mode) ;; italic
(wrap-region-add-wrapper "_" "_" nil 'org-mode) ;; underlined
(wrap-region-add-wrapper "=" "=" nil 'org-mode) ;; verbatim
(wrap-region-add-wrapper "~" "~" nil 'org-mode) ;; code
(wrap-region-add-wrapper "+" "+" nil 'org-mode) ;; strike-through
;; (wrap-region-add-wrapper "" "w" 'org-mode) ;; noweb blocks
(global-visual-line-mode 1)
(gcr/diminish 'visual-line-mode)
(gcr/diminish 'global-visual-line-mode)
(size-indication-mode)
(column-number-mode 1)
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
(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x r" "C-x 4"))
(guide-key-mode 1)
(gcr/diminish 'guide-key-mode)
(require 'move-text)
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
(require 'rainbow-mode)
(condition-case nil
    (gcr/diminish 'rainbow-mode)
  (error nil))
(require 'smex)
(smex-initialize)
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(gcr/diminish 'smartparens-mode)
(setq sp-show-pair-from-inside nil)
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
(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))
(require 'wdired)
(setq wdired-allow-to-change-permissions t)
(setq wdired-allow-to-redirect-links t)
(setq wdired-use-interactive-rename +1)
(setq wdired-confirm-overwrite +1)
(setq wdired-use-dired-vertical-movement 'sometimes)
(require 'dired-imenu)
(require 'fuzzy)
(require 'auto-complete)
(require 'auto-complete-config)
(setq ac-quick-help-prefer-pos-tip nil)
(ac-config-default)
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")
(gcr/diminish 'auto-complete-mode)
(projectile-global-mode 1)
(gcr/diminish 'projectile-mode)
(require 'multiple-cursors)
(setq tramp-default-user "gcr")
(setq tramp-default-method "ssh")
(defconst gcr/savehist-file-store "~/.emacs.d/savehist")
(defun gcr/warn-savehist-file-store ()
  "Warn of savehist misconfiguration."
  (interactive)
  (unless (gcr/file-exists-not-symlink gcr/savehist-file-store)
    (warn "Can't seem to find a savehist store file where it was expected at: %S. Savehist should continue to function normally; but your history may be lost."
          gcr/savehist-file-store)))
(gcr/warn-savehist-file-store)
(savehist-mode +1)
(setq savehist-save-minibuffer-history +1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
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
(require 'expand-region)
(defconst gcr/aspell-dict "~/.aspell.en.pws")
(defun gcr/warn-aspell-dict ()
  "Warn of aspell misconfiguration."
  (interactive)
  (unless (f-exists? gcr/aspell-dict)
    (warn
     "Can't seem to find an aspell dictionary where it was expected at: %S. aspell should continue to function normally; but your personal dictionary will not be used."
     gcr/aspell-dict)))
(gcr/warn-aspell-dict)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(gcr/diminish 'flycheck-mode)
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
(yas-load-directory gcr/yas-snippet-dir)
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
(require 'fancy-narrow)
(require 'auto-complete-chunk)
(require 'clips-mode)
(setq comint-scroll-to-bottom-on-input 'this)
(setq comint-scroll-to-bottom-on-output 'others)
(setq comint-show-maximum-output t)
(setq comint-scroll-show-maximum-output t)
(setq comint-move-point-for-output t)
(setq comint-prompt-read-only t)
(defun gcr/css-modehook ()
  (fci-mode)
  (whitespace-turn-on)
  (rainbow-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook)
  (turn-on-real-auto-save)
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
  (local-set-key (kbd "M-:") 'my-eval-expression))

(require 'lexbind-mode)

(defun gcr/emacs-lisp-mode-hook ()
  (gcr/elisp-mode-local-bindings)
  (lexbind-mode)
  (turn-on-eldoc-mode)
  (gcr/diminish 'eldoc-mode))

(add-hook 'emacs-lisp-mode-hook 'gcr/emacs-lisp-mode-hook)

(setq initial-scratch-message nil)
(require 'ess-site)
(defconst gcr/ess-version "14.08")

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
(setq inferior-ess-same-window t)
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
(defun gcr/ess-mode-hook ()
  (local-set-key (kbd "s-e") 'ess-switch-to-end-of-ESS)
  (local-set-key (kbd "s-x") 'r-autoyas-expand)
  (local-set-key (kbd "s-p") 'ess-R-object-popup)
  (local-set-key (kbd "s-v o") 'ess-describe-object-at-point)
  (local-set-key (kbd "s-v d") 'ess-rdired)
  (local-set-key (kbd "s-v cc") 'ess-R-dv-ctable)
  (local-set-key (kbd "s-v cp") 'ess-R-dv-pprint)
  (local-set-key (kbd "C-,") (lambda () (interactive) (insert " <<- ")))
  (local-set-key (kbd "C-.") (lambda () (interactive) (insert " ->> ")))
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
(defun gcr/graphviz-dot-mode-hook ()
  "Personal mode bindings for Graphviz mode."
  (fci-mode)
  (rainbow-mode)
  (visual-line-mode)
  (turn-on-real-auto-save))

(add-hook 'graphviz-dot-mode-hook 'gcr/graphviz-dot-mode-hook)

(defconst gcr/graphviz-via-cask
  (concat (cask-dependency-path gcr/cask-bundle 'graphviz-dot-mode)
          "/graphviz-dot-mode.el"))
(defun gcr/warn-graphviz-via-cask ()
  "Warn of graphviz misconfiguration."
  (interactive)
  (unless (gcr/file-exists-not-symlink gcr/graphviz-via-cask)
    (warn "Could not find a Graphviz library. Expected it to be here: %S." gcr/graphviz-via-cask)))
(gcr/warn-graphviz-via-cask)
(load-file gcr/graphviz-via-cask)
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
(require 'rainbow-delimiters)
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
(defun gcr/make-modehook ()
  (fci-mode)
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

(defun gcr/markdown-mode-hook ()
  "Markdown mode customizations."
  (interactive))

(add-hook 'markdown-mode-hook 'gcr/markdown-mode-hook)
(defun gcr/occur-mode-hook ()
  "Personal customizations."
  (interactive)
  (turn-on-stripe-buffer-mode)
  (stripe-listify-buffer))

(add-hook 'occur-mode-hook 'gcr/occur-mode-hook)
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
(setq sml-font-lock-symbols nil)
(defadvice sml-prog-proc-load-file (before beforesml-prog-proc-load-file activate)
  (gcr/save-all-file-buffers))
(require 'sqlup-mode)
(require 'ctable)

(defun gcr/ctbl:table-mode-hook ()
  "Personal customization"
  (interactive))

(add-hook 'ctbl:table-mode-hook 'gcr/ctbl:table-mode-hook)
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
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(defun gcr/TeX-mode-hook ()
  "Settings applicable to every AUCTeX supported mode."
  (interactive)
  (turn-on-smartparens-strict-mode)
  (turn-on-real-auto-save)
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
(defun gcr/text-mode-hook ()
  (rainbow-mode)
  (turn-on-real-auto-save)
  (fci-mode)
  (visual-line-mode)
  (gcr/untabify-buffer-hook))

(add-hook 'text-mode-hook 'gcr/text-mode-hook)
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
(eval-after-load 'tramp
  '(vagrant-tramp-enable))
(defadvice vc-next-action (before save-before-vc first activate)
  "Save all buffers before any VC next-action function calls."
  (gcr/save-all-file-buffers))

(defadvice vc-diff (before save-before-vc-diff first activate)
  "Save all buffers before vc-diff calls."
  (gcr/save-all-file-buffers))

(defadvice vc-revert (before save-before-vc-revert first activate)
  "Save all buffers before vc-revert calls."
  (gcr/save-all-file-buffers))
(global-diff-hl-mode)
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
(add-to-list 'auto-mode-alist '(".gitignore$" . text-mode))
(require 'git-timemachine)
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
 (require 'osx-browse)
 (osx-browse-mode 1))
(gcr/on-windows (setq browse-url-generic-program "chrome"))
(require 'google-this)
(google-this-mode 1)
(gcr/diminish 'google-this-mode)
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
(require 'erc-dcc)
(eval-after-load "dash" '(dash-enable-font-lock))
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
(require 'xml-rpc)
(require 'metaweblog)
(require 'uuid)
(require 'figlet)
(add-to-list 'figlet-fonts-dir-candidates "/usr/local/bin/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(display-time-world-list (quote (("America/Chicago" "Chicago") ("Asia/Kolkata" "Kolkata") ("Asia/Kuala_Lumpur" "Kuala Lumpur"))))
 '(linum-format "%5d")
 '(osx-browse-guess-keystrokes (quote ("s-b k")))
 '(osx-browse-url-keystrokes (quote ("s-b u"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(gcr/on-gui
  (defconst gcr/font-base "DejaVu Sans Mono" "The preferred font name.")
  (require 'unicode-fonts)
  (unicode-fonts-setup)
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
