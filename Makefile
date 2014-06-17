INIT=.emacs.el

$(INIT): TC3F.org
	caffeinate -s time emacs --batch --no-init-file --load .org-mode.emacs.el --find-file TC3F.org --funcall org-babel-tangle --kill

TC3F.txt: $(INIT)
	caffeinate -s time emacs --batch --no-init-file --load .org-mode.emacs.el --find-file TC3F.org --funcall org-ascii-export-to-ascii --kill

TC3F.html: $(INIT)
	caffeinate -s time emacs --batch --no-init-file --load .org-mode.emacs.el --find-file TC3F.org --funcall org-html-export-to-html --kill

TC3F.pdf: $(INIT)
	caffeinate -s time emacs --batch --no-init-file --load .org-mode.emacs.el --find-file TC3F.org --funcall org-latex-export-to-pdf --kill

publish.txt: $(INIT)
	caffeinate -s time emacs --batch --no-init-file --load .org-mode.emacs.el --find-file publish.org --funcall org-ascii-export-to-ascii --kill

all: publish.txt TC3F.txt TC3F.html TC3F.pdf

clean:
	rm $(INIT)
	rm TC3F.txt
	rm TC3F.html
	rm TC3F.pdf
