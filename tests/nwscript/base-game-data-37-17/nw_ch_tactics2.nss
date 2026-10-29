// * Is the PCSpeaker
// * the Henchman's master?
int StartingConditional()
{
    int iResult;

    iResult = GetMaster() == GetPCSpeaker();
    return iResult;
}
