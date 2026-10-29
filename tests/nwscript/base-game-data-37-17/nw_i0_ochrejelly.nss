//::///////////////////////////////////////////////
//:: nw_i0_ochrejelly
//:: Copyright (c) 2004 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An include file for handling the "Split"
    functionality of the Ochre Jellies.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith K2 Hayward
//:: Created On: July, 2004
//:: Modified On: January, 2006
//:://////////////////////////////////////////////

void SplitCreature(object oCreature, int iHP);

void SplitCreature(object oCreature, int iHP)
{
    string sOchre1 = "nw_ochrejellylrg";	//was 'ochrejelly'
    //string sOchre2 = "ochrejelly2";
    string sOchre3 = "nw_ochrejellymed";
    //string sOchre4 = "ochrejelly4";
    string sOchre5 = "nw_ochrejellysml";
    //string sOchre6 = "ochrejelly6";

    int iHitDice = GetHitDice(oCreature);
    int iDifficulty = GetGameDifficulty();
    int iDamage;

    effect ePoof1 = EffectVisualEffect(VFX_COM_CHUNK_GREEN_MEDIUM);
    effect ePoof2 = EffectVisualEffect(VFX_COM_CHUNK_GREEN_SMALL);
    effect eLevelDown, eDamage;

    object oClone1;
    object oClone2;

    location lSpawn = GetLocation(oCreature);
    string sResRef = GetResRef(oCreature);

    // Find the correct Type and create it.
    if (sResRef == sOchre1)
    {
        oClone1 = CreateObject(OBJECT_TYPE_CREATURE, sOchre3, lSpawn, TRUE);	//was sOchre2
        oClone2 = CreateObject(OBJECT_TYPE_CREATURE, sOchre3, lSpawn, TRUE);	//was sOchre2
        iHitDice -= 2;	// was -1
    }
    /* else if (sResRef == sOchre2)
    {
        oClone1 = CreateObject(OBJECT_TYPE_CREATURE, sOchre3, lSpawn, TRUE);
        oClone2 = CreateObject(OBJECT_TYPE_CREATURE, sOchre3, lSpawn, TRUE);
        iHitDice -= 2;
    } */
    else if ((sResRef == sOchre3) && ((iDifficulty == GAME_DIFFICULTY_NORMAL)
        || (iDifficulty == GAME_DIFFICULTY_CORE_RULES)
        || (iDifficulty == GAME_DIFFICULTY_DIFFICULT)))
    {
        oClone1 = CreateObject(OBJECT_TYPE_CREATURE, sOchre5, lSpawn, TRUE);	//was sOchre4
        oClone2 = CreateObject(OBJECT_TYPE_CREATURE, sOchre5, lSpawn, TRUE);	//was sOchre4
        iHitDice -= 4;	//was -3
    }
    /* else if ((sResRef == sOchre4) && ((iDifficulty == GAME_DIFFICULTY_DIFFICULT)
        || (iDifficulty == GAME_DIFFICULTY_CORE_RULES)))
    {
        oClone1 = CreateObject(OBJECT_TYPE_CREATURE, sOchre5, lSpawn, TRUE);
        oClone2 = CreateObject(OBJECT_TYPE_CREATURE, sOchre5, lSpawn, TRUE);
        iHitDice -= 4;
    }
    else if ((sResRef == sOchre5) && (iDifficulty == GAME_DIFFICULTY_DIFFICULT))
    {
        oClone1 = CreateObject(OBJECT_TYPE_CREATURE, sOchre6, lSpawn, TRUE);
        oClone2 = CreateObject(OBJECT_TYPE_CREATURE, sOchre6, lSpawn, TRUE);
        iHitDice -= 5;
    } */

    if ((GetIsObjectValid(oClone1))&&(GetIsObjectValid(oClone2)))
    {
        iDamage = GetCurrentHitPoints(oClone1) - (iHP/2);
        eDamage = EffectDamage(iDamage);


        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, ePoof1, lSpawn);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoof2, oClone1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoof2, oClone2);

        // Reduce the hitpoints of the Jellies and take away a level
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oClone1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oClone2);

        // If the Level of the monster is greater then 1 reduce it by a level
        eLevelDown = EffectNegativeLevel(iHitDice, TRUE);
        if (iHitDice > 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLevelDown, oClone1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLevelDown, oClone2);
        }

        AssignCommand(oCreature, ClearAllActions(TRUE));
        DestroyObject(oCreature);
    }
}
