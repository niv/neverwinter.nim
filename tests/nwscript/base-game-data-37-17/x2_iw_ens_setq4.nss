/*
    Intelligent Weapon: Enserric
    Set the flag that the player has talked to the sword about getting out
    of it's shell

    Georg Zoeller, 2003-10-10
*/

#include "x2_inc_intweapon"
void main()
{
    IWSetQuestionAsked(GetPCSpeaker(),"x2_iw_enserric",4);
}

