//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_CHARM_PERSON_OR_ANIMAL
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_CHARM_PERSON_OR_ANIMAL
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}
