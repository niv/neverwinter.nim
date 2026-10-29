/* MEDIUM check for skill taunt */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_TAUNT, GetPCSpeaker());
}
