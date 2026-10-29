void main()
{
    int nRandom = Random(10);
    switch (nRandom)
    {
        case 0: SetLocalInt(OBJECT_SELF,"NW_BANTER",1); break;
        case 1: SetLocalInt(OBJECT_SELF,"NW_BANTER",2); break;
        case 2: SetLocalInt(OBJECT_SELF,"NW_BANTER",3); break;
        default: SetLocalInt(OBJECT_SELF,"NW_BANTER",0); break;
    }
    if (GetLocalInt(OBJECT_SELF,"NW_BANTER") > 0)
    {
        ClearAllActions();
        ActionStartConversation(OBJECT_SELF);
        ActionAttack(GetLastAttacker());
    }
}
