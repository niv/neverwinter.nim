/* GESTURE SCRIPT - PC performs gesture and voicechat POISONED */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_POISONED, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED));
}

