///Checks if the Smith has explained
///how the forge works

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF,"Smith_Forge")==  TRUE;
    return iResult;
}

