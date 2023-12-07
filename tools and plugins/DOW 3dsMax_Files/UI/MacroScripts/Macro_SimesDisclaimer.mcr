macroScript SimesDisclaimer
enabledIn:#("viz")
buttontext:"Simes Disclaimer"
category:"Disclaimers" 
internalCategory:"Disclaimers" 
tooltip:"Simes Disclaimer" 
icon:#("Simes-DiscIcon", 1)
(
	rollout rDisclaimer "Disclaimer" width:350
	(
		label ContentTop "" height:60 width:300 pos:[20,20]
		hyperlink mLink "http://www.simes.it" address:"http://www.simes.it" color:blue pos:[30,80]
		label ContentBottom "" height:25 width:300 pos:[20,100]
		
		on rDisclaimer open do
		(
			ContentTop.text = "SIMES S.p.A. is not answerable for any problems caused by " +
							"the use of its 3D files and photometries, as they are only for " +
							"information and can always be updated. We recommend you to " +
							"take as a point of reference our web site"
							
			ContentBottom.text = "to download the latest updated versions." 
		)
	)
	on execute do
	(
		createDialog rDisclaimer modal:true	
	)
)
