//::///////////////////////////////////////////////
//:: Have Master
//:: NW_CH_TACTICS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If I have a master then enter
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamanuik
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////


int StartingConditional()
{
    if(GetIsObjectValid(GetMaster()))
    {
        return TRUE;
    }
    return FALSE;
}

