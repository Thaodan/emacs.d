;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((magit-mode . ((magit-todos-exclude-globs . (".git/" "./etc/org/templates/"))))
 ;; We don't want ID's for the org files of this repository
 ;; i.e. when linking to this file from another file outside of the repository.
 (org-mode . ((org-id-link-to-org-use-id . nil))))
