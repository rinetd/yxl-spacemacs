(require 'evil)

(defun evil-insert-newline-around ()
  (interactive)
  (evil-insert-newline-above)
  (forward-line)
  (evil-insert-newline-below)
  (forward-line -1))

(defun evil-insert-space ()
  "identical to vim: i SPC <escape> l"
  (interactive)
  (insert " "))

(defun evil-apend-space ()
  "identical to vim: a SPC <escape> hh"
  (interactive)
  (forward-char 1)
  (insert " ")
  (forward-char -2))

(evil-define-motion evil-sentence-comma-forward (count)
  "Move to next comma"
  :jump t
  :type exclusive
  ;; (evil-find-char (or count 1) ?,)
  (evil-forward-chars "," (or count 1))
  (evil-forward-char 1 t))

(evil-define-motion evil-sentence-comma-backward (count)
  "Move to next comma"
  :jump t
  :type exclusive
  (evil-forward-chars "," (- (or count 1))))

(provide 'evil-goodies)
