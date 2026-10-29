//::///////////////////////////////////////////////
//:: Name: x2_con_ddoor_c1.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to make sure that the PC speaking to the
    death door is the one it was created for...
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 16/03
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetLocalString(OBJECT_SELF, "szOwner") == GetName(GetPCSpeaker()))
        return TRUE;
    return FALSE;
}

