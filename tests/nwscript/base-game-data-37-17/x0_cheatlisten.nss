// * LIstens to various cheat commands



void main()
{      // SpawnScriptDebugger();
    int nListen = GetListenPatternNumber();
    object oPC = GetLastSpeaker();

    SendMessageToAllDMs(GetName(oPC) + " used cheater NPC");
    WriteTimestampedLogEntry (GetName(oPC) + " " + GetPCPublicCDKey(oPC) + " used cheater NPC");

    // * level up command issued
    if (nListen >= 1001 && nListen <= 1020)
    {
        int i = 1;
        int nAddLevels = nListen - 1000;
        int nHD = GetHitDice(oPC);


        int nRequired = (( (nHD + nAddLevels) * ( (nHD + nAddLevels) - 1)) / 2) * 1000;
        int nGive =           nRequired - GetXP(oPC);
        SpeakString(IntToString(nRequired) + " / "  + IntToString(nGive));
        GiveXPToCreature(oPC, nGive);

        for (i=1; i<=nAddLevels; i++)
        {
            LevelUpHenchman(oPC,CLASS_TYPE_INVALID, TRUE);
        }
    }
    switch (nListen)
    {
        case 1021:
        {
            SetPlotFlag(oPC, TRUE);
            CreateItemOnObject("x0_cheatstick", oPC);
            break;
        }
        case 1022: SpeakString("god - plot and gives you the cheat stick. "
           + " Any number from 1 to 20 - levels you up to this level. "
           + " w3: +3 weapon selection "
           + " other scripts (x0_dm_spyspell) will reveal all spells on all npcs in level "
           + " spells: shows all spells on all creatures in area (slow "
           + " stats:  shows ability scores for nearest creature "
           + " commandable: shows commandable state for all creatures in area "
           + " skills: show skill ranks for all creatures in area "
           + " identify: identifies all items in backpack "
           + " skillful: Applies EffectSkillIncrease for all skills "

           ); break;
        case 1023:
        {
            CreateItemOnObject("nw_wswmls012", oPC);
            CreateItemOnObject("nw_wswmgs012", oPC);
            CreateItemOnObject("nw_wswmka011", oPC);
            CreateItemOnObject("nw_wbwmln009", oPC);
            CreateItemOnObject("nw_wbwmxh009", oPC);
            CreateItemOnObject("nw_wdbmqs009", oPC);
            CreateItemOnObject("nw_wblmml012", oPC);

            CreateItemOnObject("nw_wammar011", oPC, 99);
            CreateItemOnObject("nw_wammbo010", oPC, 99);
            CreateItemOnObject("nw_waxmbt011", oPC);
            CreateItemOnObject("nw_wspmka009", oPC);
            break;
        }
        case 1024:
        {
        ExecuteScript("x0_dm_spyspells", OBJECT_SELF);
        break;
        }
        case 1025:
        {
        ExecuteScript("x0_dm_spystats", OBJECT_SELF);
        break;
        }
        case 1026:
        {
        ExecuteScript("x0_dm_spycomm", OBJECT_SELF);
        break;
        }
        case 1027:
        {
        ExecuteScript("x0_dm_spyskill", OBJECT_SELF);
        break;
        }
        case 1028:
        {
            object oItem = GetFirstItemInInventory(oPC);
            while(GetIsObjectValid(oItem))
            {
                if(!GetIdentified(oItem))
                {
                    SetIdentified(oItem, TRUE);
                    SendMessageToPC(oPC, "Identified: " + GetName(oItem));
                }
                oItem = GetNextItemInInventory(oPC);
            }
            break;
        }
        case 1029:
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_ALL_SKILLS, 20), oPC);
            break;
        }
        case 1030:
        {
            CreateItemOnObject("nw_wmgmrd002", oPC);
            break;
        }
    }
}

