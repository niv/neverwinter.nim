// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_REMOVE_DISEASE, OBJECT_SELF);
    return iResult;
}
