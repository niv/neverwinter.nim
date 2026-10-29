//::///////////////////////////////////////////////
//:: Custom User Defined Event
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Rat will run away from any HUNTERS (or enemy).
    It will attempt to get to the filth pile
    that created it.
    
    It will also tell a HUNTER to chase it.
    
    
    HISTORY: First attempt used perception event
    but that did not work the way I wanted.
    
    Instead made the 'hunter' shout that he was hunting
    and the rat responds to that.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_am_inc"

void main()
{
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1004) //CONVERSATION
    {
        object oObject = GetLastSpeaker();
        if (GetListenPatternNumber() == LISTEN_IHUNTYOU)
        if (GetIsObjectValid(oObject) == TRUE)
        {

            //SpeakString("saw something " + GetName(oObject));
            // * someone who could chase me has been found
            if (GetJob(oObject) == JOB_HUNTER || GetIsEnemy(oObject) )
            {

                object oHouse = GetLocalObject(OBJECT_SELF, "X2_L_HOUSE");
                if (GetIsObjectValid(oHouse) == TRUE)
                {
                   // SpeakString("saw dog");
                    // * move to house
                    ClearAllActions();
                    ActionMoveToObject(oHouse, TRUE, 0.1);
                    object oSelf = OBJECT_SELF;
                    
                    // * only decrement if first time
                    if (GetCommandable(OBJECT_SELF) == TRUE)
                          AssignCommand(oHouse, DelayCommand(60.0, SetLocalInt(oHouse, "X2_L_RATSMADE", GetLocalInt(oHouse, "X2_L_RATSMADE") - 1)));
                    ActionDoCommand(DestroyObject(oSelf));
                    // * in 60 seconds create another rat
//                    AssignCommand(oHouse, DelayCommand(210.0, ActionDoCommand(CreateRat())) );

                    // * if enemy is a Hunter, then make them chase me
                    if (GetJob(oObject) == JOB_HUNTER)
                    {
                        AssignCommand(oObject, ClearAllActions());
                        AssignCommand(oObject, ActionMoveToObject(oSelf, TRUE, 1.2));
                    }
                    SetCommandable(FALSE); // * cannot get new commands, I am a dead rat
                }
            }
        }

    }

}


