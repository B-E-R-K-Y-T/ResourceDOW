macroScript TrackBarToggle
	category:"Custom Tools"
	toolTip:"Toggle Track Bar"
	icon:#("MergeAnim",1)
(
	if trackbar.filter == #all then trackbar.filter = #currentTM else trackbar.filter = #all
)
