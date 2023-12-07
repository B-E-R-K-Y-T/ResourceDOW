===[ fda2aifc converter v1.0 by jTommy
===[ ENG
General discription:
  This small program converts FDA files from "Warhammer 40000: Dawn of War"
  game to "Homeworld II" AIFC files. AIFC files can be played using Winamp
  with Relic In_AIFx plugin (http://www.winamp.com/plugins/details.php?id=272).
  Just rename those files extenitions to .aif or .aifc or .aifr. You can also
  convert them to WAV. Delphi sources are included.
How to use:
  First you need to convert DoW FDA files using command "fda2aifc.exe filename.fda"
  or "fda2aifc.exe *.fda" This will create files with .aifc extenition. You can
  already play them with Winamp.
  Now you can decode AIFC files to WAVs: "dec.exe filename.aifc filename.wav".
  Or, if you need to convert many files in one instance use "decShell.exe *.aifc".
  decShell.exe is a console shell for dec.exe, and it supports filename masks.
Files in this archive:
  dec.exe - The official decoder AIFR => WAV, from Relic Entertainment Inc.
  enc.exe - The official coder WAV => AIFR, from Relic Entertainment Inc.
  decShell.exe - The console shell for the decoder, it supports filename masks.
                 (for example *.fda, *.* etc.). If need to convert many files
                 in one instance.
  encShell.exe - Same, only for the coder.
  fda2aifc.exe - Itself converter.
  fda2aifc_src.zip - Delphi sources.
  ReadMe.txt - File, which you read.
Contacts:
  E-mail: jTommy@rambler.ru
  WWW   : I do not remember...

===[ RUS
Общее описание:
  Эта маленькая программа конвертирует звуковые FDA файлы из  игры
  "Warhammer 40000: Dawn of War" в AIFC файлы игры "Homeworld II".
  AIFC файлы  можно сразу слушать  в Winamp'е, с  помощью  плагина
  In_AIFx (http://www.winamp.com/plugins/details.php?id=272).
  Или декодировать в несжатые WAV. Исходники на Дельфи прилагаются.
Как пользоваться:
  Запускаете,  например,  так: "fda2aifc *.fda",  ждете, пока  она
  сконвертирует  все  FDA файлы  в текущей  директории. Полученные
  файлы (с расширением .aifc) слушаете в  Winamp или конвертируете
  в WAV: "decShell *.aifc".
Файлы в этом архиве:
  dec.exe - Официальный декодер AIFR => WAV, от Relic Entertainment Inc.
  enc.exe - Официальный кодер WAV => AIFR, от Relic Entertainment Inc.
  decShell.exe - Оболочка для декодера, поддерживает файловые маски.
                 (например *.fda, *.* и т.п.). Написана для удобства
                 декодирования большого кол-ва файлов.
  encShell.exe - То же самое, только для кодера.
  fda2aifc.exe - Сам конвертер.
  fda2aifc_src.zip - Исходники на Дельфи.
  ReadMe.txt - Файл, который вы читаете.
Контакты:
  E-mail: jTommy@rambler.ru
  WWW   : не помню...
