/* HARD check for skill move_silently */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_HARD, SKILL_MOVE_SILENTLY, GetPCSpeaker());
}
