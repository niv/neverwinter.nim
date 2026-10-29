/* EASY check for skill move_silently */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_MOVE_SILENTLY, GetPCSpeaker());
}
