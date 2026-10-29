//::///////////////////////////////////////////////
//:: Do Not Join
//:: NW_CH_JOIN_NOT
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the PC speaking to the henchman already
    has a master
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 10, 2002
//:://////////////////////////////////////////////

int StartingConditional()
{
    object oMaster = GetPCSpeaker();
    object oHench = GetHenchman(oMaster);
    
    if(oHench != OBJECT_INVALID)
    {
        return TRUE;
    }
    return FALSE;
}
