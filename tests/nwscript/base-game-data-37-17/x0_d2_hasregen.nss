// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_REGENERATE, OBJECT_SELF);
    return iResult;
}
