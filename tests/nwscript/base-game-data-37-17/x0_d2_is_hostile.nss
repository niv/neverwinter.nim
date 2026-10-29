//::///////////////////////////////////////////////////
//:: X0_D2_IS_HOSTILE
//:: TRUE if NPC has gone hostile to the PC. 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//::///////////////////////////////////////////////////

int StartingConditional()
{
    return GetIsEnemy(GetPCSpeaker());
}
