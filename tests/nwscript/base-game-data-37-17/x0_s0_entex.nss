//::///////////////////////////////////////////////
//:: x0_s0_entEX
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes a miss chance to any enemies
    of the area of effect creator.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_spells"
void main()
{
    object oTarget = GetEnteringObject();
	if(!GetIsReactionTypeFriendly(oTarget, GetAreaOfEffectCreator()))
	{
        RemoveSpellEffects(SPELL_ENTROPIC_SHIELD, GetAreaOfEffectCreator(), oTarget);
    }
}
