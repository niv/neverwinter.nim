////////////////
///  Takes 5 gold from player
///  Instantly rests player, restores all spells, special abilities, feats, etc.
///  Should display some effect or string to show the player has rested
/////////////


#include "NW_I0_PLOT"

void main()
{
    TakeGold(5,GetPCSpeaker());
    /////Specail instant rest function
    AssignCommand(GetPCSpeaker(), JumpToObject(GetNearestObjectByTag("NW_INNROOM01"), FALSE));
    AssignCommand(GetPCSpeaker(), ActionRest());
}

