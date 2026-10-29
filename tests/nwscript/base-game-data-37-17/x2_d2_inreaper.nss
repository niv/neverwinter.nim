//::///////////////////////////////////////////////
//:: x2_d2_inreaper
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns false if in realm of the reaper.

    Used in Henchmen dialog so you cannot ask
    them to leave while in the reaper's realm.
    
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: October 15
//:://////////////////////////////////////////////
int StartingConditional()
{
 string sTag = GetTag(GetArea(OBJECT_SELF));
 if (sTag == "GatesofCania")
 {
    return FALSE;
 }
 return TRUE;
}
