/* HARD check for skill heal */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_HEAL, GetPCSpeaker());
}
