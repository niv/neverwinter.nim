//::///////////////////////////////////////////////
//:: Associate: On Dialogue
//:: NW_CH_AC4
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    by the generic script after dialogue or a
    shout is initiated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////


#include "x0_inc_henai"




void main()
{
    if(GetCommandable() || GetCurrentAction() != ACTION_OPENLOCK)
    {
        int nMatch = GetListenPatternNumber();
        object oShouter = GetLastSpeaker();
        object oIntruder;
        if (nMatch == -1)
        {
            if(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster()) == OBJECT_SELF)
            {
                ClearAllActions();
                BeginConversation();
            }
            else if(!GetIsObjectValid(GetMaster()))
            {
                ClearAllActions();
                BeginConversation();
            }
            else if(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, GetMaster()) == OBJECT_SELF ||
                    GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, GetMaster()) == OBJECT_SELF)
            {
                ClearAllActions();
                BeginConversation();
            }
        }
        else if(GetIsObjectValid(oShouter) && GetMaster() == oShouter)
        {
            SetCommandable(TRUE);
            bkRespondToHenchmenShout(oShouter, nMatch, oIntruder);


            if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(1004));
            }
        }
    }
}

