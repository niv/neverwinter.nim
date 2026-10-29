// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_LIGHT, OBJECT_SELF);
    return iResult;
}
