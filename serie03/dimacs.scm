#lang scheme

(provide (all-defined-out))
(require "formula.scm")
(define (to-dimacs formula)
  (string-append "c umstaendlich konvertiert.\n"
                 "p cnf "
                 (number->string (clause-count formula))
                 " "
                 (number->string (variable-count formula))
                 "\n"
                 (clauses->string (clauses formula))
                 ))

(define (clauses->string clauses)
  (clauses->string-iter clauses ""))

(define (clauses->string-iter clauses string)
  (cond ((null? clauses) string)
        (else (clauses->string-iter (cdr clauses)
                                    (string-append (clause->string (car clauses))
                                                   " 0\n" string)))
        ))

(define (clause->string clause)
  (cond ((disjunction? clause) (string-append 
                                (clause->string (disjunction-left clause)) 
                                " " 
                                (clause->string (disjunction-right clause))))
        ((variable? clause) (number->string (variable-index clause)))
        ((negation? clause) 
         (number->string (* -1 (variable-index (negation-negated clause)))))
  ))

  
(define (variable-count formula)
  (length (variables formula)))

(define (clause-count formula)
  (length (clauses formula))
  )

(define (clauses formula)
  (clauses-iter formula null)
  )

(define (clauses-iter formula clauses)
  (cond ((negation? formula) (list formula))
        ((variable? formula) (list formula))
        ((disjunction? formula) (list formula)) 
        ((conjunction? formula) (append 
                                 (append (clauses-iter 
                                          (conjunction-left formula) clauses))
                                 (clauses-iter (conjunction-right formula) null)))
    )
  )

(define (variables formula) (variables-iter formula null))

(define (variables-iter formula variables)
    (cond ((eq? formula #t) variables)
        ((eq? formula #f) variables)
        ((variable? formula) (add-variable formula variables))
        ((negation? formula) (variables-iter 
                              (negation-negated formula)
                              variables))
        ((disjunction? formula) (variables-iter 
                                 (disjunction-right formula)
                                 (variables-iter (disjunction-left formula)
                                                 variables)))
        ((conjunction? formula) (variables-iter 
                                 (conjunction-right formula)
                                 (variables-iter (conjunction-left formula)
                                                 variables)))
        ((conditional? formula) (variables-iter 
                                 (conditional-right formula)
                                 (variables-iter (conditional-left formula)
                                                 variables)))
        ((biconditional? formula) (variables-iter 
                                   (biconditional-right formula)
                                   (variables-iter (biconditional-left formula)
                                                   variables)))
        )
  )
(define (add-variable variable variables)
   (cond ((null? variables) (list variable))
         ((< (variable-index variable) (variable-index (car variables)))
          (append (list variable) variables))
         ((= (variable-index variable) (variable-index (car variables)))
          variables)
         ((> (variable-index variable) (variable-index (car variables)))
          (append (list (car variables)) (add-variable variable (cdr variables))))
  ))