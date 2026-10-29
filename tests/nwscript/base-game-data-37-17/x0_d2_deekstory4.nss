// Deekin is on story #4 (repeatable, for Deekin only)

int StartingConditional()
{
    int iResult;

    iResult = ((GetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story") == 3) ||
               (GetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story") == 4));
    return iResult;
}
