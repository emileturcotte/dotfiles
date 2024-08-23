;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Emile Turcotte"
      user-mail-address "dev@emileturcotte.com")

;; KEYBINDINGS
(map! "C-SPC" #'corfu-expand
      "TAB" #'completion-at-point)

;; FONTS

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)
(setq doom-themes-treemacs-theme "doom-colors")
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font Mono" :size 15)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))


;; LINE SETTINGS

(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq projectile-project-search-path (list "~/dev"))


;; MAIL
(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail))

(setq mu4e-context-policy 'ask-if-none
      mu4e-compose-context-policy 'always-ask)

(set-email-account! "contact@emileturcotte.com"
                    '((mu4e-sent-folder       . "/protonmail/Sent")
                      (mu4e-drafts-folder     . "/protonmail/Drafts")
                      (mu4e-trash-folder      . "/protonmail/Trash")
                      (mu4e-refile-folder     . "/protonmail/Archive")
                      (smtpmail-smtp-user     . "contact@emileturcotte.com")
                      (user-mail-address      . "contact@emileturcotte.com")
                      (mu4e-compose-signature . "\nÉmile Turcotte"))
                    t)

(set-email-account! "emile.turcotte@baseline.quebec"
                    '((mu4e-sent-folder       . "/baseline/Sent")
                      (mu4e-drafts-folder     . "/baseline/Drafts")
                      (mu4e-trash-folder      . "/baseline/Trash")
                      (mu4e-refile-folder     . "/baseline/Archive")
                      (smtpmail-smtp-user     . "emile.turcotte@baseline.quebec")
                      (user-mail-address      . "emile.turcotte@baseline.quebec")
                      (mu4e-compose-signature . "\nÉmile Turcotte"))
                    t)

(setq +mu4e-gmail-accounts '(("emile.turcotte@baseline.quebec" . "/baseline")))

(setq mu4e-update-interval 60)

;;; :completion company
(after! company
  (setq company-idle-delay nil))

;;; :completion corfu
;; IMO, modern editors have trained a bad habit into us all: a burning need for
;; completion all the time -- as we type, as we breathe, as we pray to the
;; ancient ones -- but how often do you *really* need that information? I say
;; rarely. So opt for manual completion:
(after! corfu
  (setq corfu-auto nil))

;;; :ui modeline
;; An evil mode indicator is redundant with cursor shape
(setq doom-modeline-modal nil)

;;; :editor evil
;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;; :tools lsp
;; Disable invasive lsp-mode features
(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil
        ;; If an LSP server isn't present when I start a prog-mode buffer, you
        ;; don't need to tell me. I know. On some machines I don't care to have
        ;; a whole development environment for some ecosystems.
        lsp-enable-suggest-server-download nil))
(after! lsp-ui
  (setq lsp-ui-sideline-enable nil  ; no more useful than flycheck
        lsp-ui-doc-enable nil))     ; redundant with K

;; :lang python
;; https://www.emacswiki.org/emacs/PythonProgrammingInEmacs#h5o-27
(add-hook! python-mode-hook
  (flymake-ruff-load))

(add-hook! python-mode-hook
  (ruff-format-on-save-mode))

(setq dap-python-debugger 'debugpy)
