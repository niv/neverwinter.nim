//::///////////////////////////////////////////////
//:: Cast Powerful Spells
//:: NW_CH_SPELL_1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All spell CR's double creatures (min 5)
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"

void main()
{
    SetAssociateState(NW_ASC_OVERKIll_CASTING, FALSE);
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_SCALED_CASTING, FALSE);
}
