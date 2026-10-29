//::///////////////////////////////////////////////
//:: Name: inc_xp2_familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Function to determine familiar types for
     dialogue files
*/
//:://////////////////////////////////////////////
//:: Created By: Dan Whiteside
//:: Created On: Oct. 2003
//:://////////////////////////////////////////////



// functions for each type
int FamiliarIsBat()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_BAT)
       return TRUE;
    return FALSE;
}

int FamiliarIsPanther()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_CAT_PANTHER)
       return TRUE;
    return FALSE;
}

int FamiliarIsHellHound()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_DOG_HELL_HOUND)
       return TRUE;
    return FALSE;
}

int FamiliarIsImp()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_IMP)
       return TRUE;
    return FALSE;
}

int FamiliarIsFireMephit()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_MEPHIT_FIRE)
       return TRUE;
    return FALSE;
}

int FamiliarIsIceMephit()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_MEPHIT_ICE)
       return TRUE;
    return FALSE;
}

int FamiliarIsPixie()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_FAIRY)
       return TRUE;
    return FALSE;
}

int FamiliarIsRaven()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_RAVEN)
       return TRUE;
    return FALSE;
}

int FamiliarIsFairyDragon()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_FAERIE_DRAGON)
       return TRUE;
    return FALSE;
}

int FamiliarIsPseudodragon()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_PSEUDODRAGON)
       return TRUE;
    return FALSE;
}

int FamiliarIsEyeball()
{
if (GetAppearanceType(OBJECT_SELF)==403)
       return TRUE;
    return FALSE;
}

//:://////////////////////////////////////////////
/*
     Function to determine animal companion types for
     dialogue files
*/
//:://////////////////////////////////////////////

int FamiliarIsBadger()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_BADGER)
       return TRUE;
    return FALSE;
}

int FamiliarIsWolf()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_DOG_WOLF)
       return TRUE;
    return FALSE;
}

int FamiliarIsBear()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_BEAR_BROWN)
       return TRUE;
    return FALSE;
}

int FamiliarIsBoar()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_BOAR_DIRE)
       return TRUE;
    return FALSE;
}

int FamiliarIsHawk()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_FALCON)
       return TRUE;
    return FALSE;
}

int FamiliarIsSpider()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_SPIDER_GIANT)
       return TRUE;
    return FALSE;
}

int FamiliarIsDireWolf()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_DOG_DIRE_WOLF)
       return TRUE;
    return FALSE;
}
int FamiliarIsRat()
{
if (GetAppearanceType(OBJECT_SELF)==APPEARANCE_TYPE_RAT_DIRE)
       return TRUE;
    return FALSE;
}
