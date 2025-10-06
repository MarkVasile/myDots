;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! project
  (map! :leader
        (:prefix ("p" . "project")
                 :desc "Find file in project (fzf)"
                 "f" #'fzf-git)))

;;; --- Per-project theme switching (project.el) ---
(defvar my/project-theme-rules
  '(("ca\\.api"         . wheatgrass)
    ("caw\\.localservice" . doom-dark+)
    ("muninn"           . doom-nord)))

(defvar my/project-theme-fallback nil)

(defun my/apply-theme-for-project (&optional dir)
  "Set theme based on current project's folder name. Accepts DIR from project.el."
  (interactive)
  (let* ((root (or dir
                   (when-let ((proj (ignore-errors (project-current))))
                     (ignore-errors (project-root proj)))
                   (when (fboundp 'projectile-project-root)
                     (ignore-errors (projectile-project-root)))
                   default-directory))
         (pname (and root (file-name-nondirectory (directory-file-name root))))
         (target
          (let ((case-fold-search t))  ; make matching case-insensitive
            (or (cl-loop for (re . th) in my/project-theme-rules
                         if (and pname (string-match-p re pname))
                         return th)
                my/project-theme-fallback))))

    (when root
      (message "[my-theme] root=%s pname=%s target=%s current=%s"
               root pname target (car custom-enabled-themes)))

    (when (and target
               ;; Only switch if different from currently *enabled* theme
               (not (member target custom-enabled-themes)))
      ;; Keep Doom's var consistent
      (setq doom-theme target)
      ;; Force switch now, so later hooks don't override us
      (mapc #'disable-theme custom-enabled-themes)
      (load-theme target t)
      (message "[my-theme] loaded %s" target))))

;;;; --- Project-theme auto switcher (robust across buffer/window changes) ---

(defvar my/project-theme-last-root nil
  "Cache of the last project root we themed for, to avoid redundant reloads.")

(defun my/detect-project-root ()
  "Return a sensible project root for the current context."
  (or (when-let ((proj (ignore-errors (project-current))))
        (ignore-errors (project-root proj)))
      (when (fboundp 'projectile-project-root)
        (ignore-errors (projectile-project-root)))
      default-directory))

(defun my/apply-theme-for-project* (&optional dir)
  "Apply the right theme for DIR (or current project)."
  (let* ((root (or dir (my/detect-project-root)))
         (pname (and root (file-name-nondirectory (directory-file-name root))))
         (target
          (let ((case-fold-search t))
            (or (cl-loop for (re . th) in my/project-theme-rules
                         if (and pname (string-match-p re pname)) return th)
                my/project-theme-fallback))))
    (when (and root (not (equal root my/project-theme-last-root)))
      (setq my/project-theme-last-root root)
      (message "[my-theme] root=%s pname=%s target=%s current=%s"
               root pname target (car custom-enabled-themes))
      (when (and target (not (member target custom-enabled-themes)))
        (setq doom-theme target)
        (mapc #'disable-theme custom-enabled-themes)
        (load-theme target t)
        (message "[my-theme] loaded %s" target)))))

;; Run when opening a file
(add-hook 'find-file-hook #'my/apply-theme-for-project* 'append)

;; Run after switching projects (project.el passes DIR)
(add-hook 'project-switch-project-hook #'my/apply-theme-for-project* 'append)

;; Projectile’s switch hook (no arg)
(add-hook 'projectile-after-switch-project-hook #'my/apply-theme-for-project* 'append)

;; Run whenever the selected window’s buffer changes
(defun my/theme-on-window-buffer-change (_win _prev-buf)
  (unless (window-minibuffer-p) (my/apply-theme-for-project*)))
(add-hook 'window-buffer-change-functions #'my/theme-on-window-buffer-change)

;; As a fallback, also react to buffer list changes (cheap thanks to the cache)
(add-hook 'buffer-list-update-hook #'my/apply-theme-for-project*)
