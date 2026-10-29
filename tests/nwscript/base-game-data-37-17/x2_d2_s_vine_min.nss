//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_VINE_MINE_CAMOUFLAGE
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_VINE_MINE_CAMOUFLAGE
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
