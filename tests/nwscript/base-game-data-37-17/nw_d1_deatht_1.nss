// * Says one liner
int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(OBJECT_SELF, "NW_L_SAYONELINER") == 10;
    if (iResult == TRUE)
    {
      SetLocalInt(OBJECT_SELF, "NW_L_SAYONELINER",0);
    }
    return iResult;
}
