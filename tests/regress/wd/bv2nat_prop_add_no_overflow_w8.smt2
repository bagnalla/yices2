(set-logic QF_AUFBVLIA)

(declare-fun x () (_ BitVec 8))
(declare-fun y () (_ BitVec 8))

; If there's no overflow, bvadd matches integer addition exactly.
(assert (<= (+ (bv2nat x) (bv2nat y)) 255))
(assert (not (= (+ (bv2nat x) (bv2nat y))
                (bv2nat (bvadd x y)))))

(check-sat)
