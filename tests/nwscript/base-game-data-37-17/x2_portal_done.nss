//::///////////////////////////////////////////////
//:: Gatekeeper, PC has Commanded the Reaper by his True Name (Condition Script)
//:: x2_portal_done.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Returns TRUE if the Player has commanded the
     Reaper by his True Name to spawn a portal
     back to Waterdeep.
*/
//:://////////////////////////////////////////////
//:: Created By: Rob Bartel
//:: Created On: November 6, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int bDoor = GetLocalInt(GetModule(), "bGatekeeper_PlayerHome");
    if (bDoor == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}
