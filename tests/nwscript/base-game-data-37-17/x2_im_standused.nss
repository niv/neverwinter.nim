void main()
{
    object oTailor =   GetLocalObject(OBJECT_SELF, "X2_TAILOR_OBJ");
    if (GetIsObjectValid(oTailor))
    {
        SetPlotFlag(oTailor,FALSE);
        DestroyObject (oTailor);
        SetLocked (OBJECT_SELF,FALSE);
    }
}
