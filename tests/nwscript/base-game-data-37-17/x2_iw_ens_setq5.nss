/*
    Intelligent Weapon: Enserric
    Set the flag that we asked the "Are You Allright" question,

    Georg Zoeller, 2003-10-10
*/

#include "x2_inc_intweapon"
void main()
{
    IWSetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",5);
}


