void main()
{
    object oItem = GetModuleItemLost();
    object oPC = GetModuleItemLostBy();
    string sItemTag = GetTag(oItem);

     //The portal stone
    //if (sItemTag == "x2_p_reaper")
    //{
    //    object oPC = GetModuleItemLostBy();
    //    DestroyObject(oItem);
    //    CreateItemOnObject("x2_p_reaper", oPC);
    //    string sMes = GetStringByStrRef(84467);
    //    SendMessageToPC(oPC, sMes);
    //}
    //a powderkeg
    //else
    if (sItemTag == "x2_it_pkeg")
    {
        //Check to see if the current item possessor is valid - if so - assume it was given to a henchman so don't make the placeable
        if (GetIsObjectValid(GetItemPossessor(oItem)) == FALSE)
        {
            location lLoc = GetLocation(oItem);
            DestroyObject(oItem);
            CreateObject(OBJECT_TYPE_PLACEABLE,"x2_plc_pkeg",lLoc);
        }
    }
    // Golem Attractor
    else if(sItemTag == "q4b_GolemAttractorItem")
    {
        object oNewPossessor = GetItemPossessor(oItem);
        if (GetIsObjectValid(oNewPossessor) == FALSE)
        {
            location lLoc = GetLocation(oPC);
            DestroyObject(oItem);
            CreateObject(OBJECT_TYPE_PLACEABLE, "q4b_plc_attr", lLoc);
        }
    }
    // Crystal of Undeath
    else if(sItemTag == "q3_artifact")
    {
        effect eEff = GetFirstEffect(oPC);
        while(GetIsEffectValid(eEff))
        {
            if(GetEffectType(eEff) == EFFECT_TYPE_ABILITY_DECREASE &&
                GetEffectCreator(eEff) == OBJECT_SELF)
            {
                RemoveEffect(oPC, eEff);
            }

            eEff = GetNextEffect(oPC);
        }
    }
    else
    {
        SetLocalObject(OBJECT_SELF, "X2_ITEM_UNACQUIRED", oItem);
        SetLocalObject(OBJECT_SELF, "X2_ITEM_UNACQUIRED_BY", oPC);
        SignalEvent(OBJECT_SELF, EventUserDefined(4555));
    }
}
