//::///////////////////////////////////////////////
//:: x0_dm_spyskill
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cheat script to reveal the skill
    rankings of all creatures in the area.
    Useful for debugging spell bug problems.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: March 2003
//:://////////////////////////////////////////////
void SpyParseSkills(object oTarget)
{
    string sTag = GetTag(oTarget);
    ActionSpeakString("SPY:: SKILLS FOR " + sTag);

    int nMaxSpells = 22;
    int i = 0;
    for (i=0; i<=nMaxSpells; i++)
    {
        //if (GetHasSpell(i, oTarget) > 0)
        {
            string sName = Get2DAString("skills", "Name", i);
            int nRank  = GetSkillRank(i, oTarget);
            //SpeakString("SPELLS " + sTag);
            SpeakStringByStrRef(StringToInt(sName) );
            SpeakString(" RANK = " + IntToString(nRank));
        }
    }
}

void main()
{
//    object oTarget;

//    oTarget = GetFirstObjectInArea(GetArea(OBJECT_SELF));
//    while (GetIsObjectValid(oTarget) == TRUE)
//    {
 //       if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
 //       {
            SpeakString("-------------------------------");
            object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE);
            SpyParseSkills(oTarget);
//        }
//        oTarget = GetNextObjectInArea(GetArea(OBJECT_SELF));
//    }
}


