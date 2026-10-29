/* MEDIUM check for skill spellcraft */

#include "nw_i0_plot" 

int StartingConditional()
{
	return AutoDC(DC_MEDIUM, SKILL_SPELLCRAFT, GetPCSpeaker());
}
