//::///////////////////////////////////////////////
//:: nw_all_feedbackg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Transports you to the party leader.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    object oLeader = GetFactionLeader(GetPCSpeaker());
    if (GetIsObjectValid(oLeader) == TRUE)
    {
        AssignCommand(GetPCSpeaker(), JumpToObject(oLeader));
    }
}
