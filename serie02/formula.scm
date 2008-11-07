; Structures for constructing formulas.
(define-struct variable (index))
(define-struct negation (negated))
(define-struct disjunction (left right))
(define-struct conjunction (left right))
(define-struct conditional (left right))
(define-struct biconditional (left right))

; Structure for a single assignment: variable |-> truth value.
(define-struct sass (index value))
; Structure for an undefined value.
(define-struct undefined ())
; Look-up of a variable value; an assignment is a list of sass.
(define (look-up index assignment)
  (if (null? assignment)
      (make-undefined)
      (if (= index (sass-index (first assignment)))
          (sass-value (first assignment))
          (look-up index (rest assignment)))))

; Evaluate formula w.r.t. a variable assignment.
(define (evaluate formula assignment)
  (cond ((eq? formula #t) #t)
        ((eq? formula #f) #f)
        ((variable? formula)
         (look-up (variable-index formula) assignment))
        ((negation? formula)
         (not (evaluate (negation-negated formula) assignment)))
        ((disjunction? formula)
         (or (evaluate (disjunction-left formula) assignment)
             (evaluate (disjunction-right formula) assignment)))
        ((conjunction? formula)
         (and (evaluate (conjunction-left formula) assignment)
              (evaluate (conjunction-right formula) assignment)))
        ((conditional? formula)
         (or (not (evaluate (conditional-left formula) assignment))
             (evaluate (conditional-right formula) assignment)))
        ((biconditional? formula)
         (eq? (evaluate (biconditional-left formula) assignment)
              (evaluate (biconditional-right formula) assignment)))))
(define (formula->string formula)
  (cond ((eq? formula #t) "1")
        ((eq? formula #f) "0")
        ((variable? formula)
         (string-append "X_" (number->string (variable-index formula))))
        ((negation? formula)
         (string-append "¬" (formula->string (negation-negated formula))))
        ((conjunction? formula)
         (string-append "("
                        (formula->string (conjunction-left formula))
                        " ∧ "
                        (formula->string (conjunction-right formula))
                        ")"))
        ((disjunction? formula)
         (string-append "("
                        (formula->string (disjunction-left formula))
                        " ∨ "
                        (formula->string (disjunction-right formula))
                        ")"))
        ((conditional? formula)
         (string-append "("
                        (formula->string (conditional-left formula))
                        " → "
                        (formula->string (conditional-right formula))
                        ")"))
        ((biconditional? formula)
         (string-append "(" 
                        (formula->string (biconditional-left formula))
                        " ↔ "
                        (formula->string (biconditional-right formula)) 
                        ")"))
        
  ))
