//::///////////////////////////////////////////////
//::
//:: Evil, low-level, summoner
//::
//:: NW_CD_EvSummon3.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Cleric that does a lot of summoning.
//::
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 17, 2001
//::
//:://////////////////////////////////////////////
#include "NW_I0_PLOT"

void main()
{
    if (GetDistanceToObject(GetNearestPC()) < 7.0)
    {
        ActionCastSpellAtObject(SPELL_ANIMATE_DEAD, GetNearestPC());
    }
}
