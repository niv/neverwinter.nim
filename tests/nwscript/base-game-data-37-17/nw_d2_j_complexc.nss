int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF,"NW_COMPLEXPLOT"+GetTag(OBJECT_SELF)) ==100;
    return iResult;
}
