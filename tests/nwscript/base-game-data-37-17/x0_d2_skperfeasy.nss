/* EASY check for skill perform */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_PERFORM, GetPCSpeaker());
}
