////////
//// Checks if player is in Chapter 3
//////////

#include "nw_i0_plot"
#include "NW_i0_HENCHMAN"

int StartingConditional()
{
    int iResult;

    iResult = GetChapter() == 3;
    return iResult;
}


