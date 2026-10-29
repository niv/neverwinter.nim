//::///////////////////////////////////////////////
//:: Glyph of Warding: On Enter
//:: X2_S0_GlphWardA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script creates a Glyph of Warding Placeable
    object.

    Check x2_o0_hhb.nss and the Glyph of Warding
    placeable object for details
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    object oTarget  = GetEnteringObject();
    object oPLC     = GetAreaOfEffectCreator(OBJECT_SELF);
    object oCreator = GetLocalObject(oPLC,"X2_PLC_GLYPH_CASTER") ;

    if ( GetLocalInt (oPLC,"X2_PLC_GLYPH_PLAYERCREATED") == 0 )
    {
        oCreator = oPLC;
    }

    if (!GetIsObjectValid(oPLC) || !GetIsObjectValid(oCreator)) // the placeable or creator is no longer there
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,oCreator))
    {
        SetLocalObject(oPLC,"X2_GLYPH_LAST_ENTER",oTarget );
        SignalEvent(oPLC,EventUserDefined(2000));
    }



}
