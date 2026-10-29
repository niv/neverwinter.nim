//::///////////////////////////////////////////////
// TRUE if this is being called by the special conversation
// flag from OnSpawn AND it has not occurred before.
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

int StartingConditional()
{
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION))
    {
        if(!GetIsObjectValid(GetPCSpeaker()) && !GetLocalInt(OBJECT_SELF, "GREETING_1"))
        {
            return TRUE;
        }
    }
    return FALSE;
}

