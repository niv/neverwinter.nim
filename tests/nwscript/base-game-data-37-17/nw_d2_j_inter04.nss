//::///////////////////////////////////////////////
//:: Generic Conversation Check
//:: NW_D2_gen_check
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see whether the NPC has an initialized
    NPC is using SetSpecialConversationStart
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 7, 2001
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

int StartingConditional()
{
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION))
    {
        if(!GetIsObjectValid(GetPCSpeaker()))
        {
            int iReact = GetLocalInt(OBJECT_SELF,"I_AM_FRIENDLY");
            int iCount = GetLocalInt(OBJECT_SELF,"YELL_COUNTER");
            if ((iReact == 0) && (iCount == 1))
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}

