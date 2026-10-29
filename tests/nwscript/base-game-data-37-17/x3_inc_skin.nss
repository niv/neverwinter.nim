//::///////////////////////////////////////////////
//:: Functions for using variables on a skin object
//:: x3_inc_string
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: Feb 3rd, 2008
//:: Modifications By: The Krit
//:: Last Update: April 16th, 2008
//:://////////////////////////////////////////////

#include "x3_inc_string"

//////////////////////////////////////
// PROTOTYPES
//////////////////////////////////////


// FILE: x3_inc_skin       FUNCTION: SetSkinInt()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void SetSkinInt(object oCreature,string sVariable,int nValue);


// FILE: x3_inc_skin       FUNCTION: SetSkinString()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void SetSkinString(object oCreature,string sVariable,string sValue);


// FILE: x3_inc_skin       FUNCTION: SetSkinFloat()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void SetSkinFloat(object oCreature,string sVariable,float fValue);


// FILE: x3_inc_skin       FUNCTION: GetSkinInt()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
int GetSkinInt(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: GetSkinString()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
string GetSkinString(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: GetSkinFloat()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
float GetSkinFloat(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: DeleteSkinInt()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void DeleteSkinInt(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: DeleteSkinString()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void DeleteSkinString(object oCreature,string sVariable);


// FILE: x3_inc_skin       FUNCTION: DeleteSkinFloat()
// This is one of a set of functions provided to allow setting of variables
// on a skin object.   These variables are persistent and travel with exported
// characters.
void DeleteSkinFloat(object oCreature,string sVariable);


///////////////////////////////////////
// FUNCTIONS
///////////////////////////////////////


void SKIN_SupportEquipSkin(object oSkin,int nCount=0)
{ // PURPOSE: Force equip skin
    object oThere=GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
    //SendMessageToPC(GetFirstPC(),GetName(OBJECT_SELF)+":SKIN_SupportEquipSkin("+GetName(oSkin)+", nCount="+IntToString(nCount)+")");
    if (nCount>0&&GetCurrentAction()==ACTION_REST)
    {
        DelayCommand(0.2,SKIN_SupportEquipSkin(oSkin,nCount));
        return;
    }
    if (oSkin!=oThere&&!GetIsObjectValid(oThere))
    { // equip
        AssignCommand(OBJECT_SELF,ActionEquipItem(oSkin,INVENTORY_SLOT_CARMOUR));
        if (nCount<29) DelayCommand(0.2,SKIN_SupportEquipSkin(oSkin,nCount+1));
    } // equip
    else if (GetIsObjectValid(oThere)&&oSkin!=oThere)
    { // skin already present
        DestroyObject(oSkin);
    } // skin already present
} // SKIN_SupportEquipSkin()


object SKIN_SupportGetSkin(object oCreature)
{ // PURPOSE: To return the skin object and if need be create it
    object oSkin=GetLocalObject(oCreature,"oX3_Skin");
    //SendMessageToPC(oCreature,"SKIN_SupportGetSkin():"+GetTag(oSkin));
    // If resting, there's no point in re-assigning the "equip" action.
    if (!GetIsPC(oCreature)) return oCreature;
    if (!GetIsObjectValid(oSkin))
    { // find skin
       //SendMessageToPC(oCreature,"     Check slot");
        oSkin=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oCreature);
        if (GetIsObjectValid(oSkin)) SetLocalObject(oCreature,"oX3_Skin",oSkin);
    } // find skin
    if (!GetIsObjectValid(oSkin))
    { // create it
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin))
        { // equip it already
            DelayCommand(1.0,AssignCommand(oCreature,SKIN_SupportEquipSkin(oSkin)));
            SetLocalObject(oCreature,"oX3_Skin",oSkin);
            SetDroppableFlag(oSkin,FALSE);
            return oSkin;
        } // equip it already
        else
        { // don't have one
           oSkin=CreateItemOnObject("x3_it_pchide",oCreature);
           //SendMessageToPC(GetFirstPC(),"x3_it_pchide created on "+GetName(oCreature)+" with tag '"+GetTag(oSkin)+"'");
           //SendMessageToPC(oCreature,"     Create Item");
           DelayCommand(1.0,AssignCommand(oCreature,SKIN_SupportEquipSkin(oSkin)));
           SetLocalObject(oCreature,"oX3_Skin",oSkin);
           SetDroppableFlag(oSkin,FALSE);
        } // don't have one
    } // create it
    return oSkin;
} // SKIN_SupportGetSkin()


void SetSkinInt(object oCreature,string sVariable,int nValue)
{ // PURPOSE: SetSkinInt
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    SetLocalInt(oSkin,sVar,nValue);
} // SetSkinInt()


void SetSkinString(object oCreature,string sVariable,string sValue)
{ // PURPOSE: SetSkinString
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    SetLocalString(oSkin,sVar,sValue);
} // SetSkinString()


void SetSkinFloat(object oCreature,string sVariable,float fValue)
{ // PURPOSE: SetSkinFloat
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    SetLocalFloat(oSkin,sVar,fValue);
} // SetSkinFloat()


int GetSkinInt(object oCreature,string sVariable)
{ // PURPOSE: GetSkinInt
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    return GetLocalInt(oSkin,sVar);
} // GetSkinInt()


string GetSkinString(object oCreature,string sVariable)
{ // PURPOSE: GetSkinString
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    return GetLocalString(oSkin,sVar);
} // GetSkinString()


float GetSkinFloat(object oCreature,string sVariable)
{ // PURPOSE: GetSkinFloat
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    return GetLocalFloat(oSkin,sVar);
} // GetSkinFloat()


void DeleteSkinInt(object oCreature,string sVariable)
{ // PUPOSE: DeleteSkinInt
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    DeleteLocalInt(oSkin,sVar);
} // DeleteSkinInt()


void DeleteSkinString(object oCreature,string sVariable)
{ // PUPOSE: DeleteSkinString
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    DeleteLocalString(oSkin,sVar);
} // DeleteSkinString()


void DeleteSkinFloat(object oCreature,string sVariable)
{ // PUPOSE: DeleteSkinFloat
    object oSkin;
    if (GetIsPC(oCreature)) oSkin=SKIN_SupportGetSkin(oCreature);
    else
    { // npc
        oSkin=GetItemPossessedBy(oCreature,"x3_it_pchide");
        if (GetIsObjectValid(oSkin)) DestroyObject(oSkin);
        oSkin=oCreature;
    } // npc
    string sVar=StringReplace(sVariable,"_","");
    DeleteLocalFloat(oSkin,sVar);
} // DeleteSkinFloat()


//void main(){}
