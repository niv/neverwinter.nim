/* HARD check for skill listen */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_LISTEN, GetPCSpeaker());
}
