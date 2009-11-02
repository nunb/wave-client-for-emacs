;;; wave-list.el --- Defines wave-list-mode, for managing waves.
;; Copyright (c) 2009 Andrew Hyatt
;;
;; Author: Andrew Hyatt <ahyatt at gmail dot com>
;; Maintainer: Andrew Hyatt <ahyatt at gmail dot com>
;;
;; Licensed to the Apache Software Foundation (ASF) under one
;; or more contributor license agreements. See the NOTICE file
;; distributed with this work for additional information
;; regarding copyright ownership. The ASF licenses this file
;; to you under the Apache License, Version 2.0 (the
;; "License"); you may not use this file except in compliance
;; with the License. You may obtain a copy of the License at
;;
;;   http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing,
;; software distributed under the License is distributed on an
;; "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
;; KIND, either express or implied. See the License for the
;; specific language governing permissions and limitations
;; under the License.


;;; Commentary:
;; This file contains code related to displaying, opening, and
;; manipulating waves.
;;
;; This file right now is a work in progress, and can so far only
;; display a list of waves.  We also need to open them, archive them,
;; mute them, and be able to get different lists (with searches).

(require 'wave-client)

;;; Code:
(defvar wave-list-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "n" 'next-line)
    (define-key map "p" 'previous-line)
    map)
  "Keybindings for wave-list mode.")

(defvar wave-list-waves ()
  "The data rendered in the list of waves.")

(defconst wave-list-buffer-name "*Wave List*")

(defun wave-list-username-only (full-username)
  "Return the username portion of an email address FULL_USERNAME.

If no @ symbol is found, return FULL-USERNAME unmodified."
  (substring full-username 0
             (or (string-match "@" full-username)
                 (length full-username))))

(defun wave-list-render-wave-list (wave-list)
  "Render WAVE-LIST, a list of wave summary alists to a buffer.

Every wave takes up one line."
  (setq wave-list-waves wave-list)
  (setq buffer-read-only nil)
  (erase-buffer)
  (dolist (summary-alist wave-list)
    (insert
     (let ((digest-length 50)
           (participants-length 27))
       (format
        (concat "%-" (int-to-string digest-length)
                "s [%-" (int-to-string participants-length)
                "s]\n")
        (cdr (assoc :digest summary-alist))
        (let ((participants-str
               (mapconcat 'wave-list-username-only
                          (cdr (assoc :participants summary-alist))
                          ", ")))
          (substring participants-str 0
                     (min (length participants-str)
                          participants-length)))))))
  (goto-char (point-max))
  (backward-char)
  (kill-line)
  (goto-char (point-min)))

(defun wave-list-mode ()
  "Major mode for navigating a list of waves.

Each line in the mode represents a Wave that can be opened.
The wave client must be connected here."
  (interactive)
  (wave-client-assert-connected)
  (set-buffer (get-buffer-create wave-list-buffer-name))
  (kill-all-local-variables)
  (setq major-mode 'wave-list-mode)
  (setq mode-name "Wave List")
  (use-local-map wave-list-mode-map)
  (make-variable-buffer-local 'wave-list-waves)
  (wave-list-render-wave-list (wave-inbox))
  (buffer-disable-undo)
  (setq buffer-read-only t
	show-trailing-whitespace nil
        truncate-lines t
        selective-display t
        selective-display-ellipses t)
  (hl-line-mode)
  (run-mode-hooks)
  (set-window-buffer (get-buffer-window (current-buffer))
                     wave-list-buffer-name))

(provide 'wave-list)

;;; wave-list.el ends here
