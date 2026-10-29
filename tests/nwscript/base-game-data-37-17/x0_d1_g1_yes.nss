/* GESTURE SCRIPT - PC performs gesture and voicechat YES */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_YES, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_LOOPING_LISTEN));
}

