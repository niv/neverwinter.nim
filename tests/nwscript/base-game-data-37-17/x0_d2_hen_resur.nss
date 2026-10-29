//:://////////////////////////////////////////////////
//:: X0_D2_HEN_RESUR
/*
  TRUE if this henchman died and was resurrected with
  this PC as his/her master.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/06/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if (GetResurrected(GetPCSpeaker()) && GetDidDie())
        return TRUE;

    return FALSE;
}
