#Description

Modern Opengl networked pong.

#How to Run

##SBCL on Windows

Install SBCL and Quicklisp in C:\home\ (https://www.youtube.com/watch?v=VnWVu8VVDbI)

Download this repository and place it in your quicklisp\local-projects\ folder so that quicklisp can find it.  

###Player One (Server)

Run the following in the command line from the project folder:

```
sbcl --load run-server.lisp
```

###Player Two (Client)

Run the following in the command line from the project folder:

```
sbcl --load run-client.lisp
```

If the client is on a different host than the server, use the server's ip address instead of the loop back address "127.0.0.1" inside the run-client.lisp file.

###Note on Emacs Slime

As Zulu-Inuoe commented in this [thread](https://github.com/lispgames/cl-sdl2/issues/23), when Emacs launches SBCL for Slime on Windows, it specifies that SBCL be launched in SW_HIDE (so you don't see the console for SBCL but this also hides the window SDL creates).

###References

Based on [Pnong](https://github.com/fisxoj/pnong)

