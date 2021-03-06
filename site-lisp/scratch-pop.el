;;; scratch-pop.el --- Generate, popup (& optionally backup) scratch buffer(s).

;; Copyright (C) 2012-2015 zk_phi

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

;; Version: 2.1.1
;; Author: zk_phi
;; URL: http://hins11.yu-yake.com/
;; Package-Requires: ((popwin "0.7.0alpha"))

;;; Commentary:

;; Load this script
;;
;;   (require 'scratch-pop)
;;
;; and you can popup a scratch buffer with "M-x scratch-pop". If a
;; scratch is already displayed, then another one is created. You may
;; also bind some keys to "scratch-pop" if you want.
;;
;;   (global-set-key "C-M-s" 'scratch-pop)
;;
;; You can backup scratches by calling `scratch-pop-backup-scratches'
;; after setting `scratch-pop-backup-directory', and then restore
;; backup by calling `scratch-pop-restore-scratches'.
;;
;;   (scratch-pop-backup-directory)
;;   (scratch-pop-restore-scratches)
;;
;; It's good idea to put `scratch-pop-backup-directory' into
;; `kill-emacs-hook' so that scratches are automatically saved when
;; killing emacs.
;;
;;   (add-hook 'kill-emacs-hook 'scratch-pop-backup-scratches)

;;; Change Log:

;; 1.0.0 first released
;; 1.0.1 better management of multiple scratches
;;       automatically yank region
;; 1.0.2 better handling of popup window
;; 1.0.3 require popwin
;; 2.0.0 change scratch buffer selection algorithm
;; 2.1.0 add backup feature
;; 2.1.1 add option to disable auto yank

;;; Code:

;; *TODO* implement version control feature

(require 'popwin)
(require 'edmacro)                      ; edmacro-format-keys

(defconst scratch-pop-version "2.1.1")

;; + customs

(defgroup scratch-pop nil
  "Generate, popup (& optionally backup) scratch buffer(s)"
  :group 'emacs)

(defcustom scratch-pop-backup-directory nil
  "When non-nil, scratch buffers are backed up in the directory."
  :group 'emacs)

(defcustom scratch-pop-enable-auto-yank nil
  "When non-nil and `scratch-pop' is called with an active
region, the region is yanked to the scratch buffer."
  :group 'emacs)

(defcustom scratch-pop-default-mode nil
  "When non-nil, scratch-pop will spawn with the specified mode"
  :group 'scratch-pop)

(defcustom scratch-pop-position 'bottom
  "position to spawn scratch pop: top, bottom, left, right"
  :type '(choice (const :tag "top" top)
                 (const :tag "bottom" bottom)
                 (const :tag "left" left)
                 (const :tag "right" right)))

;; + backup

(defun scratch-pop-backup-scratches ()
  "Backup scratch buffers."
  (unless scratch-pop-backup-directory
    (error "scratch-pop: Backup directory is not set."))
  (if (file-exists-p scratch-pop-backup-directory)
      (mapc (lambda (f) (when (file-regular-p f) (delete-file f)))
            (directory-files scratch-pop-backup-directory t))
    (make-directory scratch-pop-backup-directory))
  (dolist (buf (buffer-list))
    (let* ((bufname (buffer-name buf))
           (filename (when (string-match "^\\*\\(scratch[0-9]*\\)\\*$" bufname)
                       (concat (match-string 1 bufname) "_"
                               (with-current-buffer bufname (symbol-name major-mode))))))
      (when filename
        (with-current-buffer buf
          (unless (zerop (buffer-size))
            (write-region 1 (1+ (buffer-size))
                          (expand-file-name filename scratch-pop-backup-directory))))))))

(defun scratch-pop-restore-scratches (&optional limit)
  "Restore scratch buffers. You can optionally limit the number
of scratch buffers to restore."
  (unless scratch-pop-backup-directory
    (error "scratch-pop: Backup directory is not set."))
  (when (file-exists-p scratch-pop-backup-directory)
    (dolist (file (directory-files scratch-pop-backup-directory))
      (when (string-match "^\\(scratch\\([0-9]*\\)\\)_\\(.*\\)$" file)
        (let ((bufname (concat "*" (match-string 1 file) "*"))
              (mode (intern (match-string 3 file)))
              (id (or (string-to-number (match-string 2 file)) 0)))
          (when (or (null limit) (> limit id))
            (unless (get-buffer bufname)
              (generate-new-buffer bufname))
            (with-current-buffer bufname
              (erase-buffer)
              (save-excursion
                (insert-file-contents
                 (expand-file-name file scratch-pop-backup-directory)))
              (funcall mode))))))))

;; + core

(defvar scratch-pop--next-scratch-id nil) ; Int
(defvar scratch-pop--visible-buffers nil) ; List[Buffer]

(defun scratch-pop--get-next-scratch ()
  "Return the next scratch buffer. This function creates a new
buffer if necessary. Binding `scratch-pop--next-scratch-id'
and/or `scratch-pop--visible-buffers' dynamically affects this
function."
  (let* ((name (concat "*scratch"
                       (unless (= scratch-pop--next-scratch-id 1)
                         (int-to-string scratch-pop--next-scratch-id))
                       "*"))
         (buf (get-buffer name)))
    (setq scratch-pop--next-scratch-id (1+ scratch-pop--next-scratch-id))
    (cond ((null buf)
           (with-current-buffer (generate-new-buffer name)
             (funcall initial-major-mode)
             (current-buffer)))
          ((memq buf scratch-pop--visible-buffers) ; skip visible buffers
           (scratch-pop--get-next-scratch))
          (t
           buf))))

;;;###autoload
(defun scratch-pop ()
  "Popup a scratch buffer. If `*scratch*' is already displayed,
create new scratch buffers `*scratch2*', `*scratch3*', ... ."
  (interactive)
  (let ((str (when (and scratch-pop-enable-auto-yank (use-region-p))
               (prog1 (buffer-substring (region-beginning) (region-end))
                 (delete-region (region-beginning) (region-end))
                 (deactivate-mark))))
        (repeat-key (vector last-input-event)))
    (setq scratch-pop--next-scratch-id 1
          scratch-pop--visible-buffers (mapcar 'window-buffer (window-list)))
    (popwin:popup-buffer (scratch-pop--get-next-scratch)
                         :position scratch-pop-position)
    (when str
      (goto-char (point-max))
      (insert (concat "\n" str "\n")))
    (message "(Type %s to repeat)" (edmacro-format-keys repeat-key))
    (set-temporary-overlay-map
     (let ((km (make-sparse-keymap))
           (cycle-fn (lambda ()
                       (interactive)
                       (with-selected-window popwin:popup-window
                         (switch-to-buffer (scratch-pop--get-next-scratch))))))
       (define-key km repeat-key cycle-fn)
       km) t))
  ;; switch to a predefined mode
  (when (fboundp scratch-pop-default-mode)
    (funcall scratch-pop-default-mode)))

;; TODO: no need to call major mode, but why initial-major-mode not working?
;;;###autoload
(defun scratch-pop-sticky ()
  "Sticky version of scratch pop"
  (interactive)
  (let ((str (when (and scratch-pop-enable-auto-yank (use-region-p))
               (prog1 (buffer-substring (region-beginning) (region-end))
                 (delete-region (region-beginning) (region-end))
                 (deactivate-mark))))
        (repeat-key (vector last-input-event)))
    (setq scratch-pop--next-scratch-id 1
          scratch-pop--visible-buffers (mapcar 'window-buffer (window-list)))
    (popwin:popup-buffer (scratch-pop--get-next-scratch)
                         :position scratch-pop-position :stick t)
    (when str
      (goto-char (point-max))
      (insert (concat "\n" str "\n")))
    (message "(Type %s to repeat)" (edmacro-format-keys repeat-key))
    (set-temporary-overlay-map
     (let ((km (make-sparse-keymap))
           (cycle-fn (lambda ()
                       (interactive)
                       (with-selected-window popwin:popup-window
                         (switch-to-buffer (scratch-pop--get-next-scratch))))))
       (define-key km repeat-key cycle-fn)
       km) t))
  ;; switch to a predefined mode
  (when (fboundp scratch-pop-default-mode)
    (funcall scratch-pop-default-mode)))

(provide 'scratch-pop)

;;; scratch-pop.el ends here
