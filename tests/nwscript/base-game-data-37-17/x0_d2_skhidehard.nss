/* HARD check for skill hide */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_HIDE, GetPCSpeaker());
}
