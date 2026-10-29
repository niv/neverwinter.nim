// returns true if the henchman's master has an animal companion
// and the henchman can see it

int StartingConditional()
{
    object oTarget = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, GetPCSpeaker());
    if (GetIsObjectValid(oTarget) && GetObjectSeen(oTarget))
    {
        return TRUE;
    }
    return FALSE;
}
