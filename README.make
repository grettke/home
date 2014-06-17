README.md: README.org
	caffeinate -s time emacs --batch --no-init-file --load ~/.org-mode.emacs.el --find-file README.org --funcall org-md-export-to-markdown --kill
