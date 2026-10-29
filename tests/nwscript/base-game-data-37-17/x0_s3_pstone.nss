//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Power stone abilities
*/
//:://////////////////////////////////////////////
//:: Created By: Yaron
//:: Created On: 28/3/2003
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

void DoStorm(object oPC, int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE)
{
    object oTarget = OBJECT_INVALID;
    int nCasterLvl = 15;
    int nDamage = 0;
    int nCnt = 0;
    effect eMissile = EffectVisualEffect(nMIRV);
    effect eVis = EffectVisualEffect(nVIS);
    float fDist = 0.0;
    float fDelay = 0.0;
    float fDelay2, fTime;
    location lTarget = GetLocation(oPC); // missile spread centered around caster
    int nMissiles = nCasterLvl;

    if (nMissiles > nCap)
    {
        nMissiles = nCap;
    }

        /* New Algorithm
            1. Count # of targets
            2. Determine number of missiles
            3. First target gets a missile and all Excess missiles
            4. Rest of targets (max nMissiles) get one missile
       */
    int nEnemies = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // * caster cannot be harmed by this spell
        //if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        if(GetReputation(oTarget, OBJECT_SELF) == 0)
        {
            nEnemies++;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }
     if (nEnemies == 0) return; // * Exit if no enemies to hit
     if(nEnemies > nMissiles)
     {
        nMissiles = nEnemies;
     }
     //int nExtraMissiles = nMissiles / nEnemies;

     //by default the Remainder will be 0 (if more than enough enemies for all the missiles)
     int nRemainder = 0;

     //if (nExtraMissiles >0)
     //   nRemainder = nMissiles % nEnemies;

     //if (nEnemies > nMissiles)
     //   nEnemies = nMissiles;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if(GetIsEnemy(oTarget))
        {
                // * recalculate appropriate distances

                fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
                fDelay = fDist/(3.0 * log(fDist) + 2.0);

                /*if (nONEHIT == TRUE)
                {
                    nExtraMissiles = 1;
                    nRemainder = 0;
                }*/

                 //Roll damage
                int nDam = d6(nD6Dice);
                //Enter Metamagic conditions

                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

                //Set damage effect
                effect eDam = EffectDamage(nDam, nDAMAGETYPE);
                //Apply the MIRV and damage effect
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

                nCnt++;// * increment count of missiles fired
                nRemainder = 0;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

}

void main()
{
    object oPC = OBJECT_SELF;
    // offensive powers:
    if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_OFF") == 1)
    {
        DoStorm(oPC, 10, 1, SPELL_FIREBRAND, VFX_IMP_MIRV_FLAME, VFX_IMP_FLAME_M, DAMAGE_TYPE_FIRE, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_OFF") == 2)
    {
        DoStorm(oPC, 10, 10, SPELL_FIREBRAND, VFX_IMP_MIRV_FLAME, VFX_IMP_FLAME_M, DAMAGE_TYPE_FIRE, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_OFF") == 3)
    {
        object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
        ActionCastSpellAtObject(SPELL_SLOW, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_OFF") == 4)
    {
        object oCaster = oPC;
        int nCasterLvl = 20;
        int nDamage;
        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
        effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
        effect eDam;
        int nRand;
        //Get the spell target location as opposed to the spell target.
        location lTarget = GetLocation(oPC);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);

        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                DestroyObject(oTarget);
            }
            else
            if (oTarget != oPC && GetIsEnemy(oTarget))
            {
                {
                    fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                    // * unlocked doors will reverse their open state
                    if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
                    {
                        if (GetLocked(oTarget) == FALSE)
                        {
                            if (GetIsOpen(oTarget) == FALSE)
                            {
                                AssignCommand(oTarget, ActionOpenDoor(oTarget));
                            }
                            else
                                AssignCommand(oTarget, ActionCloseDoor(oTarget));
                        }
                    }
                    if(!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, 20))
                    {
                        nRand = d4(1) + 2;
                        effect eKnockdown = EffectKnockdown();
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(nRand));
                        // Apply effects to the currently selected target.
                        nRand = d6(2);
                        eDam = EffectDamage(nRand);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                     }

                 }
            }
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
        }
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_OFF") == 5)
    {
        object oTarget;
        object oLowest;
        effect eDeath =  EffectDeath();
        effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
        effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
        int bContinueLoop = FALSE; //Used to determine if we have a next valid target
        int nHD = d4(12); //Roll to see how many HD worth of creature will be killed
        int nCurrentHD;
        int bAlreadyAffected;
        int nMax = 10;// maximun hd creature affected, set this to 9 so that a lower HD creature is chosen automatically
        //Also 9 is the maximum HD a creature can have and still be affected by the spell
        float fDelay;
        string sIdentifier = GetTag(oPC);

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetSpellTargetLocation());
        //Check for at least one valid object to start the main loop
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        if (GetIsObjectValid(oTarget))
        {
            bContinueLoop = TRUE;
        }
        // The above checks to see if there is at least one valid target.  If no value target exists we do not enter
        // the loop.

        while ((nHD > 0) && (bContinueLoop))
        {
            int nLow = nMax; //Set nLow to the lowest HD creature in the last pass through the loop
            bContinueLoop = FALSE; //Set this to false so that the loop only continues in the case of new low HD creature
            //Get first target creature in loop
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
            while (GetIsObjectValid(oTarget))
            {
                //Make sure the currect target is not an enemy
                if (GetIsEnemy(oTarget) && oTarget != OBJECT_SELF)
                {
                    //Get a local set on the creature that checks if the spell has already allowed them to save
                    bAlreadyAffected = GetLocalInt(oTarget, "bDEATH" + sIdentifier);
                    if (!bAlreadyAffected)
                    {
                         nCurrentHD = GetHitDice(oTarget);
                         //If the selected creature is of lower HD then the current nLow value and
                         //the HD of the creature is of less HD than the number of HD available for
                         //the spell to affect then set the creature as the currect primary target
                         if(nCurrentHD < nLow && nCurrentHD <= nHD)
                         {
                             nLow = nCurrentHD;
                             oLowest = oTarget;
                             bContinueLoop = TRUE;
                         }
                    }
                }
                //Get next target in shape to test for a new
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
            }
            //Check to make sure that oLowest has changed
            if(bContinueLoop == TRUE)
            {
                //Make a Fort Save versus death effects
                if(!MySavingThrow(SAVING_THROW_FORT, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oLowest));
                    //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest));
                }
                //Even if the target made their save mark them as having been affected by the spell
                SetLocalInt(oLowest, "bDEATH" + sIdentifier, TRUE);
                //Destroy the local after 1/4 of a second in case other Circles of Death are cast on
                //the creature laster
                DelayCommand(fDelay + 0.25, DeleteLocalInt(oLowest, "bDEATH" + sIdentifier));
                //Adjust the number of HD that have been affected by the spell
                nHD = nHD - GetHitDice(oLowest);
                oLowest = OBJECT_INVALID;
            }
        }
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_OFF") == 6)
    {
        int n = 1;
        effect eStun = EffectStunned();
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
        effect eLink = EffectLinkEffects(eMind, eStun);
        effect eVis = EffectVisualEffect(VFX_IMP_STUN);
        effect eWord = EffectVisualEffect(VFX_FNF_PWSTUN);
        object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, n);
        while(oCreature != OBJECT_INVALID)
        {
            if(GetIsEnemy(oCreature))
            {
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oCreature, 18))
                {
                     ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWord, GetLocation(oCreature));
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCreature);
                     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCreature, 6.0);
                }
            }
            n++;
            oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC, n);
        }
    }


    //defensive powers:
    if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_DEF") == 1)
    {
        ActionCastSpellAtObject(SPELL_SPELL_MANTLE, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_DEF") == 2)
    {
        ActionCastSpellAtObject(SPELL_GREATER_SPELL_MANTLE, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_DEF") == 3)
    {
        ActionCastSpellAtObject(SPELL_HASTE, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_DEF") == 4)
    {
        ActionCastSpellAtObject(SPELL_GREATER_STONESKIN, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_DEF") == 5)
    {
        ActionCastSpellAtObject(SPELL_ENERGY_BUFFER, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
    else if(GetCampaignInt("dbItems", "Q3B_POWERSTONE_DEF") == 6)
    {
        ActionCastSpellAtObject(SPELL_IMPROVED_INVISIBILITY, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
    }
}
