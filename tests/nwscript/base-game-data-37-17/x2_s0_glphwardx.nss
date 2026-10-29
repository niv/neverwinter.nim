//::///////////////////////////////////////////////
//:: Glyph of Warding Heartbet
//:: x2_o0_glyphhb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default Glyph of warding damage script

    This spellscript is fired when someone triggers
    a player cast Glyph of Warding


    Check x2_o0_hhb.nss and the Glyph of Warding
    placeable object for details

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void DoDamage(int nDamage, object oTarget)
{
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
    if(nDamage > 0)
    {
        //Apply VFX impact and damage effect
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}

void main()
{
  //Declare major variables
    object oTarget = GetLocalObject(OBJECT_SELF,"X2_GLYPH_LAST_ENTER");
    location lTarget = GetLocation(OBJECT_SELF);
    effect eDur = EffectVisualEffect(445);
    int nDamage;
    int nCasterLevel =   GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_LEVEL");
    int nMetaMagic = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_METAMAGIC");
    object oCreator = GetLocalObject(OBJECT_SELF,"X2_PLC_GLYPH_CASTER") ;


    if ( GetLocalInt (OBJECT_SELF,"X2_PLC_GLYPH_PLAYERCREATED") == 0 )
    {
        oCreator = OBJECT_SELF;
    }

    if (!GetIsObjectValid(oCreator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nDice = nCasterLevel /2;

    if (nDice > 5)
        nDice = 5;
    else if (nDice <1 )
        nDice = 1;

    effect eDam;
    effect eExplode = EffectVisualEffect(459);

    //Check the faction of the entering object to make sure the entering object is not in the casters faction

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Cycle through the targets in the explosion area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
            if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,oCreator))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCreator, GetSpellId()));
                //Make SR check
                if (!MyResistSpell(oCreator, oTarget))
                {
                    nDamage = d8(nDice);
                    //Enter Metamagic conditions

                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 8 * 5;//Damage is at max
                    }
                    else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                        nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
                    }

                    //Change damage according to Reflex, Evasion and Improved Evasion
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC, oCreator);


                    //----------------------------------------------------------
                    // Have the creator do the damage so he gets feedback strings
                    //----------------------------------------------------------
                    if (oCreator != OBJECT_SELF)
                    {
                        AssignCommand(oCreator, DoDamage(nDamage,oTarget));
                    }
                    else
                    {
                        DoDamage(nDamage,oTarget);
                    }

                }
            }
             //Get next target in the sequence
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
