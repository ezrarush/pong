;;;; pong.asd

(asdf:defsystem #:pong
  :serial t
  :description "Modern Opengl networked pong"
  :author "Ezra Rush <rushwest@gmail.com>"
  :license "The MIT License (MIT) Copyright (c) 2014 Ezra Rush"
  :depends-on (#:sb-cga
	       #:cl-opengl
	       #:sdl2
	       #:usocket
               #:userial)
  :components ((:file "package")
	       (:file "paddle")
	       (:file "ball")
	       (:module "graphics"
			:components ((:file "utils")
				     (:file "camera")
				     (:file "pipeline")
				     (:file "technique")
				     (:file "color-technique")
				     (:file "primative")))
	       (:module "network"
			:components ((:file "common")
				     (:file "server")
				     (:file "client")))
	       (:file "graphics-engine")
               (:file "pong")))

