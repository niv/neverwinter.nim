//DaelanWork is 1.  This comes up if the player has dropped the NPC from his party.  The NPC remains where he is standing until the player returns.  The NPC will NOT join with another Player, only his current owner.
#include "nw_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = /*GetWorkingForPlayer(GetPCSpeaker()) == TRUE*/
        GetFormerMaster() == GetPCSpeaker()
        &&
        HasPersonalItem(GetPCSpeaker()) == TRUE ; ;
    return iResult;
}
