//::///////////////////////////////////////////////
//:: Aura of Protection: On Exit
//:: NW_S1_AuraProtB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Acts as a double strength Magic Circle against
    evil and a Minor Globe for those friends in
    the area.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:Jan 8, 2002, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    RemoveSpellEffects(SPELLABILITY_AURA_PROTECTION, GetAreaOfEffectCreator(), GetExitingObject());
}

