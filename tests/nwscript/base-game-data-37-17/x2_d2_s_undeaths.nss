//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_UNDEATHS_ETERNAL_FOE
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_UNDEATHS_ETERNAL_FOE
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
