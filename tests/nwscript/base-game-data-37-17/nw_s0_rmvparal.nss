//::///////////////////////////////////////////////
//:: Remove Paralysis
//:: NW_S0_RmvParal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes the paralysis and hold effects from the
    targeted creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 20, 2002
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    int nType;
    effect eParal;
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
    int nCnt = 0;
    int nRemove = GetCasterLevel(OBJECT_SELF) / 4;
    nRemove += 1;
    float fDelay;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Get the first effect on the target
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget) && nCnt <= nRemove)
    {
        if(GetIsFriend(oTarget))
        {
            fDelay = GetRandomDelay();
            eParal = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eParal))
            {
                //Check if the current effect is of correct type
                if (GetEffectType(eParal) == EFFECT_TYPE_PARALYZE)
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_PARALYSIS, FALSE));

                    //Remove the effect and apply VFX impact
                    RemoveEffect(oTarget, eParal);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    nCnt++;
                }
                //Get the next effect on the target
                eParal = GetNextEffect(oTarget);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }
}
