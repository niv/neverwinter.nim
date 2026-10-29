// the PC does not have at least 1 level Cleric

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) == 0;
    return iResult;
}

