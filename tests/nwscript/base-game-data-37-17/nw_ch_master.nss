//::///////////////////////////////////////////////
//:: Have Not Master
//:: NW_CH_MASTER
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If I do not have a master then enter
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamanuik
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////


int StartingConditional()
{
    if(!GetIsObjectValid(GetMaster()))
    {
        return TRUE;
    }
    return FALSE;
}
