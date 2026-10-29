/*
    Intelligent Weapon: Enserric

    TRUE if the player did not yet ask the weapon to stop draining his health
    AND if we are in chapter2



    Georg Zoeller, 2003-10-10
*/

#include "x2_inc_intweapon"

int StartingConditional()
{
    int iResult;

 /* //cut
    iResult = !IWGetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",3);
    iResult =     IWGetIsHotUChapter2();
    */
    iResult = FALSE;
    return iResult;
}
