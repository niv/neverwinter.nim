/* GESTURE SCRIPT - PC performs gesture and voicechat THANKS */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_THANKS, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_BOW));
}

