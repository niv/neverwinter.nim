/* MEDIUM check for skill perform */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_PERFORM, GetPCSpeaker());
}
