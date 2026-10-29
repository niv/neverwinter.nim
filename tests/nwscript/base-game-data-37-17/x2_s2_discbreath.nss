//::///////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

  Damage Type is Fire
  Save is Reflex
  Shape is cone, 30' == 10m

  Level      Damage      Save
  ---------------------------
  3          2d10         19
  7          4d10         19
  10          6d10        19

  after 10:
   damage: 6d10  + 1d10 per 3 levels after 10
   savedc: increasing by 1 every 4 levels after 10



*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: June, 17, 2003
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"


void main()
{
    int nType = GetSpellId();
    int nDamageDice;
    int nSaveDC = 19;

    int nLevel = GetLevelByClass(37,OBJECT_SELF);// 37 = red dragon disciple

    if (nLevel <7)
    {
        nDamageDice = 2;
    }
    else if (nLevel <10)
    {
        nDamageDice = 4;
    }
    else if (nLevel ==10)
    {
        nDamageDice = 6;
    }
    else
    {
      nDamageDice = 6+((nLevel -10)/3);
      nSaveDC = nSaveDC + ((nLevel -10)/4);
    }

    int nDamage = d10(nDamageDice);

    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    int nPersonalDamage;

    eVis = EffectVisualEffect(494);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetSpellTargetLocation());

    //Get first target in spell area
    location lFinalTarget = GetSpellTargetLocation();
    if ( lFinalTarget == GetLocation(OBJECT_SELF) )
    {
        // Since the target and origin are the same, we have to determine the
        // direction of the spell from the facing of OBJECT_SELF (which is more
        // intuitive than defaulting to East everytime).

        // In order to use the direction that OBJECT_SELF is facing, we have to
        // instead we pick a point slightly in front of OBJECT_SELF as the target.
        vector lTargetPosition = GetPositionFromLocation(lFinalTarget);
        vector vFinalPosition;
        vFinalPosition.x = lTargetPosition.x +  cos(GetFacing(OBJECT_SELF));
        vFinalPosition.y = lTargetPosition.y +  sin(GetFacing(OBJECT_SELF));
        lFinalTarget = Location(GetAreaFromLocation(lFinalTarget),vFinalPosition,GetFacingFromLocation(lFinalTarget));
    }
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lFinalTarget, TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE);

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE))
            {
                nPersonalDamage  = nPersonalDamage/2;
                if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nPersonalDamage = 0;
                }
            }
            else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nPersonalDamage = nPersonalDamage/2;
            }
            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nPersonalDamage, DAMAGE_TYPE_FIRE);
                eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lFinalTarget, TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE);
    }
}





