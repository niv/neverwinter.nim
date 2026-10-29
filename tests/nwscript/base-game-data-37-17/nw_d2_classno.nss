//::///////////////////////////////////////////////
//:: Compare Classes
//:: NW_D2_CLASSNO
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Makes sure none of the PC classes are
            the same as the NPC classes
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
            return FALSE;
        }
    }
	return TRUE;
}
