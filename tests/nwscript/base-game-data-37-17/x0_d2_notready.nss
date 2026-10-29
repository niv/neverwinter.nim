// Ayala has not yet finished her conversation
// and it is chapter 1

#include "x0_i0_henchman"


int StartingConditional()
{
    int nPlot = GetLocalInt(GetModule(), "X1_Q1AAYALATALK");
    if ((nPlot == 0) && (GetChapter() == 1))
    {
        return TRUE;
    }
    return FALSE;
}
