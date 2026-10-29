//::///////////////////////////////////////////////
//::
//:: On Attacked: Init conversation
//::
//:: NW_D8_Default5.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Acts like a DEFAULT creature but will initiate
//:: dialog the first time that a PC attacks him.
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 10, 2001
//::
//:://////////////////////////////////////////////
#include "designinclude"

void main()
{
    if ((GetIsPC(GetLastAttacker()) == TRUE) && (GetLocalInt(OBJECT_SELF,"NW_L_IWASATTACKED") == 0))
    {
        SetLocalInt(OBJECT_SELF,"NW_L_IWASATTACKED",1);
        ActionStartConversation(GetLastAttacker());
        // * MAKE HOSTILE
        //SetIsEnemy(GetLastAttacker());
    }
}


