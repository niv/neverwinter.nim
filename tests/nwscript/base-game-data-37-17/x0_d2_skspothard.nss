/* HARD check for skill spot */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_SPOT, GetPCSpeaker());
}
