// Deekin tells his final story

#include "x0_i0_henchman"

int StartingConditional()
{
    int nPlot = GetLocalInt(GetModule(), "x2_hen_deekstory");
    int nChapter = GetChapter();
    int nTale = GetLocalInt(GetModule(), "x2_deekin_final_tale");

    if ((nPlot > 2) && (nChapter > 1) && (nTale == 0))
    {
        SetLocalInt(GetModule(), "x2_deekin_final_tale", 1);
        return TRUE;
    }
    return FALSE;
}
