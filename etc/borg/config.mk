# Override `EMACS_Q_ARG' so it doesn't include -Q and thus loads site-lisp
EMACS_Q_ARG ?= -q


# Load borg's init.el also when tangling init.el
EMACS_EXTRA := -l etc/borg/init.el
