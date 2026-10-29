////////
//// Checks if player is in Chapter 2
//////////

#include "nw_i0_plot"
#include "NW_i0_HENCHMAN"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 2;
    return iResult;
}

