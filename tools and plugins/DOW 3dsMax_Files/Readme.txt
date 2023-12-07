Santos' Tools
by Brother Santos

Version 0.4


I. Installation

Copy 'scripts', 'UI' and 'help' folders from this archive into your 3d studio max directory (eg. C:\3dsmax7). 

In order to be able view help inside 3dsmax add following line into plugin.ini file placed in your 3dsmax main directory:

Santos Tools Help=C:\3dsmax7\help\santos_tools.chm 

(change path accordingly to your 3dsmax installation directory)

Than you can open this file in max by selecting Help->Additional Help... and choosing 'Santos Tools Help' from the list.

Note!
If you used previous version of the scripts delete following files from your max scripts/startup directory:
- WHMImportDEV.ms
- WHEConvertDEV.ms
- XREFToolDEV.ms

II. Preparation

In order for the scripts to work properly you should do the following:

a) Extract W40kData-Whm-High.sga (W40K) and/or WXPData-Whm-High.sga (WXP) into any [mod]\Data directory inside your Dawn of War installation directory (eg. C:\Program Files\Dawn of War\My_Mod\Data). The mod directory you choose should be later set in WHM Import script by pressing SetModDir button.

b) Extract textures from RSH files with Spooky's RSH Tool, flip them vertically, save as TGA and put in Texture Share folders inside X:\[Dawn of War Dir]\ModTools\DataSrc\[Mod]\Art\EBPs (eg. for Space Marines & My_Mod - C:\Program Files\Dawn of War\ModTools\DataSrc\My_Mod\Art\EBPs\Races\Space_Marines\Texture_Share). 

This step is not necessery - you can extract textures later - but if script won't be able to find textures while importing animations, 3dsmax will prompt for them for each newly created file. Take my advice and extract them before importing model ;)

III. Known bugs

- Script is not importing smoothing groups. 
- There are various problems with importing following models:
	- heretic - 1 marker is not linked
	- commissar - 3rd left cape bone is reversed
		    - there are some errors with vertex weights
	- desecrated_stronghold - causes script to crash
- Several models have some issues with vertex weights which will cause problems when exporting with Relic Tools. You can fix them by hand in REF.MAX file and than use 'Fix Skin' utility from WHM Import script to correct skin in animation files.
- Some animations (especially 'aim' animations) might not work properly. You should fix them by hand. Applying 'TCB Rotation' controller will usually do the trick.
- Internal textures can now be imported but they are saved as rsh files and need to be converted with Spooky's Tool. Also in such a case meshes may have assigned incorrect materials. This needs to by corrected manually.

Please report all bugs to: brother_santos@poczta.fm