//::///////////////////////////////////////////////
//:: x2_hb_secretdoor
//:: Copyright (c) 2001-3 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script runs on either the Hidden Trap Door
    or Hidden Wall Door Trigger invisible objects.
    This script will do a check and see
    if any PC comes within a radius of this Trigger.

    If the PC has the search skill or is an Elf then
    a search check will be made.

    It will create a Trap or Wall door that will have
    its Destination set to a waypoint that has
    a tag of <tag of this object>a or <tag of this object>b

    The radius is determined by the Reflex saving
    throw of the invisible object

    The DC of the search stored by the Willpower
    saving throw.

*/
//:://////////////////////////////////////////////
//:: Created By  : Robert Babiak
//:: Created On  : June 25, 2002
//::---------------------------------------------
//:: Modified By : Robert, Andrew, Derek, Georg
//:: Modified On : July 2002 - September 2003
//:://////////////////////////////////////////////

void main()
{
    int nDoOnce = GetLocalInt(OBJECT_SELF, "X2_L_DOOR_DO_CREATE_ONCE");
    if(nDoOnce == 1)
         return;
    // get the radius and DC of the secret door.
    float fSearchDist = IntToFloat(GetReflexSavingThrow(OBJECT_SELF));
    int nDiffaculty = GetWillSavingThrow(OBJECT_SELF);

    // what is the tag of this object used in setting the destination
    string sTag = GetTag(OBJECT_SELF);

    // has it been found?
    int nDone = GetLocalInt(OBJECT_SELF,"D_"+sTag);
    int nReset = GetLocalInt(OBJECT_SELF,"Reset");

    // ok reset the door is destroyed, and the done and reset flas are made 0 again
    if (nReset == 1)
    {
        nDone = 0;
        nReset = 0;

        SetLocalInt(OBJECT_SELF,"D_"+sTag,nDone);
        SetLocalInt(OBJECT_SELF,"Reset",nReset);

        object oidDoor= GetLocalObject(OBJECT_SELF,"Door");
        if (oidDoor != OBJECT_INVALID)
        {
            SetPlotFlag(oidDoor,0);
            DestroyObject(oidDoor,GetLocalFloat(OBJECT_SELF,"ResetDelay"));
        }

    }


    int nBestSkill = -50;
    object oidBestSearcher = OBJECT_INVALID;
    int nCount = 1;

    // Find the best searcher within the search radius.
    object oidNearestCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
    int nDoneSearch = 0;
    int nFoundPCs = 0;

    while ((nDone == 0) &&
           (nDoneSearch == 0) &&
           (oidNearestCreature != OBJECT_INVALID)
          )
    {
        if(GetMaster(oidNearestCreature) != OBJECT_INVALID || GetIsPC(oidNearestCreature))
        {
            // what is the distance of the PC to the door location
            float fDist = GetDistanceBetween(OBJECT_SELF,oidNearestCreature);

            if (fDist <= fSearchDist)
            {
                if (LineOfSightObject(OBJECT_SELF, oidNearestCreature) == TRUE)
                {
                    int nSkill = GetSkillRank(SKILL_SEARCH,oidNearestCreature);

                    if (nSkill > nBestSkill)
                    {
                        nBestSkill = nSkill;
                        oidBestSearcher = oidNearestCreature;
                    }
                    nFoundPCs = nFoundPCs +1;
                }
                else
                {
                    //The Secret door is on the other side of the wall - so don't find it
                    nDoneSearch = 1;
                }
            }
            else
            {
                // If there is no one in the search radius, don't continue to search
                // for the best skill.
                nDoneSearch = 1;
            }
        }
        nCount = nCount +1;
        oidNearestCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF ,nCount);
    }

    if ((nDone == 0) &&
        (nFoundPCs != 0) &&
        (GetIsObjectValid(oidBestSearcher))
       )
    {
       int nMod = d20();

            // did we find it.
       if ((nBestSkill +nMod > nDiffaculty))
       {
            location locLoc = GetLocation (OBJECT_SELF);
            object oidDoor;
            // yes we found it, now create the appropriate door
            oidDoor = CreateObject(OBJECT_TYPE_PLACEABLE,"x2_secret_door",locLoc,TRUE);

            // flash secret door if not disabled
            if (GetLocalInt(GetModule(),"X2_SWITCH_DISABLE_SECRET_DOOR_FLASH") == FALSE)
            {
                effect eVis = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_GREEN);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oidDoor,10.0f);
            }

            int nLen = GetStringLength(sTag);
            string sNewTag = GetStringLeft(sTag, nLen - 1);

            if(GetStringRight(sTag, 1) == "a")
            {
                SetLocalString( oidDoor, "Destination" , sNewTag + "b" );
            }
            else
            {
                SetLocalString( oidDoor, "Destination" , sNewTag + "a" );
            }

            object oDest = GetNearestObjectByTag(GetLocalString(oidDoor, "Destination"));
            SignalEvent(oDest, EventUserDefined(101));
            PlayVoiceChat(VOICE_CHAT_LOOKHERE, oidBestSearcher);
            SetLocalInt(OBJECT_SELF,"D_"+sTag,1);
            SetPlotFlag(oidDoor,1);
            SetLocalObject(OBJECT_SELF,"Door",oidDoor);

            SetLocalInt(OBJECT_SELF, "X2_L_DOOR_DO_CREATE_ONCE", 1);

       } // if skill search found
    } // if Object is valid
}

