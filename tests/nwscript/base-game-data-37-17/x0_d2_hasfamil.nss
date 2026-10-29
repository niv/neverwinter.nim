// returns true if the henchman's master has a familiar
// and the henchman can see it

int StartingConditional()
{
    object oTarget = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, GetPCSpeaker());
    if (GetIsObjectValid(oTarget) && GetObjectSeen(oTarget))
    {
        return TRUE;
    }
    return FALSE;
}
