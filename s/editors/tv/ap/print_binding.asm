
(documentation ">doc>sd>print_binding.doc")

(variable print_msg)
(variable read_line)
(variable replace)

(variable dispatch)
(variable M_dispatch)
(variable C-X_dispatch)
(variable tg)

(defun print_binding (&aux string foo bar)
     (store (read_line "Key Description: " 13) string)
     (cond ((eq (car (store (decode_key string) foo)) 0)
            (print_msg "Decoding Error" 1))
           ((t) (print_msg
                 (cond ((stringp (store (ar (car foo) (cdr foo)) bar))
                        (cat_into tg 34 bar 34))
                       ((t) (get_pname bar)))
                 0))))

(defun decode_key (string &aux n char next
                               control_x control meta index modifier)
     (store 0 n)
     (store (store (store (store 0 control_x) index) control) meta)
parse_loop
     (store (upper_case (store (nth string n) char)) modifier)
     (store (nth string (add n 1)) next)
     (cond  ((eq char -1) (goto got_it))
            ((t) (cond ((and (eq (upper_case index) \58) (eq control 1))
                        (store 1 control_x) (store (store 0 control) index)))))
     (cond ((eq next -1) (ifnil (eq index 0) error)
                         (store char index) (goto got_it))
           ((and (eq modifier \43) (eq next \2d)) (ifnil (eq control 0) error)
                                                  (store 1 control))
           ((and (eq modifier \4d) (eq next \2d)) (ifnil (eq meta 0) error)
                                                  (store 1 meta))
           ((and (eq modifier \44)
                 (and (eq (upper_case next) \45)
                      (eq (upper_case (nth string (add n 2))) \4c)))
            (store \7f index) (goto got_it))
           ((eq modifier \5e) (ifnil (eq index 0) error)
                              (store 1 control) (store next index))
           ((t) (store char index) (store (add n 1) n) (goto parse_loop)))
     (store (add 2 n) n)
     (goto parse_loop)
got_it
     (cond ((eq index 0) (goto error)))
     (cond ((eq control 1) (store (and index \1f) index)))
     (cond ((eq control_x 1) (ift (eq meta 1) error)
                             (cons C-X_dispatch index))
           ((eq meta 1) (cons M_dispatch index))
           ((t) (cons dispatch index))
           ((t) error (cons 0 0))))

(defun upper_case (char)
     (cond ((and (gp char \60) (lp char \7b)) (sub char 32))
           ((t) (push char))))
^L