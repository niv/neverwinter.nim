//:://////////////////////////////////////////////////
//:: X0_D2_HEN_INTERP
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Use to determine if the henchman has a previous
interjection to look at.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

int StartingConditional()
{
    if ( GetInterjectionSet(GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
