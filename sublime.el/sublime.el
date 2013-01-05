;;; sublime.el --- SublimeText emulation
;;;
;;; Copyright (C) 2012 Lorenzo Villani.
;;;
;;; Author: Lorenzo Villani <lorenzo@villani.me>
;;; URL: https://github.com/lvillani/sublime.el
;;;
;;; This file is not part of GNU Emacs.
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;;;

(unless (>= 24 emacs-major-version)
  (error "sublime.el requires Emacs 24 or later."))

(require 'sublime-keys)
(require 'sublime-project)
(require 'sublime-system)
(require 'sublime-ui)

;;;###autoload
(defun sublime ()
  "Activates all customization options provided by `sublime.el'."
  (interactive)
  (sublime-keys)
  (sublime-project)
  (sublime-system)
  (sublime-ui))

;;;###autoload
(progn
  (sublime))

(provide 'sublime)

;;; sublime.el ends here
