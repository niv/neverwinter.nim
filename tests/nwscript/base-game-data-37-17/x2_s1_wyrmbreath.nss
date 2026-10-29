//::///////////////////////////////////////////////
//:: Dragon Breath for Wyrmling Shape
//:: x2_s2_dragbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the power of the dragon breath
    used by a player polymorphed into wyrmling
    shape

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: June, 17, 2003
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_shifter"

void main()
{

    //--------------------------------------------------------------------------
    // Set up variables
    //--------------------------------------------------------------------------
    int nType = GetSpellId();
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nSpell;
    int nDice;

    //--------------------------------------------------------------------------
    // Decide on breath weapon type, vfx based on spell id
    //--------------------------------------------------------------------------
    switch (nType)
    {
        case 663: //white
            nDamageDie  = 4;
            nDamageType = DAMAGE_TYPE_COLD;
            nVfx        = VFX_IMP_FROST_S;
            nSave       = SAVING_THROW_TYPE_COLD;
            nSpell      = SPELLABILITY_DRAGON_BREATH_COLD;
            nDice       = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /2)+1;
            break;

        case 664: //black
            nDamageDie  = 4;
            nDamageType = DAMAGE_TYPE_ACID;
            nVfx        = VFX_IMP_ACID_S;
            nSave       = SAVING_THROW_TYPE_ACID;
            nSpell      = SPELLABILITY_DRAGON_BREATH_ACID;
            nDice       = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /2)+1;
            break;

        case 665: //red
            nDamageDie   = 10;
            nDamageType  = DAMAGE_TYPE_FIRE;
            nVfx         = VFX_IMP_FLAME_M;
            nSave        = SAVING_THROW_TYPE_FIRE;
            nSpell       = SPELLABILITY_DRAGON_BREATH_FIRE;
            nDice        = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /3)+1;
            break;

        case 666: //green
            nDamageDie   = 6;
            nDamageType  = DAMAGE_TYPE_ACID;
            nVfx         = VFX_IMP_ACID_S;
            nSave        = SAVING_THROW_TYPE_ACID;
            nSpell       = SPELLABILITY_DRAGON_BREATH_GAS;
            nDice        = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /2)+1;
            break;

        case 667: //blue
            nDamageDie   = 8;
            nDamageType  = DAMAGE_TYPE_ELECTRICAL;
            nVfx         = VFX_IMP_LIGHTNING_S;
            nSave        = SAVING_THROW_TYPE_ELECTRICITY;
            nSpell       = SPELLABILITY_DRAGON_BREATH_LIGHTNING;
            nDice        = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /3)+1;
            break;

    }

    //--------------------------------------------------------------------------
    // Calculate Save DC based on shifter level
    //--------------------------------------------------------------------------
    int  nDC  = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_NORMAL);

    //--------------------------------------------------------------------------
    // Calculate Damage
    //--------------------------------------------------------------------------


    int nDamage;
    int nDamStrike;
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    //--------------------------------------------------------------------------
    //Loop through all targets and do damage
    //--------------------------------------------------------------------------
    location lFinalTarget = GetSpellTargetLocation();
    vector vFinalPosition;
    if ( lFinalTarget == GetLocation(OBJECT_SELF) )
    {
        // Since the target and origin are the same, we have to determine the
        // direction of the spell from the facing of OBJECT_SELF (which is more
        // intuitive than defaulting to East everytime).

        // In order to use the direction that OBJECT_SELF is facing, we have to
        // instead we pick a point slightly in front of OBJECT_SELF as the target.
        vector lTargetPosition = GetPositionFromLocation(lFinalTarget);
        vFinalPosition.x = lTargetPosition.x +  cos(GetFacing(OBJECT_SELF));
        vFinalPosition.y = lTargetPosition.y +  sin(GetFacing(OBJECT_SELF));
        lFinalTarget = Location(GetAreaFromLocation(lFinalTarget),vFinalPosition,GetFacingFromLocation(lFinalTarget));
    }

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, lFinalTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            switch ( nDamageDie )
            {
                case 4:
                    nDamage = d4(nDice);
                    break;
                case 6:
                    nDamage = d6(nDice);
                    break;
                case 8:
                    nDamage = d8(nDice);
                    break;
                case 10:
                    nDamage = d10(nDice);
                    break;
            }
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSave);
            if (nDamStrike > 0)
            {
                eBreath = EffectDamage(nDamStrike, nDamageType);
                eVis = EffectVisualEffect(nVfx);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, lFinalTarget, TRUE);
    }
}





