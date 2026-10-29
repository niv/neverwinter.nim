//::///////////////////////////////////////////////
//:: Pit Fiend Payload
//:: NW_S0_2PitFiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    DEATH --- DEATH --- BO HA HA HA
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////

void main()
{
    object oTarget = OBJECT_SELF;

    effect eDrain = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
