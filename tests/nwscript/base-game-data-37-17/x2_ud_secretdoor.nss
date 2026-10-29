//::///////////////////////////////////////////////
//:: XP2 Campaign Secret Door Trigger : OnUserDefined
//:: x2_ud_secretdoor
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

     Secret door trigger user defined event:
     reveal door

*/
//:://////////////////////////////////////////////
//:: Created By: ?
//:: Created On:  ?
//:://////////////////////////////////////////////
//:: Updated On:  2003-09-08, Georg Zoeller


// x2_ud_secretdoor
void main()
{
    string  sTag   = GetTag(OBJECT_SELF);
    int     nEvent = GetUserDefinedEventNumber();

    if(nEvent == 101) // reveal door
    {

        int nDoOnce = GetLocalInt(OBJECT_SELF, "X2_L_DOOR_DO_CREATE_ONCE");
        if(nDoOnce == 1)
        {
            return;
        }
        else
        {
            SetLocalInt(OBJECT_SELF, "X2_L_DOOR_DO_CREATE_ONCE", 1);
        }


        location locLoc = GetLocation (OBJECT_SELF);
        object oidDoor;
        oidDoor = CreateObject(OBJECT_TYPE_PLACEABLE,"x2_secret_door",locLoc,TRUE);         // yes we found it, now create the appropriate door
        if (GetLocalInt(GetModule(),"X2_SWITCH_DISABLE_SECRET_DOOR_FLASH") == FALSE)
        {
            // flash secret door if not disabled
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

        AssignCommand(oidDoor, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
        SetLocalInt(OBJECT_SELF,"D_"+sTag,1);
        SetPlotFlag(oidDoor,1);
        SetLocalObject(OBJECT_SELF,"Door",oidDoor);
    }
}
