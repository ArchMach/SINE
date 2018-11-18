
(documentation ">doc>sd>dired.doc")

(variable rcr)
(variable read_line)
(variable redo_mode_line)
(variable replace)
(variable return_from_reader)
(variable load_file)
(variable beginning_of_line)
(variable back_char)
(variable next_line)
(variable previous_line)
(variable full_redisplay)
(variable print_msg)
(variable keep_on_tunneling)

(variable current_buffer)
(variable echo_buf)
(variable tg)
(variable dir)
(variable dired_cte)
(variable dispatch)
(variable M_dispatch)
(variable C-X_dispatch)

(defun DIRED_mode ()
     (bind_key d dired_delete_current)
     (bind_key D dired_delete_current)
     (bind_key k dired_delete_current)
     (bind_key K dired_delete_current)
     (bind_key c-d dired_delete_current)
     (bind_key c-k dired_delete_current)
     (bind_key u dired_undelete_current)
     (bind_key U dired_undelete_current)
     (bind_key del dired_undelete_previous)
     (bind_key " " next_line)
     (bind_key n next_line)
     (bind_key N next_line)
     (bind_key p previous_line)
     (bind_key P previous_line)
     (bind_key q dired_quit)
     (bind_key Q dired_quit)
     (bind_key x dired_quit)
     (bind_key X dired_quit)
     (bind_key e dired_rcr_command)
     (bind_key E dired_rcr_command)
     (keep_on_tunneling))

(defun dired_delete_current ()
     (beginning_of_line)
     (cond ((eq (nth current_buffer (location current_buffer)) 9)
            (insert 68 current_buffer)))
     (next_line))

(defun dired_undelete_current ()
     (beginning_of_line)
     (cond ((not (eq (nth current_buffer (location current_buffer)) 9))
            (delete current_buffer 1)))
     (next_line))

(defun dired_undelete_previous ()
     (previous_line)
     (cond ((not (eq (nth current_buffer (location current_buffer)) 9))
            (delete current_buffer 1))))

(defun dired_quit (&aux char)
     (delete tg (length tg))
     (set_loc current_buffer 0)
loop
     (insert_region current_buffer
          (set_loc current_buffer (iferror (search current_buffer "D  ")
                                           (goto end_loop)))
          (set_loc current_buffer (search current_buffer 13))
          tg)
     (goto loop)
end_loop
     (cond ((eq (length tg) 0) (return_from_reader)
                               (return)))
     (cond ((eq dired_cte "de")
             (print_clearing "Delete the following files in " 1 1 1)
             (print_clearing dir 31 1 1)
             (print_clearing "?" (add 31 (length dir)) 1 1))
           ((t)
             (print_clearing "Run the " 1 1 1)
             (print_clearing 34 9 1 1)
             (print_clearing dired_cte 10 1 1)
             (print_clearing 34 (add 10 (length dired_cte)) 1 1)
             (print_clearing " command on the following files in "
                             (add 11 (length dired_cte)) 1 1)
             (print_clearing dir (add 46 (length dired_cte)) 1 1)
             (print_clearing "?"
                             (add 46 (add (length dired_cte) (length dir)))
                             1 1)))
     (print_clearing " " 1 2 1)
     (print_clearing
          "Valid answers are y (yes), n (no, go back), q (quit), x (quit)."
          1 3 1)
     (print_clearing " " 1 4 1)
     (print_clearing tg 1 5 1)
     (store (tyi) char)
     (cond ((or (eq char "Y") (eq char "y"))
            (print_msg "Yes" 0)
            (redo_mode_line)
            (print_msg " " 0)
            (set_loc current_buffer 0)
            (delete current_buffer (length current_buffer))
            (insert tg current_buffer)
            (set_loc current_buffer 0)
inner_loop
            (cat_into tg dired_cte " " dir ">")
            (insert_region current_buffer
                 (location current_buffer)
                 (set_loc current_buffer (iferror (search current_buffer 13)
                                                  (return_from_reader)
                                                  (return)))
               tg)
            (cline tg)
            (goto inner_loop))
           ((or (eq char "Q") (eq char "q"))
return_fr
            (print_msg "Just Quit" 0)
            (return_from_reader)
            (return))
           ((or (eq char "X") (eq char "x"))
            (goto return_fr))
           ((or (eq char "N") (eq char "n"))
            (print_msg "No, Go Back" 0)
            (set_loc current_buffer 0))
           ((t)
            (print_msg "Bad Answer" 1)
            (redo_mode_line)
            (goto end_loop))))

(defun dired_rcr_command
     (beginning_of_line)
     (cat_into tg dir ">")
     (insert_region current_buffer
                    (search current_buffer 9)
                    (sub (search current_buffer 13) 1)
                    tg)
     (rcr tg))

(defun dired_set_cte ()
     (replace dired_cte (read_line "Dired Command: " 13))
     (cond ((eq (length dired_cte) 0)
             (insert "de" dired_cte)
             (insert "de" echo_buf))))
^L