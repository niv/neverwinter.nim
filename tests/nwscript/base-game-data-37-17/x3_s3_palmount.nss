//::///////////////////////////////////////////////
//:: Summon Paladin Mount
//:: x3_s3_palmount
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script handles the summoning of the paladin mount.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: 2007-18-12
//:: Last Update: March 29th, 2008
//:://////////////////////////////////////////////

/*
    On the module object set X3_HORSE_PALADIN_USE_PHB to 1 as an integer
    variable if you want the duration to match that found in the 3.5 edition
    version of the Player's Handbook.

*/

#include "x3_inc_horse"

void main()
{
    object oPC=OBJECT_SELF;
    object oMount;
    int bPHBDuration=GetLocalInt(GetModule(),"X3_HORSE_PALADIN_USE_PHB");
    int bNoMounts=FALSE;
    string sSummonScript;
    object oAreaTarget=GetArea(oPC); // used for mount restriction checking

    if (!GetLocalInt(oAreaTarget,"X3_MOUNT_OK_EXCEPTION"))
    { // check for global restrictions
        if (GetLocalInt(GetModule(),"X3_MOUNTS_EXTERNAL_ONLY")&&GetIsAreaInterior(oAreaTarget)) bNoMounts=TRUE;
        else if (GetLocalInt(GetModule(),"X3_MOUNTS_NO_UNDERGROUND")&&!GetIsAreaAboveGround(oAreaTarget)) bNoMounts=TRUE;
    } // check for global restrictions

    if (GetLocalInt(GetArea(oPC),"X3_NO_HORSES")||bNoMounts)
    { // no horses allowed in the area
        DelayCommand(1.0,IncrementRemainingFeatUses(oPC,FEAT_PALADIN_SUMMON_MOUNT));
        FloatingTextStrRefOnCreature(111986,oPC,FALSE);
        return;
    } // no horses allowed in the area

    if (GetSpellId()==SPELL_PALADIN_SUMMON_MOUNT)
    { // Paladin Mount Summon
        oMount=HorseGetPaladinMount(oPC);
        if (!GetIsObjectValid(oMount)) oMount=GetLocalObject(oPC,"oX3PaladinMount");
        if (GetIsObjectValid(oMount))
        { // mount already exists
            if (GetIsPC(oPC))
            { // send messages
                if (oMount==oPC) FloatingTextStrRefOnCreature(111987,oPC,FALSE);
                else { FloatingTextStrRefOnCreature(111988,oPC,FALSE); }
            } // send messages
            DelayCommand(1.0,IncrementRemainingFeatUses(oPC,FEAT_PALADIN_SUMMON_MOUNT));
            return;
        } // mount already exists
        sSummonScript=GetLocalString(GetModule(),"X3_PALMOUNT_SUMMONOVR");
        if (GetStringLength(GetLocalString(oPC,"X3_PALMOUNT_SUMMONOVR"))>0) sSummonScript=GetLocalString(oPC,"X3_PALMOUNT_SUMMONOVR");
        if (GetStringLength(sSummonScript)<1)
        { // no summon paladin mount override
            oMount=HorseSummonPaladinMount(bPHBDuration);
        } // no summon paladin mount override
        else
        { // execute summon script
            ExecuteScript(sSummonScript,oPC);
        } // execute summon script
    } // Paladin Mount Summon
}
