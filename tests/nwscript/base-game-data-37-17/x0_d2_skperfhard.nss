/* HARD check for skill perform */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_PERFORM, GetPCSpeaker());
}
