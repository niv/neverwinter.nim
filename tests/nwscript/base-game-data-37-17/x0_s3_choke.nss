//::///////////////////////////////////////////////
//:: Choking Powder
//:: x0_s3_choke
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a stinking cloud where thrown for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
void main()
{

    //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGSTINK, "x0_s3_chokeen", "x0_s3_chokeHB", "");
    location lTarget = GetSpellTargetLocation();
    int nDuration = 5;
    effect eImpact = EffectVisualEffect(259);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

}

