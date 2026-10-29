//::///////////////////////////////////////////////
//:: Dragon Breath Slow
//:: NW_S1_DragSlow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nDC;
    int nCount;
    float fDelay;
    object oTarget;
    effect eBreath = EffectSlow();
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eBreath, eDur);


    //Determine save DC and duration
    if (nAge <= 6) //Wyrmling
    {
        nDC = 13;
        nCount = 1;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDC = 14;
        nCount = 2;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDC = 17;
        nCount = 3;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDC = 18;
        nCount = 4;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDC = 21;
        nCount = 5;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDC = 23;
        nCount = 6;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDC = 26;
        nCount = 7;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDC = 27;
        nCount = 8;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDC = 30;
        nCount = 9;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDC = 31;
        nCount = 10;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDC = 34;
        nCount = 11;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDC = 36;
        nCount = 12;
    }
    PlayDragonBattleCry();
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_SLOW));
            //Determine the effect delay time
            fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/20;
            //Make a saving throw check
            if(!/*ReflexSave*/MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount)));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    }
}


