// Returns TRUE if the user tried an invalid material baseitem type for
// crafting. Part of the craftskill conversation
// georg, 2003-06-13
int StartingConditional()
{
    int iResult;
    iResult  =  GetLocalInt(GetPCSpeaker(),"X2_CI_CRAFT_INVALIDMATERIAL");
    return iResult;
}
