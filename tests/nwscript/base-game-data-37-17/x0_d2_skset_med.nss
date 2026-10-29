/* MEDIUM check for skill set_trap */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_SET_TRAP, GetPCSpeaker());
}
