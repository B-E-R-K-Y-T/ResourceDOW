macroScript ErcoDisclaimer
enabledIn:#("viz")
buttontext:"ERCO Disclaimer"
category:"Disclaimers" 
internalCategory:"Disclaimers" 
tooltip:"ERCO Disclaimer" 
icon:#("Erco-DiscIcon", 1)
(
	rollout rDisclaimer "Disclaimer" width:350
	(
		label ContentTop "" height:80 width:320 pos:[20,20]
		hyperlink mLink "http://www.erco.com" address:"http://www.erco.com" color:blue pos:[30,100]
		label ContentBottom "" height:100 width:300 pos:[20,120]
		
		on rDisclaimer open do
		(
			ContentTop.text = "The lamps contained, shown and described in this library have " +
							  "been developed by and are manufactured by ERCO Leuchten GmbH. " +
							  "Whether these lamps are available in any specific country or any " +
							  "specific configuration shall be determined from the ERCO Leuchten GmbH web site"			
			
			ContentBottom.text = "or by directly contacting ERCO Leuchten GmbH at Postfach 2460, 58505 Lüdenscheid, Germany. \n\n" +

								"The incorporation or illustration of lamps in this library is not an offer of sale, or indication of availability for sale or an inducement to buy or use any such lamp by ERCO Leuchten GmbH or Autodesk Inc."
		)
	)
	on execute do
	(
		createDialog rDisclaimer modal:true	
	)
)
