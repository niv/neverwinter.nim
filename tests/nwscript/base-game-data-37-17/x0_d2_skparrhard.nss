/* HARD check for skill parry */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_PARRY, GetPCSpeaker());
}
