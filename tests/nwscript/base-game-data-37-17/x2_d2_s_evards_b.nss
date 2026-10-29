//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_EVARDS_BLACK_TENTACLES
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_EVARDS_BLACK_TENTACLES
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
