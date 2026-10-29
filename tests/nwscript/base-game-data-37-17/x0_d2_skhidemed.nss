/* MEDIUM check for skill hide */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_HIDE, GetPCSpeaker());
}
