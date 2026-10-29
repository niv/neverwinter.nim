//::///////////////////////////////////////////////
//:: Epic Dragon Breath
//:: x2_s2_edragbrth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.

    This spell is only intended to be used by the
    shifter's/druids dragon breath ability

    Druid's without at least 10 levels of shifter
    will do 4 dice damage less than a true shifter

    Green Dragon Gas also poisons the creatures
    to make up for its lower damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-Oct-14
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "X0_i0_spells"
#include "x2_inc_shifter"
void main()
{
    int nAge;
    int bShifter = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)>=10);
    int bPoison = FALSE;

/* This totally doesn't work right, GetHasFeat has been incorrectly used.
   If this is the last use per day of Dragon Shape, GetHasFeat will return 0
   because it is no longer useable. Therefore, the damage calculation will be wrong.
    // -------------------------------------------------------------------------
    // We assume this spell is only used in dragon form
    // -------------------------------------------------------------------------
    if (GetHasFeat(873,OBJECT_SELF))
    {
        nAge = GetLevelByClass(CLASS_TYPE_DRUID,OBJECT_SELF) +  GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF);
    }
    // -------------------------------------------------------------------------
    // .. this case should never happen, but people do strange things with
    //    the toolset
    // -------------------------------------------------------------------------
    else if (GetIsPC(OBJECT_SELF))
    {
        nAge = GetHitDice(OBJECT_SELF)/2;
    }
    else
    {
        nAge = GetHitDice(OBJECT_SELF);
    }
*/
    // This should work better.
    nAge = GetLevelByClass(CLASS_TYPE_DRUID,OBJECT_SELF) +  GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF);
    // Just in case...
    if (nAge==0)
    {
        if (GetIsPC(OBJECT_SELF))
        {
            nAge = GetHitDice(OBJECT_SELF)/2;
        }
        else
        {
            nAge = GetHitDice(OBJECT_SELF);
        }
    }

    int nDice;
    int nDamage;
    int nDamageDice;
    int nDC;
    // -------------------------------------------------------------------------
    // Your damage dice and save DC are dependent on your hit dice
    // -------------------------------------------------------------------------
    if (nAge <= 6) //Wyrmling
    {
        nDice = 1;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDice = 2;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDice = 4;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDice = 6;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDice = 8;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDice = 10;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDice = 12;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDice = 14;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDice = 16;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDice = 18;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDice = 20;
    }
    else if (nAge > 37 && nAge <40) //Great Wyrm
    {
        nDice = 22;
    }
    else
    {
        nDice = 24;
    }

    nDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_NORMAL,TRUE);

    if (!bShifter) // a shifter is a bit better at controlling this weapon
    {
       nDice -=4;
       nDC -=4;
    }

    int nSpellId= GetSpellId();
    int nVis;
    int nType;
    int nSave;

    if (nSpellId == 796) // lightning
    {
        nVis = VFX_IMP_LIGHTNING_S;
        nType = DAMAGE_TYPE_ELECTRICAL;
        nSave = SAVING_THROW_TYPE_ELECTRICITY;
        nDamageDice = 8;
    }
    else if (nSpellId == 797) // fire
    {
        nVis = VFX_IMP_FLAME_M;
        nType = DAMAGE_TYPE_FIRE;
        nSave = SAVING_THROW_TYPE_FIRE;
        nDamageDice = 10;
    }
    else //gas
    {
        nVis = VFX_IMP_POISON_L;
        nType = DAMAGE_TYPE_ACID;
        nSave = SAVING_THROW_TYPE_ACID;
        nDamageDice = 6;
        bPoison = TRUE;
    }

    effect eVis  = EffectVisualEffect(nVis);
    effect eDamage;
    effect ePoison;
    object oTarget;
    int nDamStrike;
    float fDelay;
     //------------------------------------------------------------------
    // Loop over all creatures, doors and placeables in the area of effect
    //------------------------------------------------------------------
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

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 15.0, lFinalTarget, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

            //------------------------------------------------------------------
            // Calculate and Apply Reflex Save Adjusted Damage
            //------------------------------------------------------------------
            switch ( nDamageDice )
            {
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
            nDamStrike = GetReflexAdjustedDamage(nDamage,oTarget, nDC,nSave, OBJECT_SELF);
            if(nDamStrike > 0)
            {

                eDamage = EffectDamage(nDamStrike, nType);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
            }

            //------------------------------------------------------------------
            // Green Dragon Breath is poisonous for creatures!
            //------------------------------------------------------------------
            if (bPoison && GetObjectType(oTarget) ==OBJECT_TYPE_CREATURE)
            {
               ePoison = EffectPoison(44);
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT,ePoison,oTarget));
            }
         }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 15.0, lFinalTarget, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
    }
}


