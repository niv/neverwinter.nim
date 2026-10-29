//::///////////////////////////////////////////////
//:: x2_con_inhell
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the pcspeaker is  in
    the reaper area
    
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int StartingConditional()
{
    string sTag = GetTag(GetArea(GetPCSpeaker()));
    if (sTag == "GatesofCania")
    {
        return TRUE;
    }
    return FALSE;
    
}
