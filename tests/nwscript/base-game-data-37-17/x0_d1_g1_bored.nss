/* GESTURE SCRIPT - PC performs gesture and voicechat BORED */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_BORED, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED));
}

