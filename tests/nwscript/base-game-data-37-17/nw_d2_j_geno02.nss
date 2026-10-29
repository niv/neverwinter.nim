#include "NW_I0_PLOT"

int StartingConditional()
{
    int iResult = GetPLocalInt(GetPCSpeaker(),"GENOCIDEGEN1_TALK"+GetTag(OBJECT_SELF));
    int iPlot = GetLocalInt(GetModule(),"NW_GENO_PLOT"+GetTag(OBJECT_SELF));
    if ((iResult == 0) && (iPlot == 0))
    {
        return CheckCharismaHigh();
    }
    return FALSE;
}

