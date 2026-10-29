/* GESTURE SCRIPT - PC performs gesture and voicechat HELP */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_HELP, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_TALK_PLEADING));
}

