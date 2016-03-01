This project is intended to create for emacs a mode specifically designed for Google Wave.  The major parts of this project are the Java-based backend that connects to the server, and the emacs elisp code that connects to that backend and exchanges data with it, and the emacs UI for interacting with Wave.

Status:  This is pre-alpha software, in which we are working to build a complete Wave client in Emacs.  We have a basic read-only view which supports the undocumented client/server protocol currently in use by most wave instances, and the official client/server protocol in use by FedOne.

The official protocol can receive streaming updates, and updates are implemented but not yet fully working.

NOTE: Due to the cancellation of the Wave project, this project will no longer be developed.