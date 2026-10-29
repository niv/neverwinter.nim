//::///////////////////////////////////////////////
//:: Henchman Death Script
//::
//:: X2_HEN_DEATH.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: <description>
//:://////////////////////////////////////////////
//::
//:: Created By:
//:: Modified by:   Brent, April 3 2002
//::                Removed delay in respawning
//::                the henchman - caused bugs
//:: Modified November 14 2002
//::  - Henchem will now stay dead. Need to be raised
//:://////////////////////////////////////////////

//::///////////////////////////////////////////////
//:: Greater Restoration
//:: NW_S0_GrRestore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all negative effects of a temporary nature
    and all permanent effects of a supernatural nature
    from the character. Does not remove the effects
    relating to Mind-Affecting spells or movement alteration.
    Heals target for 5d8 + 1 point per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Modifications To Support Horses By: Deva Winblood, On: April 17th, 2008

#include "nw_i0_generic"
#include "nw_i0_plot"
#include "x0_i0_henchman"
#include "x3_inc_horse"

void main()
{
    SetLocalString(OBJECT_SELF,"sX3_DEATH_SCRIPT","x2_hen_death");
    if (HorseHandleDeath()) return;
    DeleteLocalString(OBJECT_SELF,"sX3_DEATH_SCRIPT");

    if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_HENCHMAN)
    {
       SetLocalInt(OBJECT_SELF, "X2_L_IJUSTDIED", 10);
       SetKilled(GetMaster());
       SetDidDie();
       object oHench = OBJECT_SELF;
        // * Take them out of stealth mode too (Nov 1 - BK)
        SetActionMode(oHench, ACTION_MODE_STEALTH, FALSE);
        // * Remove invisibility type effects off of henchmen (Nov 7 - BK)
        RemoveSpellEffects(SPELL_INVISIBILITY, oHench, oHench);
        RemoveSpellEffects(SPELL_IMPROVED_INVISIBILITY, oHench, oHench);
        RemoveSpellEffects(SPELL_SANCTUARY, oHench, oHench);
        RemoveSpellEffects(SPELL_ETHEREALNESS, oHench, oHench);
    }
    RemoveHenchman(GetMaster(), OBJECT_SELF);

       // * Custom stuff, if your henchman betrayed you
   // * they can no longer be raised
   string sTag = GetTag(OBJECT_SELF);
   int bDestroyMe = FALSE;
   if (sTag == "H2_Aribeth" && GetLocalInt(GetModule(), "bAribethBetrays") == TRUE)
   {
    bDestroyMe = TRUE;
   }
   else
   if (sTag == "x2_hen_nathyra" && GetLocalInt(GetModule(), "bNathyrraBetrays") == TRUE)
   {
    bDestroyMe = TRUE;

   }
   else
   if (sTag == "x2_hen_valen" && GetLocalInt(GetModule(), "bValenBetrays") == TRUE)
   {
    bDestroyMe = TRUE;

   }
   else
   if (sTag == "x2_hen_deekin" && GetLocalInt(GetModule(), "bDeekinBetrays") == TRUE)
   {
    bDestroyMe = TRUE;
   }

   if (bDestroyMe == TRUE)
   {
    // * For purposes of end-game narration, set whether henchmen
    // * died in final battle
    SetLocalInt(GetModule(), GetTag(OBJECT_SELF) + "_DIED", 1);
    SetIsDestroyable(FALSE, FALSE, FALSE);
   }
}


