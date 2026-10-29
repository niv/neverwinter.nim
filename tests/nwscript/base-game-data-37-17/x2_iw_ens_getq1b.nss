/*
    Intelligent Weapon: Enserric
    TRUE if the player asked the sword's mortal life,
    AND  if we are in chapter 2or3
    AND  if we did not ask this question before

    Georg Zoeller, 2003-10-10
*/

#include "x2_inc_intweapon"
int StartingConditional()
{
    int iResult;

    // * Talked to sword about its life
    iResult = IWGetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",1);
    // * only chapter 2
    iResult = iResult &&  (IWGetIsHotUChapter2() || IWGetIsHotUChapter3());
    // * did not ask this question before
    iResult = iResult && !IWGetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",4);
    return iResult;
}
