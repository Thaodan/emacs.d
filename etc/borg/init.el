;;  -*- lexical-binding: t -*-

(setopt borg-compile-function #'borg-byte+native-compile)

(setopt native-comp-compiler-options '("-flto" "-O2"))

;; Load some Emacs packages installed by the system package manager
(add-to-list 'load-path "/usr/share/emacs/site-lisp" )
(add-to-list 'load-path "/usr/lib/emacs/site-lisp" )

;; Use eval after load so the function is defined after org is loaded
;; and thus is not loaded before borg appends the external org-mode.
(eval-after-load "org"
  '(progn
     ;;  Based upon doom-emacs org-tangle but improved to not need a temporary file
     (require 'ox)
     (defun thao/org-babel-tangle-expand-include-file (file &optional target-file lang-re)
       (:documentation (documentation #'org-babel-tangle-file))
       (interactive "fFile to tangle: \nP")
       (let* ((org-export-show-temporary-export-buffer nil)
              (file-default-directory (directory-file-name (file-name-parent-directory (expand-file-name file))))
	          (org-babel-pre-tangle-hook) ;; We don't want org-babel to try to safe the file after we expanded it inside the temp buffer
              (target-file (or target-file (expand-file-name (concat (file-name-base file) ".el") file-default-directory))))
         (with-temp-buffer
           (insert-file-contents file)
           (org-mode)
           (set-visited-file-name file) ;; org-babel-tangle expects a file to refer
           ;; Tangling doesn't expand #+INCLUDE directives, so we do it
           ;; ourselves, since includes are so useful for literate configs!
           (org-export-expand-include-keyword)
           (org-babel-tangle nil target-file lang-re)
           (set-buffer-modified-p nil) ;; Don't ask to safe the buffer before killing in interactive use
           (kill-buffer (buffer-name)))))

     (advice-add #'org-babel-tangle-file :override #'thao/org-babel-tangle-expand-include-file)))
