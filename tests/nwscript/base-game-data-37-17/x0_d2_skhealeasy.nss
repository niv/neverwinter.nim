/* EASY check for skill heal */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_HEAL, GetPCSpeaker());
}
