//::///////////////////////////////////////////////
//:: Associate: End of Combat End
//:: NW_CH_AC3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 16th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////
#include "x0_inc_henai"

void main()
{
    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
        { // set variables on target for mounted combat
            DeleteLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL");
            DeleteLocalInt(OBJECT_SELF,"nX3_HP_BEFORE");
            DeleteLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT");
        } // set variables on target for mounted combat

    if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
       HenchmenCombatRound(OBJECT_INVALID);
    }



    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}
