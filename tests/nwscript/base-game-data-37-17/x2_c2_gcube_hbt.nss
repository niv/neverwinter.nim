//::///////////////////////////////////////////////
//:: Name x2_def_heartbeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gelatinous Cube Heartbeat
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Sept 16/03
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_i0_spells"
void main()
{

    // execute default AI
    ExecuteScript("nw_c2_default1", OBJECT_SELF);
    // Cube additions


    // * Only on the first heartbeat, destroy the creature's personal space
    if (!GetLocalInt(OBJECT_SELF,"X2_L_GCUBE_SETUP"))
    {
        effect eGhost = EffectCutsceneGhost();
        eGhost = SupernaturalEffect(eGhost);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eGhost,OBJECT_SELF);
        SetLocalInt(OBJECT_SELF,"X2_L_GCUBE_SETUP",TRUE)   ;
    }

   object oVictim = GetFirstObjectInShape(SHAPE_CUBE,4.0f,GetLocation(OBJECT_SELF),TRUE, OBJECT_TYPE_CREATURE);

   while (GetIsObjectValid(oVictim))
   {
        if (spellsIsTarget(oVictim,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oVictim != OBJECT_SELF)
        {
            EngulfAndDamage(oVictim,OBJECT_SELF);
        }
        oVictim = GetNextObjectInShape(SHAPE_CUBE,4.0f,GetLocation(OBJECT_SELF),TRUE, OBJECT_TYPE_CREATURE);
   }


}

