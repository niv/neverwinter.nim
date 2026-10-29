//::///////////////////////////////////////////////
//:: Custom Mindflayer AI
//:: x2_ai_mflayer
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the Hordes of the Underdark campaign
    Mini AI run on the mindflayer.

    It does not use any spells assigned to the
    mindflayer, if you want to make a custom mindflayer
    you need to deactivate this AI by removing the
    approriate variable from your beholder creature
    in the toolset


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-21
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "x0_i0_spells"
#include "x2_inc_switches"
#include "x2_inc_toollib"

const int X2_MINDFLAYER_TELEPORT_MAXUSES = 10;

int MFGetTargetConditionSucks(object oTarget)
{
   // if polymorphed we do not suck
   if (GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget) == TRUE)
   {
        return FALSE;
   }

   if (GetHasEffect(EFFECT_TYPE_STUNNED, oTarget) || GetHasEffect(EFFECT_TYPE_PARALYZE, oTarget)
       || GetHasEffect(VFX_DUR_PARALYZE_HOLD, oTarget) || GetHasEffect(VFX_DUR_PARALYZE_HOLD, oTarget) )
   {
         return TRUE;
   }
   else
   {
       // if dazed, try to brainsuck only 30% of the time)
       if (GetHasEffect(EFFECT_TYPE_DAZED, oTarget) && (Random(100)<30) )
       {
            return TRUE;
       }
        return FALSE;
   }

}

void MFlayerSuck(object oTarget)
{
   if (  GetDistanceBetween( OBJECT_SELF, oTarget ) < 1.5f)
    {
        ActionMoveAwayFromObject(oTarget, FALSE, 1.5f);
    }
    ActionMoveToObject( oTarget, FALSE, 1.5f);
    ActionDoCommand(SetFacingPoint( GetPositionFromLocation(GetLocation(oTarget))));
    ActionWait(0.5f);
    if (MFGetTargetConditionSucks(oTarget))
    {
        ActionCastSpellAtObject(716, oTarget,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT);
    }
    else
    {
        ActionCastSpellAtObject(551, oTarget,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT);
    }

}

int MFlayerDoPsionics(object oTarget)
{
    return TalentSpellAttack(oTarget);
}


void MFlayClearFleeState()
{
    DeleteLocalInt(OBJECT_SELF,"X2_MFLAYER_AI_FLEEING");
}

void MFlayClearState()
{
    if (GetCurrentAction(OBJECT_SELF) == ACTION_ATTACKOBJECT || GetCurrentAction(OBJECT_SELF) == ACTION_MOVETOPOINT )
    {
       ClearAllActions();
    }
}

/*
int TryToTeleport(object oTargetFrom, int bCloseIn = FALSE)
{
    int nTeleportCounter =  GetLocalInt(OBJECT_SELF,"X2_MINDFLAYER_AI_TELECOUNT");

    if (nTeleportCounter > X2_MINDFLAYER_TELEPORT_MAXUSES)
    {
        return FALSE;
    }
    else
    {
        nTeleportCounter ++;
        SetLocalInt(OBJECT_SELF,"X2_MINDFLAYER_AI_TELECOUNT",nTeleportCounter);
    }

    object oExit;

    if (bCloseIn)
    {
         oExit   = GetNearestObjectByTag("X2_WP_MFLAYER_EXIT",oTargetFrom);
    }
    else
    {
         oExit   = GetNearestObjectByTag("X2_WP_MFLAYER_EXIT");
    }

    if (!GetIsObjectValid(oExit))
    {
        return FALSE;
    }
    float fDist = GetDistanceBetween(oExit,oTargetFrom);
    int bJump;

    if (bCloseIn)
    {
         if ((fDist >= 8.0f) && (fDist <= 20.0f))
        {
           bJump = TRUE;
        }
    }
    else
    {
        if ((fDist >= 10.0f) && (fDist <= 40.0f))
        {
           bJump = TRUE;
        }
    }

    if (!bJump)
    {
        if (bCloseIn)
        {
             oExit   = GetNearestObjectByTag("X2_WP_MFLAYER_EXIT",oTargetFrom,2);
        }
        else
        {
             oExit   = GetNearestObjectByTag("X2_WP_MFLAYER_EXIT",OBJECT_SELF,2);
        }

        if (!GetIsObjectValid(oExit))
        {
            return FALSE;
        }
        else
        {
            fDist = GetDistanceBetween(oExit,oTargetFrom);
            if (bCloseIn)
            {
                if ((fDist >= 6.0f) && (fDist <= 15.0f))
                {
                   bJump = TRUE;
                }
            }
            else
            {
                if ((fDist >= 8.0f) && (fDist <= 50.0f))
                {
                   bJump = TRUE;
                }
            }
        }

    }

    if (bJump)
    {
        if (!GetIsDead(OBJECT_SELF))
        {

            effect eAppear = EffectDisappearAppear(GetLocation(oExit)) ;
            eAppear = ExtraordinaryEffect(eAppear);
            object oSelf = OBJECT_SELF;
            //effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSelf);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAppear,oSelf,4.0f);

        }
        return TRUE;
    }
    else
    {
        return FALSE;
    }


    return TRUE;
}
*/



// 1 - Melee
// 2 - Suck
int  GetMindFlayerTactics(object oTarget)
{
   int nRet  = FALSE;

   // we go melee against petrified targets
   if (GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) == TRUE)
   {
        nRet  = 1;
   }
   else if (GetIsPlayableRacialType(oTarget) && MFGetTargetConditionSucks(oTarget) || GetSubRace(oTarget)== "Tiefling")
   {
        nRet =  2;
   }
   // if the target is down below 10 hp and AC is below 23, we go into melee as well
   else if  ( GetCurrentHitPoints(oTarget) < 10 && GetAC(oTarget) < 23)
   {
        nRet  = 1;
   }



   return nRet;
}

void main()
{
    //The following two lines should not be touched
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget();

    // ********************* Start of custom AI script ****************************


    // Here you can write your own AI to run in place of DetermineCombatRound.
    // The minimalistic approach would be something like
    //
    // TalentFlee(oTarget); // flee on any combat activity

    if(GetAssociateState(NW_ASC_IS_BUSY))
    {
        return;
    }

    if (GetIsObjectValid(oIntruder) == FALSE)
        oIntruder = bkAcquireTarget();

    if(BashDoorCheck(oIntruder)) {return;}
    // * BK: stop fighting if something bizarre that shouldn't happen, happens
    if (bkEvaluationSanityCheck(oIntruder, GetFollowDistance()) == TRUE)
    {
        return;
    }

    if (GetIsObjectValid(oIntruder) == FALSE || GetIsDead(oIntruder))
    {
        return; // fall back to default AI because SetCreatureOverrideAIScriptFinished(); wasnt called        t cal
    }

    int nTactics = GetMindFlayerTactics(oIntruder);
    if (nTactics == 2)
    {
        __TurnCombatRoundOn(TRUE);
        MFlayerSuck(oIntruder);
        __TurnCombatRoundOn(FALSE);
        SetCreatureOverrideAIScriptFinished();
    }
    else
    {
        return; // fall back to default AI because SetCreatureOverrideAIScriptFinished(); wasnt called        t cal
    }


}
