// Deekin's story not begun yet

#include "x0_i0_henchman"

int StartingConditional()
{
    int iResult;

    iResult = ((GetLocalInt(GetModule(), "x2_hen_deekstory") == 0) &&
               (GetChapter() == 1));
    return iResult;
}
