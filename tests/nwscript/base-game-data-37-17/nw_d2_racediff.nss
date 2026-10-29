//::///////////////////////////////////////////////
//:: Race Type Different
//:: NW_D2_RACEDIFF
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks: Are the PC and NPC Racial Types different
*/
//:://////////////////////////////////////////////

int StartingConditional()
{
	int l_iResult;

	l_iResult = GetRacialType(OBJECT_SELF) != GetRacialType(GetPCSpeaker());
	return l_iResult;
}
