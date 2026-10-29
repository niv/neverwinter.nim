/* EASY check for skill hide */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_HIDE, GetPCSpeaker());
}
