//:://////////////////////////////////////////////////
//:: X0_D2_M3_REMET
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Henchman/NPC conditional: first meeting in module 3
but player has previously hired the henchman. 
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////
// May 2003: Removed the HasHired, doesn't appear to
// be necessary and was returning false.
#include "x0_i0_henchman"

int StartingConditional()
{
    if (!GetHasMet(GetPCSpeaker())
        &&
      //  GetPlayerHasHired(GetPCSpeaker())
      //  &&
        (GetChapter() == 3)
        ) 
    {
        return TRUE;
    }
    return FALSE;
}
