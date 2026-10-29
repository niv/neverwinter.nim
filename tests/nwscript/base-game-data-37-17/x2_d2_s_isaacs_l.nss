//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_ISAACS_LESSER_MISSILE_STORM
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_ISAACS_LESSER_MISSILE_STORM
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
