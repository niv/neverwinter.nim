/* EASY check for skill parry */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_PARRY, GetPCSpeaker());
}
