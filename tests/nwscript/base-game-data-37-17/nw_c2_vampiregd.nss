//::///////////////////////////////////////////////
//:: NW_C2_VAMPIREGD.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Vampire User Defined script.
    When receive 7777 this tells the gas
    that it should've reached the coffin
    If coffin exists, create another vampire
    otherwise destroy self.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////
void main()
{
    int nEvent = GetUserDefinedEventNumber();
    if (nEvent == 7777)
    {     SetCommandable(TRUE);
                // * search for nearest coffin
        int bFound = FALSE;
        int nCount = 0;
        while (bFound == FALSE)
        {
            object oCoffin = GetObjectByTag(GetTag(OBJECT_SELF),nCount);
            nCount++;
            if (GetIsObjectValid(oCoffin) && (GetObjectType(oCoffin) == OBJECT_TYPE_PLACEABLE))
            {
                CreateObject(OBJECT_TYPE_CREATURE, GetLocalString(OBJECT_SELF, "NW_L_MYCREATOR"),GetLocation(OBJECT_SELF));
                SetPlotFlag(OBJECT_SELF,FALSE);
                DestroyObject(OBJECT_SELF, 0.3);
                bFound = TRUE;
            }
            else
            // * if no coffin then destroy self
            if (GetIsObjectValid(oCoffin) == FALSE)
            {
                bFound = TRUE;
                DestroyObject(OBJECT_SELF, 0.1);
            }
        }
    }
}
