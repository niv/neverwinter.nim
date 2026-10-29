//::///////////////////////////////////////////////
//:: nw_all_feedbackf
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Is there a valid party leader?
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;
    // * Player cannot be the party leaer
    iResult = GetIsObjectValid(GetFactionLeader(GetPCSpeaker())) && GetPCSpeaker() != GetFactionLeader(GetPCSpeaker());
    return iResult;
}
