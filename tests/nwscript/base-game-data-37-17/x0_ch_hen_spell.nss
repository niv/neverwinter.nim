//::///////////////////////////////////////////////
//:: Henchmen: On Spell Cast At
//:: NW_CH_ACB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:://////////////////////////////////////////////
#include "x0_i0_henchman"
#include "X0_INC_HENAI"

void main()
{
    if (GetIsHenchmanDying() == TRUE)
    {
        int nId = GetLastSpell();
        if (nId == SPELL_CURE_LIGHT_WOUNDS || nId == SPELL_CURE_CRITICAL_WOUNDS
        || nId == SPELL_CURE_MINOR_WOUNDS || nId == SPELL_CURE_MODERATE_WOUNDS
        || nId == SPELL_CURE_SERIOUS_WOUNDS || nId == SPELL_HEAL ||
        nId == 506 || // * Healing Kits
        nId == SPELLABILITY_LAY_ON_HANDS || // * Lay on Hands
        nId == 309    // * Wholeness of Body
        || nId == SPELL_HEALING_CIRCLE
        || nId == SPELL_RAISE_DEAD
        || nId == SPELL_RESURRECTION
        || nId == SPELL_MASS_HEAL
        || nId == SPELL_GREATER_RESTORATION
        || nId == SPELL_REGENERATE
        || nId == SPELL_AID
        || nId == SPELL_VIRTUE
        )

        {
            SetLocalInt(OBJECT_SELF, "X0_L_WAS_HEALED",10);
            WrapCommandable(TRUE, OBJECT_SELF);
            DoRespawn(GetLastSpellCaster(), OBJECT_SELF);
            return;
        }
    }
	ExecuteScript("nw_ch_acb", OBJECT_SELF);
}
