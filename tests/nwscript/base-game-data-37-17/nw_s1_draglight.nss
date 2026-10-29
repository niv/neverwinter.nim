//::///////////////////////////////////////////////
//:: Dragon Breath Lightning
//:: NW_S1_DragLightn
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
    //Determine the HD of the monster
    int nAge = GetHitDice(OBJECT_SELF);
    int nDamage;
    int nDC;
    //Use the HD of the creature to determine damage and save DC
    if (nAge <= 6) //Wyrmling
    {
        nDamage = d8(2);
        nDC = 14;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage = d8(4);
        nDC = 16;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage = d8(6);
        nDC = 18;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage = d8(8);
        nDC = 20;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage = d8(10);
        nDC = 23;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDamage = d8(12);
        nDC = 25;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDamage = d8(14);
        nDC = 27;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage = d8(16);
        nDC = 29;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage = d8(18);
        nDC = 31;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage = d8(20);
        nDC = 33;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamage = d8(22);
        nDC = 36;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamage = d8(24);
        nDC = 37;
    }
    PlayDragonBattleCry();
    //Declare major variables
    //effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF,BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage;
    object oTarget;
    int nDamStrike = nDamage;
    float fDelay;

    int nCnt;
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget) && nCnt < nAge)
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_CONE_LIGHTNING));
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY, OBJECT_SELF, fDelay))
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
            if(nDamStrike > 0)
            {
                //Set the damage effect
                eDamage = EffectDamage(nDamStrike, DAMAGE_TYPE_ELECTRICAL);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation());
    }
}


