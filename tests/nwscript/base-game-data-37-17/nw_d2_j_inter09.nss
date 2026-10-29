#include "NW_I0_PLOT"

int StartingConditional()
{
    int iReact = GetPLocalInt(GetPCSpeaker(),"NW_G_TalkTo"+GetTag(OBJECT_SELF));
    if (iReact == 0)
    {
        return CheckCharismaHigh();
    }
    return FALSE;
}
