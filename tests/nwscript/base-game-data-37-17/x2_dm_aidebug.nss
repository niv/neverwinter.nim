void main()
{
    object oC = GetFirstObjectInArea();

    while (GetIsObjectValid(oC))
    {
        if (GetObjectType(oC) == OBJECT_TYPE_CREATURE)
        {
            if (GetLocalString(oC,"X2_SPECIAL_COMBAT_AI_SCRIPT") != "")
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] using " + GetLocalString(oC,"X2_SPECIAL_COMBAT_AI_SCRIPT") );
            }

            if (GetLocalInt(oC,"X2_L_NUMBER_OF_ATTACKS") >0)
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] has modified # attacks: " + IntToString(GetLocalInt(oC,"X2_L_NUMBER_OF_ATTACKS")) );
            }

            if (GetLocalInt(oC,"X2_L_IS_INCORPOREAL") >0)
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] is incorporeal " );
            }

            if (GetLocalInt(oC,"X1_L_IMMUNE_TO_DISPEL") >0)
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] is immune to dispel " );
            }

            if (GetLocalInt(oC,"X2_SPELL_RANDOM") >0)
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] is using randomized spells" );
            }

            if (GetLocalInt(oC,"X2_L_BEH_MAGIC") >0)
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] has increased Magic " + IntToString(GetLocalInt(oC,"X2_L_BEH_MAGIC")) );
            }

            if (GetLocalInt(oC,"X2_L_BEH_OFFENSE") >0)
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] has increased Offense " + IntToString(GetLocalInt(oC,"X2_L_BEH_OFFENSE")) );
            }

            if (GetLocalInt(oC,"X2_L_BEH_COMPASSION") >0)
            {
                SendMessageToPC(OBJECT_SELF,GetName(oC) + "[" + GetTag(oC) + "] has increased Compassion " + IntToString(GetLocalInt(oC,"X2_L_BEH_COMPASSION")) );
            }




        }
        oC = GetNextObjectInArea();
    }
}
