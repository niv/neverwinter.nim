/* EASY check for skill spellcraft */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_EASY, SKILL_SPELLCRAFT, GetPCSpeaker());
}
