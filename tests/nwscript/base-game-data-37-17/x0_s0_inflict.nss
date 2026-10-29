//::///////////////////////////////////////////////
//:: [Inflict Wounds]
//:: [X0_S0_Inflict.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: This script is used by all the inflict spells
//::
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "X0_I0_SPELLS" // * this is the new spells include for expansion packs

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

  
    int nSpellID = GetSpellId();
    switch (nSpellID)
    {
/*Minor*/     case 431: spellsInflictTouchAttack(1, 0, 1, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Light*/     case 432: case 609: spellsInflictTouchAttack(d8(), 5, 8, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Moderate*/  case 433: case 610: spellsInflictTouchAttack(d8(2), 10, 16, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Serious*/   case 434: case 611: spellsInflictTouchAttack(d8(3), 15, 24, 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Critical*/  case 435: case 612: spellsInflictTouchAttack(d8(4), 20, 32, 246, VFX_IMP_HEALING_G, nSpellID); break;

    }
}
