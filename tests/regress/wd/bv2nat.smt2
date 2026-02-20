(set-logic QF_AUFBVLIA)

; 1) Basic satisfiable example.
(push 1)
(declare-fun x_sat () (_ BitVec 4))
(assert (= x_sat #b1010))
(assert (= (bv2nat x_sat) 10))
(check-sat)
(pop 1)

; 2) Basic unsatisfiable example.
(push 1)
(declare-fun x_unsat () (_ BitVec 4))
(assert (= x_unsat #b1010))
(assert (= (bv2nat x_unsat) 9))
(check-sat)
(pop 1)

; 3) Injectivity: bv2nat x = bv2nat y implies x = y.
(push 1)
(declare-fun x_i () (_ BitVec 8))
(declare-fun y_i () (_ BitVec 8))
(assert (= (bv2nat x_i) (bv2nat y_i)))
(assert (not (= x_i y_i)))
(check-sat)
(pop 1)

; 4) bv2nat commutes with addition modulo 2^8.
(push 1)
(declare-fun x_am () (_ BitVec 8))
(declare-fun y_am () (_ BitVec 8))
(assert (not (= (bv2nat (bvadd x_am y_am))
                (mod (+ (bv2nat x_am) (bv2nat y_am)) 256))))
(check-sat)
(pop 1)

; 5) bv2nat commutes with addition when there is no overflow.
(push 1)
(declare-fun x_ao () (_ BitVec 8))
(declare-fun y_ao () (_ BitVec 8))
(assert (<= (+ (bv2nat x_ao) (bv2nat y_ao)) 255))
(assert (not (= (+ (bv2nat x_ao) (bv2nat y_ao))
                (bv2nat (bvadd x_ao y_ao)))))
(check-sat)
(pop 1)

; 6) bv2nat commutes with multiplication modulo 2^4.
(push 1)
(declare-fun x_mm () (_ BitVec 4))
(declare-fun y_mm () (_ BitVec 4))
(assert (not (= (bv2nat (bvmul x_mm y_mm))
                (mod (+ (ite (= ((_ extract 0 0) y_mm) #b1) (bv2nat x_mm) 0)
                        (ite (= ((_ extract 1 1) y_mm) #b1) (* 2 (bv2nat x_mm)) 0)
                        (ite (= ((_ extract 2 2) y_mm) #b1) (* 4 (bv2nat x_mm)) 0)
                        (ite (= ((_ extract 3 3) y_mm) #b1) (* 8 (bv2nat x_mm)) 0))
                     16))))
(check-sat)
(pop 1)

; 6b) Concrete wraparound multiplication examples.
(push 1)
; 3 * 6 = 18, and 18 mod 16 = 2.
(assert (= (bv2nat (bvmul (_ bv3 4) (_ bv6 4))) 2))
; 7 * 7 = 49, and 49 mod 16 = 1.
(assert (= (bv2nat (bvmul (_ bv7 4) (_ bv7 4))) 1))
; 15 * 15 = 225, and 225 mod 16 = 1.
(assert (= (bv2nat (bvmul (_ bv15 4) (_ bv15 4))) 1))
(check-sat)
(pop 1)

; 7) bv2nat commutes with multiplication when there is no overflow (width 8).
(push 1)
(declare-fun x_mno () (_ BitVec 8))
(declare-fun y_mno () (_ BitVec 8))
(assert
  (let ((prod (+ (ite (= ((_ extract 0 0) y_mno) #b1) (bv2nat x_mno) 0)
                 (ite (= ((_ extract 1 1) y_mno) #b1) (* 2 (bv2nat x_mno)) 0)
                 (ite (= ((_ extract 2 2) y_mno) #b1) (* 4 (bv2nat x_mno)) 0)
                 (ite (= ((_ extract 3 3) y_mno) #b1) (* 8 (bv2nat x_mno)) 0)
                 (ite (= ((_ extract 4 4) y_mno) #b1) (* 16 (bv2nat x_mno)) 0)
                 (ite (= ((_ extract 5 5) y_mno) #b1) (* 32 (bv2nat x_mno)) 0)
                 (ite (= ((_ extract 6 6) y_mno) #b1) (* 64 (bv2nat x_mno)) 0)
                 (ite (= ((_ extract 7 7) y_mno) #b1) (* 128 (bv2nat x_mno)) 0))))
    (and (<= prod 255)
         (not (= (bv2nat (bvmul x_mno y_mno)) prod)))))
(check-sat)
(pop 1)

; 7b) Concrete examples where multiplication does not overflow (width 8).
(push 1)
(assert (= (bv2nat (bvmul (_ bv15 8) (_ bv17 8))) 255))
(assert (= (bv2nat (bvmul (_ bv13 8) (_ bv19 8))) 247))
(assert (= (bv2nat (bvmul (_ bv2 8) (_ bv127 8))) 254))
(check-sat)
(pop 1)
