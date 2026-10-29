//::///////////////////////////////////////////////
//:: Default: On Spawn In Die
//:: x2_spn_dead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in the creature dead - and doesn't get
    rid of the body...
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Nov 19/02
//:://////////////////////////////////////////////


void main()
{

    SetIsDestroyable(FALSE, TRUE, TRUE);
    effect eDamage = EffectDamage(500);
    effect eDeath = EffectDeath();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, OBJECT_SELF);

}


