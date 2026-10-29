//::///////////////////////////////////////////////
//:: Glyph of Warding Heartbeat
//:: x2_o0_glyphhb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Heartbeat for glyph of warding object

    Short rundown:

    Casting "glyph of warding" will create a GlyphOfWarding
    object from the palette and store all required variables
    on that object. You can also manually add those variables
    through the toolset.

    On the first heartbeat, the glyph creates the glyph visual
    effect on itself for the duration of the spell.

    Each subsequent heartbeat the glyph checks if the effect
    is still there. If it is no longer there, it has either been
    dispelled or removed, and the glyph will terminate itself.

    Also on the first heartbeat, this object creates an AOE object
    around itself, which, when getting the OnEnter Event from a
    Creature Hostile to the player, will  signal User Defined Event
    2000 to the glyph placeable which will fire the spell
    stored on a variable on it self on the intruder

    Note that not all spells might work because this is a placeable
    object casting them, but the more populare ones are working.

    The default spell cast is id 764, which is the script for
    the standard glyph of warding.

    Check the comments on the Glyph of Warding object on the palette
    for more information

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

#include "x2_inc_switches"
void main()
{

    int bSetup = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_INIT");
    int nLevel = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_LEVEL");
    if (bSetup == 0)
    {
        SetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_INIT",1);
        int nMetaMagic = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_METAMAGIC") ;
        int nDuration = nLevel /2;
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
           nDuration =           nDuration *2;//Duration is +100%
        }

        if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_INVISIBLE_GLYPH_OF_WARDING))
        {
            // show glyph symbol only for 6 seconds
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(445),OBJECT_SELF,6.0f);
            // use blur VFX therafter (which should be invisible);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(0),OBJECT_SELF,TurnsToSeconds(nDuration));
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(445),OBJECT_SELF,TurnsToSeconds(nDuration));
        }
        effect eAOE = EffectAreaOfEffect(38, "x2_s0_glphwarda");
        if (GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_PERMANENT") == TRUE)
        {
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAOE, GetLocation(OBJECT_SELF));
        }
        else
        {
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(OBJECT_SELF), TurnsToSeconds(nDuration));
        }
     }
    else
    {
        effect e1 = GetFirstEffect(OBJECT_SELF);
        int bGood = FALSE;
        while (GetIsEffectValid(e1))
        {
            if (GetEffectType(e1) == EFFECT_TYPE_VISUALEFFECT)
            {
                if (GetEffectCreator(e1) == OBJECT_SELF)
                {
                    bGood = TRUE;
                }
            }
            e1 = GetNextEffect(OBJECT_SELF);
        }

        if (!bGood)
        {
            DestroyObject(OBJECT_SELF);
            return;
        }

    }

    // check if caster left the game
    object oCaster = GetLocalObject(OBJECT_SELF,"X2_PLC_GLYPH_CASTER");
    if (!GetIsObjectValid(oCaster) || GetIsDead(oCaster))
    {
        if (GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_PLAYERCREATED") == TRUE)
        {
            DestroyObject(OBJECT_SELF);
        }
        return;
    }
}
