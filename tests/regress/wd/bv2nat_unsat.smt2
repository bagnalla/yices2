(set-logic QF_AUFBVLIA)

(declare-fun x () (_ BitVec 4))

(assert (= x #b1010))
(assert (= (bv2nat x) 9))

(check-sat)
