//::///////////////////////////////////////////////
//:: Undeath to Death
//:: X2_S0_Undeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

  This spell slays 1d4 HD worth of undead creatures
  per caster level (maximum 20d4). Creatures with
  the fewest HD are affected first;

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On:  August 13,2003
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_toollib"
#include "x2_inc_spellhook"

void DoUndeadToDeath(object oCreature)
{
    SignalEvent(oCreature, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    SetLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD", TRUE);

    if (!MySavingThrow(SAVING_THROW_WILL,oCreature,GetSpellSaveDC(),SAVING_THROW_TYPE_NONE,OBJECT_SELF))
    {
       float fDelay = GetRandomDelay(0.2f,0.4f);
       if (!MyResistSpell(OBJECT_SELF, oCreature, fDelay))
       {
            effect eDeath = EffectDamage(GetCurrentHitPoints(oCreature),DAMAGE_TYPE_DIVINE,DAMAGE_POWER_ENERGY);
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay+0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oCreature));
            DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oCreature));
       }
       else
       {
            DelayCommand(1.0f,DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
       }
   }
          else
       {
            DelayCommand(1.0f,DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
       }
}

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    int nMetaMagic = GetMetaMagicFeat();


// End of Spell Cast Hook

    // Impact VFX
    location lLoc = GetSpellTargetLocation();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_STRIKE_HOLY),lLoc);
    TLVFXPillar(VFX_FNF_LOS_HOLY_20, lLoc,3,0.0f);


     // build list with affected creatures

     // calculation
     int nLevel = GetCasterLevel(OBJECT_SELF);
     if (nLevel>20)
     {
         nLevel = 20;
     }
     // calculate number of hitdice affected
     int nLow = 9999;
     object oLow;
     int nHDLeft = nLevel *d4();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nHDLeft = 4 * GetCasterLevel(OBJECT_SELF);//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nHDLeft += (nHDLeft/2); //Damage/Healing is +50%
    }

    int nCurHD;
    object oFirst = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f,lLoc );

     // Only start loop if there is a creature in the area of effect
     if  (GetIsObjectValid(oFirst))
     {

        object oTarget = oFirst;
        while (GetIsObjectValid(oTarget) && nHDLeft >0)
        {

            if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                nCurHD = GetHitDice(oTarget);
                if (nCurHD <= nHDLeft )
                {
                    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                    {
                        // ignore creatures already affected
                        if (GetLocalInt(oTarget,"X2_EBLIGHT_I_AM_DEAD") == 0 && !GetPlotFlag(oTarget) && !GetIsDead(oTarget))
                        {
                            // store the creature with the lowest HD
                            if (GetHitDice(oTarget) <= nLow)
                            {
                                nLow = GetHitDice(oTarget);
                                oLow = oTarget;
                            }
                        }
                    }
                }
            }

            // Get next target
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f ,lLoc);

            // End of cycle, time to kill the lowest creature
            if (!GetIsObjectValid(oTarget))
            {
                // we have a valid lowest creature we can affect with the remaining HD
                if (GetIsObjectValid(oLow) && nHDLeft >= nLow)
                {
                    DoUndeadToDeath(oLow);
                    // decrement remaining HD
                    nHDLeft -= nLow;
                    // restart the loop
                    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, GetSpellTargetLocation());
                }
                // reset counters
                oLow = OBJECT_INVALID;
                nLow = 9999;
            }
        }
    }
 }
