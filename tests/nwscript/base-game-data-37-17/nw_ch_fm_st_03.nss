// if the familiar is happy with the PC
int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(),"Familiar_Happy") > 0;
    return iResult;
}
