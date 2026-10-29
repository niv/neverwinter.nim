//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_INFESTATION_OF_MAGGOTS
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_INFESTATION_OF_MAGGOTS
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
