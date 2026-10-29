//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_TASHAS_HIDEOUS_LAUGHTER
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_TASHAS_HIDEOUS_LAUGHTER
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
