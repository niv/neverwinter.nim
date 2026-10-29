//::///////////////////////////////////////////////
//:: GreaterWildShape III - Drider Darkness Ability
//:: x2_s2_driderdark
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

  Drider Darkness Ability for polymorph type
  drider

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////

#include "x2_inc_shifter"
void main()
{
    //--------------------------------------------------------------------------
    // Enforce artifical use limit on that ability
    //--------------------------------------------------------------------------
    if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
    {
        FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
        return;
    }

    //--------------------------------------------------------------------------
    // Create an darkness AOE object for 6 rounds
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    location lTarget = GetSpellTargetLocation();
    int nDuration = 6;
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}





