#lang scheme

(provide (all-defined-out))
(require "formula.scm")

(define (variables formula) (variables-iter formula null))

(define (variables-iter formula variables)
    (cond ((eq? formula #t) variables)
        ((eq? formula #f) variables)
        ((variable? formula) (add-variable formula variables))
        ((negation? formula) (variables-iter (negation-negated formula) variables))
        ((disjunction? formula) (variables-iter (disjunction-right formula) (variables-iter (disjunction-left formula) variables)))
        ((conjunction? formula) (variables-iter (conjunction-right formula) (variables-iter (conjunction-left formula) variables)))
        ((conditional? formula) (variables-iter (conditional-right formula) (variables-iter (conditional-left formula) variables)))
        ((biconditional? formula) (variables-iter (biconditional-right formula) (variables-iter (biconditional-left formula) variables)))
        )
  )
(define (add-variable variable variables)
   (cond ((null? variables) (list variable))
         ((< (variable-index variable) (variable-index (car variables))) (append (list variable) variables))
         ((= (variable-index variable) (variable-index (car variables))) variables)
         ((> (variable-index variable) (variable-index (car variables))) (append (list (car variables)) (add-variable variable (cdr variables))))
  ))