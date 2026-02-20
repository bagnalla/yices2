(set-logic QF_AUFBVLIA)

(declare-fun x () (_ BitVec 8))
(declare-fun y () (_ BitVec 8))

; For bit-vectors, addition corresponds to integer addition modulo 2^8.
(assert (not (= (bv2nat (bvadd x y))
                (mod (+ (bv2nat x) (bv2nat y)) 256))))

(check-sat)
