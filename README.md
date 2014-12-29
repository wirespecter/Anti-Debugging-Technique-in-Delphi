Anti-Debug-Technique-in-Delphi
==============================

This is an anti debugging technique made in delphi. <br> <br>
Techniques like this are often used by programs that are designed to make reverse engineering harder. <br> <br>
In this case, the program checks the parent process' name, if the name is "explorer.exe" or "cmd.exe" the program continues, otherwise it kills the potential debugger program that run it.
