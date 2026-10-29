//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Generic recharging item.


        Target 1:
            Tries to charge an item however it requires an item in the off-hand. Whatever is there, is destroyed.

       Each use of the item restores 1 charge.
       Will kill the user if they are wounded.
       
       
       Test cases:
        - user fully healed
        - user damaged
        - user damage, 10 hitpoints will kill
        - on an item with full charges
        - on an item with no charges
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: March 20, 2003
//:://////////////////////////////////////////////

// * converts the stored cost to charges
int ConvertCostToCharge()
{
    int nValue = GetLocalInt(OBJECT_SELF, "X0_L_CHARGES_ELECTRIFIER");
    nValue = nValue / 1000;

    return nValue;
}
void main()
{
    object oItem = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nId = GetSpellId();
    
    if (GetIsObjectValid(oItem))
    {
        if (GetObjectType(oItem) == OBJECT_TYPE_ITEM)
        {
            // * charge
            if (nId == 509)
            {
                int nCharges = GetItemCharges(oItem);
                // * if item has some charges, then allow renewal
                if (nCharges > 0)
                {
                    int nNewCharges = ConvertCostToCharge();
                    if (nNewCharges >= 1)
                    {
                        // * null the cost stored on item
                        SetLocalInt(OBJECT_SELF, "X0_L_CHARGES_ELECTRIFIER", 0);
                        SetItemCharges(oItem, nCharges + nNewCharges);
                        SpeakStringByStrRef(40055);
                    }
                    else
                        SpeakStringByStrRef(40056);
                }
            }
            else
            if (nId == 510 && GetPlotFlag(oItem) == FALSE) // decharge
            {
                int nValue = GetGoldPieceValue(oItem);
                SpeakStringByStrRef(40057);
                int nPreviousValue = GetLocalInt(OBJECT_SELF, "X0_L_CHARGES_ELECTRIFIER");
                SetLocalInt(OBJECT_SELF, "X0_L_CHARGES_ELECTRIFIER", nPreviousValue + nValue);
                effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
                //SpeakString(IntToString(nPreviousValue + nValue));
                DestroyObject(oItem);
            }
        }
    }
}
