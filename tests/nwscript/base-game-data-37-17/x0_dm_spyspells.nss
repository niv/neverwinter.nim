//::///////////////////////////////////////////////
//:: x0_dm_spyspells
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will list all the spells that all
    creatures in the area can cast.
    
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: February 2003
//:://////////////////////////////////////////////

void SpyParseSpells(object oTarget)
{
    string sTag = GetTag(oTarget);
    ActionSpeakString("SPY:: SPELLS FOR " + sTag);
    
    int nMaxSpells = 503;
    int i = 0;
    for (i=0; i<=nMaxSpells; i++)
    {
        if (GetHasSpell(i, oTarget) > 0)
        {
            string sName = Get2DAString("spells", "Name", i);
            string sLevel = Get2DAString("spells", "Innate", i);
            //SpeakString("SPELLS " + sTag);
            SpeakString(" INNATE = " + sLevel);
            ActionSpeakStringByStrRef(StringToInt(sName) );
        }
    }
}

void main()
{
    object oTarget;
    
    oTarget = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oTarget) == TRUE)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            SpyParseSpells(oTarget);
        }
        oTarget = GetNextObjectInArea(GetArea(OBJECT_SELF));
    }
}
