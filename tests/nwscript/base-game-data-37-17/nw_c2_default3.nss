//::///////////////////////////////////////////////
//:: Default: End of Combat Round
//:: NW_C2_DEFAULT3
//:: Copyright (c) 2008 Bioware Corp.
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
//:: Modified On: Feb 16th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

void main()
{

    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
        { // set variables on target for mounted combat
            DeleteLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL");
            DeleteLocalInt(OBJECT_SELF,"nX3_HP_BEFORE");
            DeleteLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT");
            if (GetHasFeat(FEAT_MOUNTED_COMBAT,OBJECT_SELF))
            { // check for AC increase
                int nRoll=d20()+GetSkillRank(SKILL_RIDE);
                nRoll=nRoll-10;
                if (nRoll>4)
                { // ac increase
                    nRoll=nRoll/5;
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectACIncrease(nRoll),OBJECT_SELF,8.5);
                } // ac increase
            } // check for AC increase
        } // set variables on target for mounted combat

    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
    {
        DetermineSpecialBehavior();
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
       DetermineCombatRound();
    }
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}




