//::///////////////////////////////////////////////
//:: Dragon Breath Weaken
//:: NW_S1_DragWeak
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:: Updated On: Oct 21, 2003
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nDamage;
    int nDC;
    float fDelay;
    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    //Determine save DC and ability damage
    if (nAge <= 6) //Wyrmling
    {
        nDamage = 1;
        nDC = 15;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage = 2;
        nDC = 18;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage = 3;
        nDC = 19;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage = 4;
        nDC = 22;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage = 5;
        nDC = 24;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDamage = 6;
        nDC = 25;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDamage = 7;
        nDC = 28;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage = 8;
        nDC = 30;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage = 9;
        nDC = 33;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage = 10;
        nDC = 35;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamage = 11;
        nDC = 38;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamage = 12;
        nDC = 40;
    }
    PlayDragonBattleCry();
    effect eBreath = EffectAbilityDecrease(ABILITY_STRENGTH, nDamage);
    eBreath = ExtraordinaryEffect(eBreath);
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_WEAKEN));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Make a saving throw check
            if(!/*ReflexSave*/MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

                //--------------------------------------------------------------
                //GZ: Bug fix
                //--------------------------------------------------------------
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBreath, oTarget));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    }
}


