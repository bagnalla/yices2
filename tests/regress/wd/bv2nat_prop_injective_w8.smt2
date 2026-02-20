(set-logic QF_AUFBVLIA)

(declare-fun x () (_ BitVec 8))
(declare-fun y () (_ BitVec 8))

; Counterexample to injectivity of bv2nat (should be impossible).
(assert (= (bv2nat x) (bv2nat y)))
(assert (not (= x y)))

(check-sat)
