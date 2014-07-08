
;;;; pong.lisp
(declaim (optimize (debug 3) (speed 1) (safety 3)))

(in-package #:pong)

(defparameter *window-width* 800)
(defparameter *window-height* 600)
(defparameter *step-scale* 5.0)

(defvar *last-time*)
(defvar *current-time*)
(defvar *delta-time*)

(defvar *paddle-one* nil)
(defvar *paddle-two* nil)
(defvar *ball* nil)

(defvar *graphics-engine*)

(defun main (&optional (server-p t) (server-ip))
  (sdl2:with-init (:everything)
    (format t "Using SDL Library Version: ~D.~D.~D~%"
            sdl2-ffi:+sdl-major-version+
            sdl2-ffi:+sdl-minor-version+
            sdl2-ffi:+sdl-patchlevel+)
    (finish-output)

    (setf *paddle-one* (make-instance 'paddle :player :one))
    (setf *paddle-two* (make-instance 'paddle :player :two))
    (setf *ball* (make-instance 'ball))
    
    (setf *server* server-p)
    (if (server-p)
	(start-server)
	(connect-to-server server-ip))
    

    (sdl2:with-window (win :title (if (server-p) "Pong Server" "Pong Client") :w *window-width* :h *window-height* :flags '(:shown :opengl))
      (sdl2:with-gl-context (gl-context win)
	(sdl2:gl-make-current win gl-context)
	
	(setf *graphics-engine* (make-instance 'graphics-engine))
	(graphics-init *graphics-engine*)
	(setf *last-time* (sdl2:get-ticks))
	
	(unwind-protect
	     (sdl2:with-event-loop (:method :poll)
	       (:keydown
		(:keysym keysym)
		(let ((scancode (sdl2:scancode-value keysym))
		      (sym (sdl2:sym-value keysym))
		      (mod-value (sdl2:mod-value keysym)))
		  (cond
		    ((sdl2:scancode= scancode :scancode-up)
		     (move-up))
		    ((sdl2:scancode= scancode :scancode-down)
		     (move-down)))
		  (unless (server-p)
		    (delta-update (player-paddle)))))

	       (:windowevent (:event e :data1 x :data2 y)
			     (when (eql e sdl2-ffi:+sdl-windowevent-resized+)
			       (reshape x y)))

	       (:idle ()
		      (setf *current-time* (sdl2:get-ticks))
		      (setf *delta-time* (ensure-float (- *current-time* *last-time*)))
		      		      
		      (when (>= *delta-time* 10.0)
			(when (and (server-p) (connected-p)) (move-ball))
			(incf *last-time* 10))

		      (network)
		      (when (connected-p)

			(render-scene *graphics-engine*)
			(sdl2:gl-swap-window win)
			))

		(:quit () t))
	   (if (server-p)
	       (stop-server)
	       (disconnect-from-server)))))))

(defun move-ball ()
  (flet ((flip-x (ball)
	   (setf (aref (velocity ball) 0)
		 (- (aref (velocity ball) 0))))
	 (flip-y (ball)
	   (setf (aref (velocity ball) 1)
		 (- (aref (velocity ball) 1)))))

    (cond
      ;; Hit a paddle?
      
      ;; Left Paddle
      ((and (<= (aref (ball-position *ball*) 0)
		(+ -390 (/ +paddle-width+ 2) +ball-radius+))
            (< (aref (ball-position *ball*) 1)
      	 (+ (paddle-position *paddle-one*)
      	    (/ +paddle-height+ 2)))
            (> (aref (ball-position *ball*) 1)
      	 (- (paddle-position *paddle-one*)
      	    (/ +paddle-height+ 2))))
       (flip-x *ball*))

      ;; Right paddle
      ((and (>= (aref (ball-position *ball*) 0)
		(- 390 (/ +paddle-width+ 2) +ball-radius+))
            (< (aref (ball-position *ball*) 1)
	       (+ (paddle-position *paddle-two*)
		  (/ +paddle-height+ 2)))
            (> (aref (ball-position *ball*) 1)
	       (- (paddle-position *paddle-two*)
		  (/ +paddle-height+ 2))))
       (flip-x *ball*))

      ;; Hit a wall?

					; left
      ((<= (aref (ball-position *ball*) 0) (+ -390 +ball-radius+))
       (flip-x *ball*)
       (setf (aref (ball-position *ball*) 0) 0)
       (setf (aref (ball-position *ball*) 1) 0))

					; right
      ((>= (aref (ball-position *ball*) 0) (- 390 +ball-radius+))
       (flip-x *ball*)
       (setf (aref (ball-position *ball*) 0) 0)
       (setf (aref (ball-position *ball*) 1) 0))

					; top
      ((<= (aref (ball-position *ball*) 1) -300)
       (flip-y *ball*))

					; bottom
      ((>= (aref (ball-position *ball*) 1) 300)
       (flip-y *ball*))))
  
  (dotimes (i 2)
    (incf (aref (ball-position *ball*) i) (aref (velocity *ball*) i))))

