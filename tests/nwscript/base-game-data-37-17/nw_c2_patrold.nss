//::///////////////////////////////////////////////
//:: Alarm Patroller User Defined
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:    Brent
//:: Created On:    November
//:://////////////////////////////////////////////

#include "nw_i0_generic"
float fMercyPeriod = 12.0;

void main()
{
    switch(GetUserDefinedEventNumber())
    {
        case 1002:
            if (GetLocalInt(OBJECT_SELF, "NW_L_PATROLSTATE") == 0)
            {
                object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
                if (GetIsEnemy(oPC) == FALSE)
                {
                    return; // don't shout for help if not enemies
                }

                if (GetIsObjectValid(oPC) == TRUE)
                {
                    SetLocalInt(OBJECT_SELF, "NW_L_PATROLSTATE",1);
                    DelayCommand(fMercyPeriod, SignalEvent(OBJECT_SELF, EventUserDefined(3333)));
                    ClearAllActions();
                    ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0, fMercyPeriod);
                    // * SetCommmandable(False) will turn off his AI for 12 seconds
                    SetCommandable(FALSE);
                    SpeakOneLinerConversation();
                    DelayCommand(fMercyPeriod, SetCommandable(TRUE));
                }
            }

        break;
        // * get mad, shout for help
        case 3333:
            if (GetLocalInt(OBJECT_SELF, "NW_L_PATROLSTATE") == 1)
            {
                object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
                if (GetIsObjectValid(oPC) == TRUE)
                {
                    if (GetIsEnemy(oPC) == FALSE)
                    {
                        return; // don't shout for help if not enemies
                    }
                    SetLocalInt(OBJECT_SELF, "NW_L_PATROLSTATE",2);
                    ClearAllActions();
                    DetermineCombatRound(oPC);
                    SpeakOneLinerConversation();
                    //SummonHelp(OBJECT_SELF);
                    ExecuteScript("M_ALARM_HEADER", OBJECT_SELF);
                }
            }
        break;
    }
}
