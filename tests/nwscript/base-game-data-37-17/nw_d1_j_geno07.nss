void main()
{
    object oHead = GetItemPossessedBy(GetPCSpeaker(),"HEAD_" + GetTag(OBJECT_SELF));
    ActionTakeItem(oHead, GetPCSpeaker());
    SetLocalInt(GetModule(),"NW_GENO_PLOT"+GetTag(OBJECT_SELF),1);
}

