(in-package #:pong)

(defclass graphics-engine ()
  ((pipeline)
   (quad)
   (sphere)))

(defgeneric graphics-init (graphics-engine))
(defgeneric render-scene (graphics-engine))

(defmethod graphics-init ((tut graphics-engine))
  (with-slots (pipeline quad sphere ) tut

    (gl:clear-color 0.0 0.0 0.0 1.0)
    
    (setf pipeline (make-instance 'pipeline))
    
    ;; paddle
    (setf quad (make-instance 'quad))

    ;; ball 
    (setf sphere (make-instance 'sphere))))

(defmethod render-scene ((tut graphics-engine))
  (with-slots (pipeline quad sphere) tut
    
    (gl:clear :color-buffer-bit)
    
    ;; paddle size
    (setf (scale pipeline) (sb-cga:vec (ensure-float (/ +paddle-width+ 2)) (ensure-float (/ +paddle-height+ 2)) 1.0))

    ;; server's paddle (which is placed 10 units form half the negative window width i.e. the left wall) 
    (setf (world-pos pipeline) (sb-cga:vec (ensure-float (+ (/ (- *window-width*) 2) 10)) (ensure-float (paddle-position *paddle-one*)) 0.0))
    (update-transforms pipeline)
    (quad-render quad (projection-transform pipeline) (model-view-transform pipeline) (sb-cga:vec 0.0 1.0 0.0))
    
    ;; client's paddle (which is placed 10 units from half the positive window width i.e. the right wall)
    (setf (world-pos pipeline) (sb-cga:vec (ensure-float (- (/ *window-width* 2) 10)) (ensure-float (paddle-position *paddle-two*)) 0.0))
    (update-transforms pipeline)
    (quad-render quad (projection-transform pipeline) (model-view-transform pipeline) (sb-cga:vec 0.0 1.0 0.0))
    
    ;; ball
    (setf (scale pipeline) (sb-cga:vec (ensure-float +ball-radius+) (ensure-float +ball-radius+) (ensure-float +ball-radius+)))
    (setf (world-pos pipeline) (sb-cga:vec (ensure-float (aref (ball-position *ball*) 0)) (ensure-float (aref (ball-position *ball*) 1)) 0.0))
    (update-transforms pipeline)
    (sphere-render sphere (projection-transform pipeline) (model-view-transform pipeline) (sb-cga:vec 0.0 1.0 0.0))))
