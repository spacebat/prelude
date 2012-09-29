(defun autofeaturep (feature)
  "For a feature symbol 'foo, return a result equivalent to:
(or (featurep 'foo-autoloads) (featurep 'foo))
Does not support subfeatures."
  (catch 'result
    (let ((feature-name (symbol-name feature)))
      (unless (string-match "-autoloads$" feature-name)
        (let ((feature-autoloads (intern-soft (concat feature-name "-autoloads"))))
          (when (and feature-autoloads (featurep feature-autoloads))
            (throw 'result t))))
      (featurep feature))))

(defun user/ensure-installed (package)
  (if (not (or (autofeaturep package) (require package nil t)))
      (progn
        (message "Installing package: %s" package)
        ;; TODO: figure out how to specify a version as well since with multiple repositories the same package may appear in multiple versions
        (package-install package))
    (message "Package found: %s" package)))

(defun user/install-ensured-packages ()
  "Ensure that each of the packages in `user/ensured-packages' is installed"
  (mapc (lambda (pkg) (user/ensure-installed pkg)) user/ensured-packages))

(defvar user/ensured-packages
  '(
    ack-and-a-half
    anaphora
    apache-mode
    color-theme
    color-theme-sanityinc-solarized
    color-theme-solarized
    cperl-mode
    crontab-mode
    expand-region
    gh
    gist
    guru-mode ;; ugh I hate this mode
    heap
    helm
    helm-projectile
    logito
    magit
    magithub
    markdown-mode
    melpa
    paredit
    pcache
    prelude-css
    prelude-emacs-lisp
    prelude-lisp
    prelude-perl
    prelude-programming
    prelude-python
    prelude-scheme
    prelude-scss
    prelude-xml
    projectile
    python
    queue
    rainbow-delimiters
    rainbow-mode
    scratch
    scratch-log
    scss-mode
    thesaurus
    tNFA
    trie
    uuid
    volatile-highlights
    wgrep
    wrap-region
    yaml-mode
    yasnippet
    zenburn-theme
    zencoding-mode
    )
  "A list of packages that `user/ensure-installed' will install"
  )

(defun user/emacs-ready ()
  (user/install-ensured-packages)
  ;; because arrow keys aren't all that evil
  ;; really, one should be able to set a customize option to disable it globally
  (add-hook 'prog-mode-hook 'turn-off-guru-mode t))

(add-hook 'after-init-hook 'user/emacs-ready)
