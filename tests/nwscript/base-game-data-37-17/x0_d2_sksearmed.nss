/* MEDIUM check for skill search */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_SEARCH, GetPCSpeaker());
}
