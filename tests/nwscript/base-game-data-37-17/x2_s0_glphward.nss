//::///////////////////////////////////////////////
//:: Glyph of Warding
//:: X2_S0_GlphWard
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes a sonic explosion that does 1d8 per
    two caster levels up to a max of 5d8 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////

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

   object oGlyph = CreateObject(OBJECT_TYPE_PLACEABLE,"x2_plc_glyph",GetSpellTargetLocation());
   object  oTest = GetNearestObjectByTag("X2_PLC_GLYPH",oGlyph);

    if (GetIsObjectValid(oTest) && GetDistanceBetween(oGlyph, oTest) <5.0f)
    {
        FloatingTextStrRefOnCreature(84612,OBJECT_SELF);
        DestroyObject(oGlyph);
        return;
    }


   // Store the caster
   SetLocalObject(oGlyph,"X2_PLC_GLYPH_CASTER",OBJECT_SELF);

   // Store the caster level
   SetLocalInt  (oGlyph,"X2_PLC_GLYPH_CASTER_LEVEL",GetCasterLevel(OBJECT_SELF));

   // Store Meta Magic
   SetLocalInt (oGlyph,"X2_PLC_GLYPH_CASTER_METAMAGIC",GetMetaMagicFeat());

   // This spell (default = line 768 in spells.2da) will run when someone enters the glyph
   SetLocalInt(oGlyph,"X2_PLC_GLYPH_SPELL",764);

   // Tell the system that this glyph was player and not toolset created
   SetLocalInt (oGlyph,"X2_PLC_GLYPH_PLAYERCREATED",TRUE);

   // Tell the game the glyph is not a permanent one
   DeleteLocalInt(oGlyph,"X2_PLC_GLYPH_PERMANENT");

   // Force first hb
   ExecuteScript("x2_o0_glyphhb",oGlyph);

}


