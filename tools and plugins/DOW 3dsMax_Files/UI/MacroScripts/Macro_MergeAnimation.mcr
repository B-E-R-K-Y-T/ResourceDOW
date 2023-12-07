macroScript mergeAnim 
enabledIn:#("max") --pfb: 2003.12.12 added product switch
ButtonText:"Merge Animation" 
category:"Animation Tools" 
internalCategory:"Animation Tools" 
tooltip:"Merge Animation" 
(
	on execute do
	(
		rMergeAnim.openDialog()
	)  
)