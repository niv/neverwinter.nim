//::///////////////////////////////////////////////
//:: Stink Beetle OnDeath Event
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Releases the Stink Beetle's Stinking Cloud
    special ability OnDeath.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew
//:: Created On: Jan 2002
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_MOB_TYRANT_FOG,"NW_S1_Stink_A");
    location lTarget = GetLocation(OBJECT_SELF);

    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(2));
}



