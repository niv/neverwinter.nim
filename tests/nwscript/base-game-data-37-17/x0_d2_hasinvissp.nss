// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_INVISIBILITY_SPHERE, OBJECT_SELF);
    return iResult;
}
