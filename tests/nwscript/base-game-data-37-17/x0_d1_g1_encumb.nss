/* GESTURE SCRIPT - PC performs gesture and voicechat ENCUMBERED */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_ENCUMBERED, oSource);
}

