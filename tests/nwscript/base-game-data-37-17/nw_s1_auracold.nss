//::///////////////////////////////////////////////
//:: Aura of Cold
//:: NW_S1_AuraCold.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Prolonged exposure to the aura of the creature
    causes cold damage to all within the aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

void main()
{
    //Set and apply AOE effect
    effect eAOE = EffectAreaOfEffect(AOE_MOB_FROST);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
