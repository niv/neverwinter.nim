//::///////////////////////////////////////////////
//:: Neutralize Poison
//:: NW_S0_NeutPois.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all poison effects from the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 3, 2001

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nType;
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    //Get the first effect on the target
    effect ePoison = GetFirstEffect(oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEUTRALIZE_POISON, FALSE));
    while(GetIsEffectValid(ePoison))
    {
        //Check to see if the effect is type poison
        if (GetEffectType(ePoison) == EFFECT_TYPE_POISON)
        {
            //Remove poison effect and apply VFX constant
            RemoveEffect(oTarget, ePoison);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        //Get next effect on target
        GetNextEffect(oTarget);
    }
}

