//::///////////////////////////////////////////////
//:: Heartbeat Event
//:: x3_mod_def_hb
//:: (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This heartbeat exists only to make sure it
    handles in its own way the benefits of having
    the feat Mounted Combat.   See the script
    x3_inc_horse for complete details of variables
    and flags that can be used with this.   This script
    is also used to provide support for persistence.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva Winblood
//:: Created On: April 2nd, 2008
//:://////////////////////////////////////////////

#include "x3_inc_horse"





/////////////////////////////////////////////////////////////[ MAIN ]///////////
void main()
{
    object oPC=GetFirstPC();
    int nRoll;
    int bNoCombat=GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT");
    while(GetIsObjectValid(oPC))
    { // PC traversal
        if (GetLocalInt(oPC,"bX3_STORE_MOUNT_INFO"))
        { // store
            DeleteLocalInt(oPC,"bX3_STORE_MOUNT_INFO");
            HorseSaveToDatabase(oPC,X3_HORSE_DATABASE);
        } // store
        if (!bNoCombat&&GetHasFeat(FEAT_MOUNTED_COMBAT,oPC)&&HorseGetIsMounted(oPC))
        { // check for AC increase
            nRoll=d20()+GetSkillRank(SKILL_RIDE,oPC);
            nRoll=nRoll-10;
            if (nRoll>4)
            { // ac increase
                nRoll=nRoll/5;
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectACIncrease(nRoll),oPC,7.0);
            } // ac increase
        } // check for AC increase
        oPC=GetNextPC();
    } // PC traversal
}
/////////////////////////////////////////////////////////////[ MAIN ]///////////
