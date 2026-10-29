/*
    Intelligent Weapon: Enserric

    TRUE if the player did ** NOT ** ask the question q1 in the inital
    conversation.

    Georg Zoeller, 2003-10-10
*/

#include "x2_inc_intweapon"

int StartingConditional()
{
    int iResult;

    iResult = !IWGetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",1);
    return iResult;
}
