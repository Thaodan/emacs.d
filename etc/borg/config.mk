# Override `EMACS_ARGUMENTS' so it doesn't include -Q and thus loads site-lisp
EMACS_ARGUMENTS := --batch

# Load borg's init.el also when tangling init.el
EMACS_EXTRA := -l etc/borg/init.el
