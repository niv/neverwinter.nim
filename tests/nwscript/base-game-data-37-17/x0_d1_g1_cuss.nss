/* GESTURE SCRIPT - PC performs gesture and voicechat CUSS */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_CUSS, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
}

