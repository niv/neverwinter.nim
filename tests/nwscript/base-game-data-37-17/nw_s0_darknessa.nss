//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{

    int nMetaMagic = GetMetaMagicFeat();
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    object oTarget = GetEnteringObject();

    // * July 2003: If has darkness then do not put it on it again
    if (GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) == TRUE)
    {
        return;
    }

    if(GetIsObjectValid(oTarget) && oTarget != GetAreaOfEffectCreator())
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetEffectSpellId(eLink)));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetEffectSpellId(eLink), FALSE));
        }
        // Creatures immune to the darkness spell are not affected.
        if ( ResistSpell(OBJECT_SELF,oTarget) != 2 )
        {
            //Fire cast spell at event for the specified target
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
    }
    else if (oTarget == GetAreaOfEffectCreator())
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetEffectSpellId(eLink), FALSE));
        // Creatures immune to the darkness spell are not affected.
        if ( ResistSpell(OBJECT_SELF,oTarget) != 2 )
        {
            //Fire cast spell at event for the specified target
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
        }
    }
}
