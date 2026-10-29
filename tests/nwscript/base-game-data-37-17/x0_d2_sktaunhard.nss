/* HARD check for skill taunt */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_TAUNT, GetPCSpeaker());
}
