// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_FREEDOM_OF_MOVEMENT, OBJECT_SELF);
    return iResult;
}
