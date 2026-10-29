/*
    Intelligent Weapon: Enserric
    TRUE if the player asked the sword's about leaving it's shell and
    AND if we are in chapter 3
    AND if we are not asked this question before

    Georg Zoeller, 2003-10-10
*/

#include "x2_inc_intweapon"
int StartingConditional()
{
    int iResult;

    // * We did ask the question about leaving the sword
    iResult = IWGetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",4);
    // * We did not ask this question before
    iResult = !IWGetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",5);
    // * We are in HotU chapter 3
    iResult = iResult && IWGetIsHotUChapter3();
    return iResult;
}
