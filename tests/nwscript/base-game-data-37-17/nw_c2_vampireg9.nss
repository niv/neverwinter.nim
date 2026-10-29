//::///////////////////////////////////////////////
//:: NW_C2_VAMPIREG9.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Vampire gas, when spawned in tries to
    move coffin with same name as self
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:   January 2002
//:://////////////////////////////////////////////
void main()
{
    // * search for nearest coffin
    int bFound = FALSE;
    int nCount = 0;
    while (bFound == FALSE)
    {
        object oCoffin = GetObjectByTag(GetTag(OBJECT_SELF),nCount);
        nCount++;
        if (GetIsObjectValid(oCoffin) && (GetObjectType(oCoffin) == OBJECT_TYPE_PLACEABLE))
        {
            bFound = TRUE;
            ActionMoveToObject(oCoffin, FALSE, 3.0);    //* moving this number too close will make this break
            ActionDoCommand(SignalEvent(OBJECT_SELF, EventUserDefined(7777)));
            SetCommandable(FALSE);
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
