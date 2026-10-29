int StartingConditional()
{
    int iResult = GetLocalInt(OBJECT_SELF,"Generic_Surrender");
    if (iResult == 0)
    {
        return TRUE;
    }
    return FALSE;
}
