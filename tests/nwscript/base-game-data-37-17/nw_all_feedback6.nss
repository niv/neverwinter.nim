//::///////////////////////////////////////////////
//:: NW_ALL_FEEDBACK6.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Player transports to last ANY PLAYER recall-bind position.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
   location lLoc = GetLocalLocation(OBJECT_SELF, "NW_L_LOC_LAST_RECALL");
   AssignCommand(GetPCSpeaker(), JumpToLocation(lLoc));
}

