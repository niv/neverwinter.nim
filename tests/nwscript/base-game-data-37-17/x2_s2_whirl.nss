//::///////////////////////////////////////////////
//:: x2_s2_whirl.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Performs a whirlwind or improved whirlwind
    attack.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////
//:: Updated By: GZ, Sept 09, 2003


void main()
{
    int bImproved = (GetSpellId() == 645);// improved whirlwind

    /* Play random battle cry */
    int nSwitch = d10();
    switch (nSwitch)
    {
        case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
    }

    // * GZ, Sept 09, 2003 - Added dust cloud to improved whirlwind
    if (bImproved)
    {
      effect eVis = EffectVisualEffect(460);
      DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,OBJECT_SELF));
    }

    DoWhirlwindAttack(TRUE,bImproved);
    // * make me resume combat

}

