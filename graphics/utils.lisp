(in-package #:pong)

(defun file->string (path)
  (with-open-file (s path)
    (let* ((len (file-length s))
           (data (make-string len)))
      (values data (read-sequence data s)))))

;; from clinch
(defun ensure-float (x)
  (coerce x 'single-float))

;; from glm
(defun look-at (eye center up)
  (let* ((f (sb-cga:normalize (sb-cga:vec- center eye)))
	(s (sb-cga:normalize (sb-cga:cross-product f (sb-cga:normalize up))))
	(u (sb-cga:cross-product s f)))
    (sb-cga:matrix (aref s 0)                     (aref s 1)                     (aref s 2)             (- (sb-cga:dot-product s eye))
		   (aref u 0)                     (aref u 1)                     (aref u 2)             (- (sb-cga:dot-product u eye))
		   (- (aref f 0))                 (- (aref f 1))                 (- (aref f 2))         (sb-cga:dot-product f eye)             
		   0.0                            0.0                            0.0                    1.0)))

;; from glm
(defun ortho (left right bottom top z-near z-far)
  (sb-cga:matrix (/ 2.0 (- right left)) 0.0                     0.0                          (- (/ (+ right left) (- right left)))
		 0.0                    (/ 2.0 (- top bottom))  0.0                          (- (/ (+ top bottom) (- top bottom)))
		 0.0                    0.0                     (- (/ 2.0 (- z-far z-near))) (- (/ (+ z-far z-near) (- z-far z-near)))
		 0.0                    0.0                     0.0                          1.0))
