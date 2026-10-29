// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_PROTECTION_FROM_SPELLS, OBJECT_SELF);
    return iResult;
}
