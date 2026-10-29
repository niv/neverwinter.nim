/*
    Intelligent Weapon Interjections
    Asked about the negative effects the blade has

    Georg Zoeller, 2003-09-05
*/

#include "x2_inc_intweapon"
void main()
{
    DeleteLocalInt(GetPCSpeaker(),"X2_L_ENSERRIC_ASKED_Q3");
    IWSetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",3);
}
