//::///////////////////////////////////////////////
//:: Tyrant Fog Zombie Mist Heartbeat
//:: NW_S1_TyrantFgA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the area around the zombie
    must save or take 1 point of Constitution
    damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
    effect eTest;
    eCon = ExtraordinaryEffect(eCon);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eCon, eDur);
    int bAbsent = TRUE;
    if(!GetHasSpellEffect(SPELLABILITY_TYRANT_FOG_MIST, oTarget))
    {
        if(bAbsent == TRUE)
        {
            if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TYRANT_FOG_MIST));
                //Make a saving throw check
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_POISON))
                {
                    //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
                }
            }
        }
    }
}
