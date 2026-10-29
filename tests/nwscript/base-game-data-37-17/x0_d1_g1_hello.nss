/* GESTURE SCRIPT - PC performs gesture and voicechat HELLO */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_HELLO, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
}

