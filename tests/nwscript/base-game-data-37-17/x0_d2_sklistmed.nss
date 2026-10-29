/* MEDIUM check for skill listen */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_LISTEN, GetPCSpeaker());
}
