// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_BULLS_STRENGTH, OBJECT_SELF);
    return iResult;
}
