//#include "x0_i0_strings"

void    SetupListening(object oCheater)
{
    SetListening(oCheater, TRUE);
    // * changes the class
//    SetListenPattern(OBJECT_SELF, "rogue",1000);
    SetListenPattern(oCheater, "1",1001);
    SetListenPattern(oCheater, "2",1002);
    SetListenPattern(oCheater, "3",1003);
    SetListenPattern(oCheater, "4",1004);
    SetListenPattern(oCheater, "5",1005);
    SetListenPattern(oCheater, "6",1006);
    SetListenPattern(oCheater, "7",1007);
    SetListenPattern(oCheater, "8",1008);
    SetListenPattern(oCheater, "9",1009);
    SetListenPattern(oCheater, "10",1010);
    SetListenPattern(oCheater, "11",1011);
    SetListenPattern(oCheater, "12",1012);
    SetListenPattern(oCheater, "13",1013);
    SetListenPattern(oCheater, "14",1014);
    SetListenPattern(oCheater, "15",1015);
    SetListenPattern(oCheater, "16",1016);
    SetListenPattern(oCheater, "17",1017);
    SetListenPattern(oCheater, "18",1018);
    SetListenPattern(oCheater, "19",1019);
    SetListenPattern(oCheater, "20",1020);
    SetListenPattern(oCheater, "god",1021);
    SetListenPattern(oCheater, "help", 1022);
    SetListenPattern(oCheater, "w3", 1023); // +3 weapons
    SetListenPattern(oCheater, "spells", 1024); // dm - spyspells
    SetListenPattern(oCheater, "stats", 1025);  // dm - spystats
    SetListenPattern(oCheater, "commandable", 1026); // - dm - show commandable state
    SetListenPattern(oCheater, "skills", 1027); // - dm - show skill ranks
    SetListenPattern(oCheater, "identify", 1028); // - identify all items in backpack
    SetListenPattern(oCheater, "skillful", 1029); // - EffectSkillIncrease for all skills
    SetListenPattern(oCheater, "rod1", 1030); // - EffectSkillIncrease for all skills

}
void main()
{
    object oCheater = CreateObject(OBJECT_TYPE_CREATURE, "x0_cheater", GetLocation(OBJECT_SELF));
    SetupListening(oCheater);

}
