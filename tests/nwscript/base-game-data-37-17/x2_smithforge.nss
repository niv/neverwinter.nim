///Checks if the Smith has NOT explained
///how the forge works

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF,"Smith_Forge")==FALSE;
    return iResult;
}

