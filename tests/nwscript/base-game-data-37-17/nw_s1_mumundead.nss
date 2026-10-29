//::///////////////////////////////////////////////
//:: Bolster Undead
//:: NW_S1_MumUndead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell increases the Turn Resistance of
    all undead around the caster by an amount
    scaled with HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2002
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    int nHD = GetHitDice(OBJECT_SELF);
    nHD = nHD / 4;
    if(nHD == 0)
    {
        nHD = 1;
    }
    effect eTurn = EffectTurnResistanceIncrease(nHD);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));
    float fDelay;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsFriend(oTarget))
        {
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MUMMY_BOLSTER_UNDEAD, FALSE));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTurn, oTarget, RoundsToSeconds(10)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
