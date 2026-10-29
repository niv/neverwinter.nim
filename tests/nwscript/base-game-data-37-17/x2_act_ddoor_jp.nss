//::///////////////////////////////////////////////
//:: x2_act_ddoor_jp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_portal"

void main()
{
    PortalJumpToPlayerDeath(GetPCSpeaker());
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), GetLocation(GetObjectByTag("x2_deathdoor")));
    DestroyObject(OBJECT_SELF, 0.5);
}

