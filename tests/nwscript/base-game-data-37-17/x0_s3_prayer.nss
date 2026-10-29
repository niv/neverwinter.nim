//::///////////////////////////////////////////////
//:: x0_s3_prayer
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Handles the prayerbox
    
    Requires the des_prayer.2da
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int CountNumberOfItems(object oItem);
string MatchItems(string s1, string s2);

void main()
{
    object oItem = GetSpellTargetObject(); //GetSpellCastItem();
    
    if (CountNumberOfItems(oItem) != 2)
    {
        SpeakStringByStrRef(40144);
    }
    else
    {
        // * visuals et cetera
        object oItem1 = GetFirstItemInInventory(oItem);
        object oItem2 = GetNextItemInInventory(oItem);
        if (GetIsObjectValid(oItem1) && GetIsObjectValid(oItem2))
        {
            string sResRef1 = GetResRef(oItem1);
            string sResRef2 = GetResRef(oItem2);

            string sMonsterResRef = MatchItems(sResRef1, sResRef2);
            if (sMonsterResRef == "null")
            {
                SpeakStringByStrRef(40145);
            }
            else
            {
                // * do proper summon
                //CreateObject(OBJECT_TYPE_CREATURE, sMonsterResRef, GetLocation(OBJECT_SELF));
                effect eSummon = EffectSummonCreature(sMonsterResRef,VFX_FNF_SUMMON_MONSTER_3);
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetLocation(OBJECT_SELF), TurnsToSeconds(12));
            }
        }
    }
    
}

// * Returns the string of the correct match
// * else null if match not right
string MatchItems(string s1, string s2)
{
    int nNumIndexes = StringToInt(Get2DAString("des_prayer", "Reagent1", 0));
    string sCurrent = "";
    
    int i = 0;
    
    // * loop through 2da looking for a match
    // * try to match s1 to Column 1
    for (i = 1; i <= nNumIndexes; i++)
    {
        sCurrent =  Get2DAString("des_prayer", "Reagent1", i);
        if (sCurrent == s1)
        {
            //SpeakString("match 1 found");
            sCurrent =  Get2DAString("des_prayer", "Reagent2", i);
            if (sCurrent == s2)
            {
                //SpeakString("match 2 found");
                return Get2DAString("des_prayer", "TemplateCreated", i);
            }
        }
    }
    // * try to match s2 to Column 1
    for (i = 1; i <= nNumIndexes; i++)
    {
        sCurrent =  Get2DAString("des_prayer", "Reagent1", i);
        if (sCurrent == s2)
        {
            //SpeakString("match 1 found");
            sCurrent =  Get2DAString("des_prayer", "Reagent2", i);
            if (sCurrent == s1)
            {
                //SpeakString("match 2 found");
                return Get2DAString("des_prayer", "TemplateCreated", i);
            }
        }
    }

    return "null";
}

int CountNumberOfItems(object oItem)
{
    object oSubItem = GetFirstItemInInventory(oItem);
    int nTotal = 0;
    
    while (GetIsObjectValid(oSubItem))
    {
        nTotal++;
        oSubItem = GetNextItemInInventory(oItem);
    }
    return nTotal;
}
