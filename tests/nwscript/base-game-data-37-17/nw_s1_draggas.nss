//::///////////////////////////////////////////////
//:: Dragon Breath Gas Cloud
//:: NW_S1_DragGas
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nDamage, nDC, nDamStrike;
    float fDelay;
    object oTarget;
    effect eVis, eBreath;
    //Use the HD of the creature to determine damage and save DC
    if (nAge <= 6) //Wyrmling
    {
        nDamage = d6(2);
        nDC = 13;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage = d6(4);
        nDC = 16;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage = d6(6);
        nDC = 17;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage = d6(8);
        nDC = 20;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage = d6(10);
        nDC = 22;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDamage = d6(12);
        nDC = 25;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDamage = d6(14);
        nDC = 26;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage = d6(16);
        nDC = 29;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage = d6(18);
        nDC = 30;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage = d6(20);
        nDC = 33;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamage = d6(22);
        nDC = 35;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamage = d6(24);
        nDC = 37;
    }
    PlayDragonBattleCry();
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Reset the damage to full
            nDamStrike = nDamage;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_GAS));
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ACID))
            {
                nDamStrike = nDamStrike/2;
                if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamStrike = 0;
                }
            }
            else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamStrike = nDamStrike/2;
            }
            if (nDamStrike > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nDamStrike, DAMAGE_TYPE_ACID);
                eVis = EffectVisualEffect(VFX_IMP_POISON_L);

                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    }
}

