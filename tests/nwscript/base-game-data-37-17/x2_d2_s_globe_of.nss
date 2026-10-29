//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_GLOBE_OF_INVULNERABILITY
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_GLOBE_OF_INVULNERABILITY
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
