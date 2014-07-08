#Description

Modern Opengl networked pong based on https://github.com/fisxoj/pnong.

#How to Run

##SBCL on Windows

Install SBCL and Quicklisp in C:\home\ (https://www.youtube.com/watch?v=VnWVu8VVDbI)

Download this repository and place it in C:\home\quicklisp\local-projects\.  

Shader paths are hard coded to this home folder (e.g. c:/home/quicklisp/local-projects/pong/shaders/shader.vertexshadr).

SBCL does not have a safe way to interrupt a thread and cl-sdl2 must run on the main thread. Here is the work around found at https://github.com/lispgames/cl-sdl2/issues/23

###Server

Run the following from the SBCL shell and not as an inferior-lisp in emacs.

```lisp
(ql:quickload "pong")
; (ql:quickload "swank")
; (bt:make-thread (lambda () (swank:create-server :port 4005 :dont-close t)))
(sdl2:make-this-thread-main (lambda () (pong:main)))
```

You may use slime with this SBCL image by uncommenting the two swank lines and executing the command "slime-connect" in emacs.

###Client

Run the following in a second SBCL instance shell.

```lisp

(ql:quickload "pong")
(sdl2:make-this-thread-main (lambda () (pong:main nil "127.0.0.1")))
```

If the client is on a different host than the server, use the server's ip address instead of the home address "127.0.0.1".