;;; rp-dispatch.el --- dispatch windows to groups

;; Copyright (C) 2007  sabetts

;; Author: sabetts <sabetts@andrew.cmu.edu>
;; Keywords: 

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This can be used with the rpws script to dispatch existing windows
;; to specific workspaces. You need the ratpoison-cmd.el file which is
;; generated by contrib/genrpbindings.
;;
;; You need to set rp-window-alist to something useful, here's a sample:
;; (setq rp-window-alist '((1 "XTerm" "XTerm") 
;;                         (2 "Gimp" "XTerm")))
;;
;; This will dispatch 2 xterms to workspace 1 and a gimp window and an
;; xterm to to workspace 2. Note: CAsE Is ImpOrtANT. It uses the
;; window class to identify windows. You can see the class of a window
;; with the window command:

;; C-t : windows %n %c

;;; Code:

(require 'cl)
(require 'ratpoison-cmd)

(defvar rp-window-alist nil
  "An alist of workspaces and window classes that should appear
there.")

(defvar rp-ws-fmt "wspl%d")

(defun ratpoison-dispatch-windows ()
  (interactive)
  (let ((windows (mapcar 'split-string (split-string (ratpoison-windows "%n %c") "\n"))))
    (loop for ws in rp-window-alist do
         (loop for win in (cdr ws) do  
              (let* ((match (find win windows :key 'second :test 'string-equal)))
                (when match
                  (setq windows (remove match windows))
                  (message "windomws: %s" windows)
                  (ratpoison-select (first match))
                  (ratpoison-gmove (format rp-ws-fmt (first ws)))))))))

(provide 'rp-dispatch)
;;; rp-dispatch.el ends here
