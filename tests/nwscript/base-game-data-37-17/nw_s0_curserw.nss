//::///////////////////////////////////////////////
//:: Cure Serious Wounds
//:: NW_S0_CurSerW
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// As cure light wounds, except cure moderate wounds
// cures 3d8 points of damage plus 1 point per caster
// level (up to +15).
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18, 2000
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


  spellsCure(d8(3), 15, 24, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_L, GetSpellId());
}

