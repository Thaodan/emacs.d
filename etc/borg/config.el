;; -*- lexical-binding: t; -*-

;; Override `borg-emacs-arguments' so it doesn't include -Q and thus loads site-lisp
(setq borg-emacs-arguments '("--batch"))

;; Prefer newer to avoid Emacs loading older byte-compiled files and accidentally
;; old code to end up in depending files that are about to be byte-compiled.
(setopt load-prefer-newer t)
