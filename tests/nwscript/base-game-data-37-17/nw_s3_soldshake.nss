//::///////////////////////////////////////////////
//:: Disease: Soldier Shakes, On Rest
//:: NW_S3_SoldShake
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Chooses a random ability score and applies
    1 point of ability damage to that ability score
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  , 2001
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    int nChoice = d6();
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eAbility;
    object oTarget = OBJECT_SELF;
    //Set the ability score to be lowered
    switch (nChoice)
    {
        case 1:
            nChoice = ABILITY_CHARISMA;
        break;
        case 2:
            nChoice = ABILITY_CONSTITUTION;
        break;
        case 3:
            nChoice = ABILITY_DEXTERITY;
        break;
        case 4:
            nChoice = ABILITY_INTELLIGENCE;
        break;
        case 5:
            nChoice = ABILITY_STRENGTH;
        break;
        case 6:
            nChoice = ABILITY_WISDOM;
        break;
    }
    //Set the ability damage effect
    eAbility = EffectAbilityDecrease(nChoice, 1);
    eAbility = SupernaturalEffect(eAbility);
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbility, oTarget);
}
