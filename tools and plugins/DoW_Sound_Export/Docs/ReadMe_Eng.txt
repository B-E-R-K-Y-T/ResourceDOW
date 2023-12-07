===[ FDA <=> AIFC converter v1.0 by jTommy

General discription
  This console program converts FDA files from "W40k: Dawn of War" and "W40k:
  Winter Assault" game to "Homeworld II" AIFC files. AIFC files can be played
  using Winamp with Relic In_AIFx plugin (http://www.winamp.com/plugins/details.php?id=272).
  Just rename those files extenitions to .aif or .aifc or .aifr. You can also
  convert them to WAV. Delphi sources are included.

How to convert
  First you need to convert DoW FDA files using command "fda2aifc.exe filename.fda"
  or "fda2aifc.exe *.fda" This will create files with .aifc extenition. You can
  already play them with Winamp.
  Now you can decode AIFC files to WAVs: "dec.exe filename.aifc filename.wav".
  Or, if you need to convert many files in one instance use "decShell.exe *.aifc".
  decShell.exe is a console shell for dec.exe, and it supports filename masks.
  Use aifc2fda converter for converting AIFC files back to FDA files.

Files in the archive
  fda2aifc.exe - Converter FDA => AIFC.
  aifc2fda.exe - Converter AIFC => FDA.
  dec.exe - The official decoder AIFC => WAV, from Relic Entertainment Inc.
  enc.exe - The official coder WAV => AIFC, from Relic Entertainment Inc.
  decShell.exe - The console shell for the decoder, it supports filename masks.
                 (for example *.fda, *.* etc.). If need to convert many files
                 in one instance.
  encShell.exe - Same, only for the coder.
  fda2aifc_src.zip - Delphi sources.

Contacts
  E-mail: jTommy@zmail.ru
  WWW   : ...
