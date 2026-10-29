/* GESTURE SCRIPT - PC performs gesture and voicechat BADIDEA */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_BADIDEA, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
}

