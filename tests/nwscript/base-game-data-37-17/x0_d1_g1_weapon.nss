/* GESTURE SCRIPT - PC performs gesture and voicechat WEAPONSUCKS */

void main()
{
    object oSource = GetPCSpeaker();
    PlayVoiceChat(VOICE_CHAT_WEAPONSUCKS, oSource);
}

