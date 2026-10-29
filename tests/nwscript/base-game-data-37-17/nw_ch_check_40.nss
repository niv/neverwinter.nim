////////
//// Checks if player is in Chapter 1
//////////

#include "nw_i0_plot"
#include "NW_i0_HENCHMAN"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 1;
    return iResult;
}
