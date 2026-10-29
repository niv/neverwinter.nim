//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Get the familiar's name and set a custom token
*/
//:://////////////////////////////////////////////
//:: Created By: Dan Whiteside
//:: Created On: Oct. 2003
//:://////////////////////////////////////////////
void main()
{
    //object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,GetPCSpeaker());
    SetCustomToken(10232,GetName(OBJECT_SELF));
}
