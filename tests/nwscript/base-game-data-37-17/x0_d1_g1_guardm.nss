/* GESTURE SCRIPT - PC performs gesture and voicechat GUARDME */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_GUARDME, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL));
}

