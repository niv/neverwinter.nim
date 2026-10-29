//::///////////////////////////////////////////////
//:: Compare Classes
//:: NW_D2_CLASSAME
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are any of the PC classes the same
            as any of the monster classes
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
	int nIdx, nClass;

    for(nIdx = 1; nIdx < 3; nIdx++)
    {
        nClass = GetClassByPosition(nIdx, GetPCSpeaker());
        if(GetLevelByClass(nClass) > 0)
        {
            return TRUE;
        }
    }
	return FALSE;
}

