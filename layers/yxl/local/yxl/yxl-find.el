(defvar yxl-popwin-width-big 60)
(defvar yxl-popwin-width-small 40)

(defun yxl-find-dir-dotfiles ()
  (interactive)
  (find-file yxl-path-dotfiles))
(defun yxl-find-dir-Downloads ()
  (interactive)
  (find-file yxl-path-local))
(defun yxl-find-dir-Dropbox ()
  (interactive)
  (find-file yxl-path-sync))
(defun yxl-find-dir-org ()
  (interactive)
  (find-file yxl-path-org))
(defun yxl-find-pwd-code ()
  (interactive)
  (find-file yxl-path-code-pwd))
(defun yxl-find-pwd-paper ()
  (interactive)
  (find-file yxl-path-paper-pwd))
(defun yxl-find-pwd-journal ()
  (interactive)
  (find-file yxl-path-journal-pwd))

;; find file functions
(defun yxl-find-file-bib ()
  (interactive)
  (find-file yxl-file-bib))

(defun yxl-find-file-org ()
  (interactive)
  (find-file yxl-file-org-main))

(defun yxl-find-file-org-other-window ()
  (interactive)
  (find-file-other-window yxl-file-org-main))

(defun yxl-find-file-org-popup ()
  (interactive)
  (let ((pop-width (yxl-window-popwin-width)))
    (popwin:popup-buffer (find-file-noselect yxl-file-org-main)
                         :width pop-width :position 'left :stick t)))

(defun yxl-find-file-org-work ()
  (interactive)
  (find-file yxl-file-org-work))

(defun yxl-find-file-org-work-other-window ()
  (interactive)
  (find-file-other-window yxl-file-org-work))

(defun yxl-find-file-org-work-popup ()
  (interactive)
  (let ((pop-width (yxl-window-popwin-width)))
    (popwin:popup-buffer (find-file-noselect yxl-file-org-work)
                         :width pop-width :position 'left :stick t)))

(defun yxl-find-file-org-dotfile-popup ()
  (interactive)
  (let ((pop-width (yxl-window-popwin-width)))
    (popwin:popup-buffer (find-file-noselect yxl-file-dotfiles-todo)
                         :width pop-width :position 'left :stick t)))


(defun yxl-find-file-org-scratch ()
  "Switch to `scratch.org'"
  (interactive)
  (find-file yxl-file-org-scratch))

(defun yxl-find-file-org-scratch-popup ()
  (interactive)
  (let ((pop-width (yxl-window-popwin-width)))
    (popwin:popup-buffer (find-file-noselect yxl-file-org-scratch)
                         :width pop-width :position 'left :stick t)))

;; TODO: change to org version as in capture template
(defun yxl-find-file-diary ()
  (interactive)
  (find-file diary-file))

(defun yxl-find-file-note ()
  (interactive)
  (find-file yxl-text-note-file))

(defun yxl-find-file-note-master ()
  (interactive)
  (find-file yxl-file-note-master))

(provide 'yxl-find)
