//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELLABILITY_MANTICORE_SPIKES
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELLABILITY_MANTICORE_SPIKES
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
