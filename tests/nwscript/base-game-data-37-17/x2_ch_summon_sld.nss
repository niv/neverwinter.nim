//::///////////////////////////////////////////////
//:: XP2 Associate: On Spawn In
//:: x2_ch_summon_sld
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

   Special Spawn in script for scaled epic shadow
   lord.

   It will always be 1 level below the character's
   shadowdancer level

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-24
//:://////////////////////////////////////////////

#include "X0_INC_HENAI"
#include "X2_INC_SUMMSCALE"


void DoScaleESL(object oSelf)
{
    if (GetStringLowerCase(GetTag(oSelf))== "x2_s_eshadlord")
    {
        SSMScaleEpicShadowLord(oSelf);

        // Epic Shadow Lord is incorporeal and gets a concealment bonus.
        effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
        eConceal = ExtraordinaryEffect(eConceal);
        effect eGhost = EffectCutsceneGhost();
        eGhost = ExtraordinaryEffect(eGhost);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, oSelf);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oSelf);
    }
    else if (GetStringLowerCase(GetTag(oSelf))== "x2_s_vrock")
    {
        SSMScaleEpicFiendishServant(oSelf);
    }
}
void main()
{
    //Sets up the special henchmen listening patterns
    SetAssociateListenPatterns();

    // Set additional henchman listening patterns
    bkSetListeningPatterns();

    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);

    //Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Distance: make henchmen stick closer
    SetAssociateState(NW_ASC_DISTANCE_4_METERS);
    if (GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster()) == OBJECT_SELF) {
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);
    }

    // Set starting location
    SetAssociateStartLocation();

    // GZ 2003-07-25:
    // There is a timing issue with the GetMaster() function not returning the master of a creature
    // immediately after spawn. Some code which might appear to make no sense has been added
    // to the nw_ch_ac1 and x2_inc_summon files to work around this
    // it is also the reason for the delaycommand below:
    object oSelf = OBJECT_SELF;
    DelayCommand(1.0f,DoScaleESL(oSelf));


}


