//::///////////////////////////////////////////////
//:: Heal at 75%
//:: NW_D2_HEAL_75
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

void main()
{
    SetAssociateState(NW_ASC_HEAL_AT_75);
    SetAssociateState(NW_ASC_HEAL_AT_50, FALSE);
    SetAssociateState(NW_ASC_HEAL_AT_25, FALSE);
}
