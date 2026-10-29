// On-item acquired: handle any global items and send a local user-defined event to the module
// to hanlde any other plot items.
#include "x2_inc_intweapon"
void main()
{
    object oItem = GetModuleItemAcquired();
    object oPC = GetModuleItemAcquiredBy();
    object oFrom = GetModuleItemAcquiredFrom();
    
    // Player tries to give the deva an item other then her mace
    if(GetTag(oPC) == "q3c_Lavoera" && GetTag(oItem) != "q3_dist_mace" )
    {
        SendMessageToPCByStrRef(oFrom, 100776);
        AssignCommand(oPC, ClearAllActions());
        DelayCommand(0.2, AssignCommand(oPC, ActionGiveItem(oItem, oFrom)));
    }
    /*else if(GetTag(oItem) == "q3_artifact")
    {
        object oSparks = GetNearestObjectByTag("MagicSparksRed");
        if(oSparks != OBJECT_INVALID)
            DestroyObject(oSparks);
        // The artifact from the draclich: some negative effects on user when acquired
        effect eAbDec1 = EffectAbilityDecrease(ABILITY_CHARISMA, 4);
        effect eAbDec2 = EffectAbilityDecrease(ABILITY_CONSTITUTION, 4);
        effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        effect eLink = EffectLinkEffects(eAbDec1, eAbDec2);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    } */
    //the Intelligent weapon (starts off as the black longsword)
    else if(GetTag(oItem) == "iw_fakelongsword")
    {
        if (GetIsPC(oPC) == FALSE)
            return;

        object oWeapon;
        int nWeapon = GetLocalInt(GetModule(), "IW_CHGWPN");

        if (nWeapon < 2)
        {
            oWeapon = CreateItemOnObject("iw_longsword", oPC);
        }
        else if (nWeapon == 2)
        {
            oWeapon = CreateItemOnObject("iw_dagger", oPC);
        }
        else if (nWeapon == 3)
        {
            oWeapon = CreateItemOnObject("iw_shortsword", oPC);
        }
        else if (nWeapon == 4)
        {
            oWeapon = CreateItemOnObject("iw_greatsword", oPC);
        }
        DestroyObject(oItem);
        IWCreateIntelligentWeapon(oWeapon);
    }

    else
    {
        SetLocalObject(OBJECT_SELF, "X2_ITEM_ACQUIRED", oItem);
        SetLocalObject(OBJECT_SELF, "X2_ITEM_ACQUIRED_BY", oPC);
        SignalEvent(OBJECT_SELF, EventUserDefined(4554));
    }
}
