/*
    Intelligent Weapon: Enserric

    TRUE if the player already talked with the sword about it affecting
    his health

    Georg Zoeller, 2003-10-10
*/

#include "x2_inc_intweapon"

int StartingConditional()
{
    int iResult;
    iResult = IWGetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",3) ;
    iResult = iResult || (!IWGetIsHotUChapter1() && !IWGetIsHotUChapter2()  && !IWGetIsHotUChapter3());
    return iResult;
}
