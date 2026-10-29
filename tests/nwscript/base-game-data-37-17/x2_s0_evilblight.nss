//::///////////////////////////////////////////////
//:: Evil Blight
//:: x2_s0_EvilBlight
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Any enemies within the area of effect will
    suffer a curse effect
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs
//:: Updated on: March 28, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller


#include "nw_i0_spells"
#include "x0_i0_spells"

#include "x2_inc_spellhook"

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

    // End of Spell Cast Hook

    //Declare major variables
    object oTarget;
    effect eImpact = EffectVisualEffect(VFX_IMP_DOOM);
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    effect eCurse = SupernaturalEffect(EffectCurse(3,3,3,3,3,3));

    //Apply Spell Effects
    location lLoc = GetLocation(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);

    //Get first target in the area of effect
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
    float fDelay;

    while(GetIsObjectValid(oTarget))
    {
        //Check faction of oTarget
        if (GetIsEnemy(oTarget))
        {
            //Signal spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(oTarget,  GetSpellId()));
            //Make SR Check
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                    //Make Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
                {
                    // wont stack
                    if (!GetHasSpellEffect(GetSpellId(), oTarget))
                        {
                             ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                             ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget);
                        }
                }
            }
        }
        //Get next spell target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
