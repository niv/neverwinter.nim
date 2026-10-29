/* GESTURE SCRIPT - PC performs gesture and voicechat CHEER */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_CHEER, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_VICTORY1));
}

