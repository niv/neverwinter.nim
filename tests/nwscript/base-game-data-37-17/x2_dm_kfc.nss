//::///////////////////////////////////////////////
//:: x2_dm_kfc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Make chickens out of everyone
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{

    if (!GetPlotFlag(OBJECT_SELF) && GetIsPC(OBJECT_SELF))
    {
        SpeakString("Must be in god mode to use this script!");
        return;
    }

    object oArea = GetArea(OBJECT_SELF);
    object oDude = GetFirstObjectInArea(oArea);
    int nApp;
    int bRestore = FALSE;
    if( GetLocalInt(OBJECT_SELF, "X2_L_CHICKENNOODLESOUP"))
    {
        bRestore = TRUE;
    }

    while (GetIsObjectValid(oDude) == TRUE)
    {
        if (GetObjectType(oDude) == OBJECT_TYPE_CREATURE)
        {
            if (bRestore)
            {
                nApp = GetLocalInt(oDude, "X2_L_CHICKENNOODLESOUP");
                DeleteLocalInt(oDude, "X2_L_CHICKENNOODLESOUP");
                SetCreatureAppearanceType(oDude, nApp);
            }
            else
            {
                nApp = GetAppearanceType(oDude);
                SetLocalInt(oDude, "X2_L_CHICKENNOODLESOUP", nApp);
                SetCreatureAppearanceType(oDude, APPEARANCE_TYPE_CHICKEN);
             }
        }
        oDude = GetNextObjectInArea(oArea);
    }
}
