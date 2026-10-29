//::///////////////////////////////////////////////
//:: Aura of Blinding
//:: NW_S1_AuraBlind.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be blinded because of the
    sheer ugliness or beauty of the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

void main()
{
    //Set the AOE effect and place it in the world.  The Aura abilities
    //are all permamnent and do not require recasting.
    effect eAOE = EffectAreaOfEffect(AOE_MOB_BLINDING);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
