/* GESTURE SCRIPT - PC performs gesture and voicechat ATTACK */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_ATTACK, oSource);
    AssignCommand(oSource, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
}

