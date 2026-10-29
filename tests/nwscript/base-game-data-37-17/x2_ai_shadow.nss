//::///////////////////////////////////////////////
//:: x2_ai_shadow
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Shadows should only do touch attacks.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2003
//:://////////////////////////////////////////////

// * apply the shadow strength damage to target

#include "x2_inc_switches"
#include "nw_i0_generic"



void main()
{
    //--------------------------------------------------------------------------
    // Shadowdancer shadows have a 66% chance of running the default combat AI
    //--------------------------------------------------------------------------
    if (GetTag(OBJECT_SELF) == "X1_S_SHADLORD"    ||
        GetResRef(OBJECT_SELF) == "x2_s_eshadlord")
    {
        if (d3() > 1)
        {
            return;
        }

    }


    SetCreatureOverrideAIScriptFinished(OBJECT_SELF);

    if (GetLocalInt(OBJECT_SELF, "SHADOW_COMBAT_RUNNING") == 1)
        return;

    // bad bad bad... there is a distinct possibility that this variable can be set
    // to 1, without ever having a corresponding set back to zero...
    //SetLocalInt(OBJECT_SELF, "SHADOW_COMBAT_RUNNING", 1);

    object oEnemy = GetNearestEnemy();
    if (GetIsObjectValid(oEnemy) == TRUE)
    {
        // this is where this line should be, not above where I've commented it out
        SetLocalInt(OBJECT_SELF, "SHADOW_COMBAT_RUNNING", 1);

        object oSelf = OBJECT_SELF;
        // * just slightly random so they don't appear synchronized.
        int nRoundDelay = Random(2) + 1;
        float fDelay = IntToFloat(nRoundDelay);

        DelayCommand(fDelay, ActionCastSpellAtObject(769, oEnemy, METAMAGIC_ANY, TRUE));

        DelayCommand(fDelay, ActionDoCommand(SetLocalInt(oSelf, "SHADOW_COMBAT_RUNNING", 0)));


    }
}
