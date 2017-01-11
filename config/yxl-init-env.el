(setq yxl-path-dotfiles "~/dotfiles/")
(setq yxl-path-sync "~/Dropbox/")  ;; sync location for repos
(setq yxl-path-local "~/local-repo/")  ;; local location for repos
(setq yxl-path-downloads "~/Downloads/")
(setq yxl-path-org "~/Dropbox/org/")
(setq yxl-path-org-task "~/Dropbox/org/tasks/")
(setq yxl-path-projects (concat yxl-path-local "yxl_projects"))

(setq yxl-path-code-repo (concat yxl-path-local "c3_pwd/"))
(setq yxl-path-phd-repo (concat yxl-path-local "yxl105_ctw/"))
(setq yxl-path-code-pwd (concat yxl-path-local "c3_pwd/code/"))
(setq yxl-path-paper-pwd (concat yxl-path-local "yxl105_ctw/yxl105_tex/"))
(setq yxl-path-journal-pwd (concat yxl-path-sync "lit_1_yxl105/1_thesis/"))
(setq yxl-file-bib (concat yxl-path-sync "bib/yxl_bib_master.bib"))



(setq yxl-file-note-master "~/Dropbox/org/note.org")
(setq yxl-file-org-main (concat yxl-path-org-task "tasks_1_main.org"))
(setq yxl-file-org-work (concat yxl-path-org-task "tasks_2_work.org"))
(setq yxl-file-org-config (concat yxl-path-org-task "tasks_3_config.org"))
(setq yxl-file-org-proj (concat yxl-path-org-task "tasks_4_proj.org"))
(setq yxl-file-org-log (concat yxl-path-org "logs/" "log.org"))
(setq yxl-file-org-scratch (concat yxl-path-org "scratch.org"))

(setq yxl-org-task-files (list yxl-file-org-scratch
                                 yxl-file-org-main
                                 yxl-file-org-work
                                 yxl-file-org-config
                                 yxl-file-org-proj))

(setq yxl-org-files (append yxl-org-task-files
                              (list
                               (concat yxl-path-org-task "cal_gen.org")
                               (concat yxl-path-org-task "cal_google.org")
                               (concat yxl-path-org-task "proj_ds.org")
                               (concat yxl-path-org-task "proj_ctw.org")
                               (concat yxl-path-org-task "proj_bham.org"))))



(setq yxl-env-files-alist `(("dotfiles/" . "~/dotfiles/")
                            ("emacs.d/" . "~/.emacs.d/")
                            ("local-repos/" . ,yxl-path-local)
                            ("dropbox" . ,yxl-path-sync)
                            ("projects" . ,yxl-path-projects)
                            ("org/" . ,yxl-path-org)
                            ("journal-papers/" . ,yxl-path-journal-pwd)
                            ("bib" . ,yxl-file-bib)))

(setq yxl-env-websites-alist '(("wunderlist" . "https://www.wunderlist.com")
                               ("github" . "https://www.github.com")
                               ("bham-portable" . "http://my.bham.ac.uk")
                               ("gmail" . "https://www.gmail.com")))
