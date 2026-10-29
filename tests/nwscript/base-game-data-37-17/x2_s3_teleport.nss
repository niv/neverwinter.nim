//::///////////////////////////////////////////////
//:: x2_s3_teleport
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If hit, the opponent teleports to the player

    GZ:
        Added Will Save Vs Spells DC 10 + Casterlevel
        Added Plot Check
        Added Reaction Hostile Check

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: 27/06/03
//:: Updated On: 2003/10/11 GZ
//:://////////////////////////////////////////////

#include "x0_i0_spells"
void main()
{
    //declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_TORNADO);
    object oArrow = GetSpellCastItem();
    object oHitter = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    if (!GetIsObjectValid(oTarget))
    {
        return;
    }
    if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
    {
        return;
    }


    if (! GetPlotFlag(oTarget) && GetIsReactionTypeHostile(oTarget,oHitter) )
    {

        int nDC = 10 + GetCasterLevel(OBJECT_SELF);
        if (MySavingThrow(SAVING_THROW_WILL,oTarget,nDC,SAVING_THROW_TYPE_SPELL,oHitter) ==0)
        {
            AssignCommand(oTarget, ClearAllActions(TRUE));
            AssignCommand(oTarget, JumpToObject(oHitter));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }

}
