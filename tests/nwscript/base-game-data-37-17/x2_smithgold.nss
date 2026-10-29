///Checks if the Smith has NOT explained
///why he needs gold from the player

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF,"Smith_Gold")==FALSE;
    return iResult;
}
