//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_SHELGARNS_PERSISTENT_BLADE
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_SHELGARNS_PERSISTENT_BLADE
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
