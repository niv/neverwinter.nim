/* EASY check for skill spot */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_SPOT, GetPCSpeaker());
}
