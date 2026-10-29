// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_CATS_GRACE, OBJECT_SELF);
    return iResult;
}
