//::///////////////////////////////////////////////
//:: Holy Aura
//:: NW_S0_HolyAura.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The cleric casting this spell gains +4 AC and
    +4 to saves. Is immune to Mind-Affecting Spells
    used by evil creatures and gains an SR of 25
    versus the spells of Evil Creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////
#include "x0_i0_spells"

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


    //--------------------------------------------------------------------------
    // GZ: Make sure this aura is only active once
    //--------------------------------------------------------------------------
    RemoveSpellEffects(GetSpellId(),OBJECT_SELF,GetSpellTargetObject());


    doAura(ALIGNMENT_EVIL, VFX_DUR_PROTECTION_GOOD_MAJOR, VFX_DUR_PROTECTION_GOOD_MAJOR, DAMAGE_TYPE_DIVINE);
}

