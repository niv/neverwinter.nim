//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_MAGIC_CIRCLE_AGAINST_EVIL
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
