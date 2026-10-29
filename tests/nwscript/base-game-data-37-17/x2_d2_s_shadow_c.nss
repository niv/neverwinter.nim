//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_SHADOW_CONJURATION_MAGIC_MISSILE
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_SHADOW_CONJURATION_MAGIC_MISSILE
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
