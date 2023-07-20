import 'package:animate_do/animate_do.dart';
import 'package:chatbot/constants/pallete.dart';
import 'package:chatbot/services/openai_services.dart';
import 'package:chatbot/widget/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  final OpenAIServices openAIServices = OpenAIServices();
  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  Future<void> onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;

      // print("========================");
      // print(lastWords);
      // print("=====================");
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(child: const Text("ChatBot")),
        leading: const Icon(
          Icons.menu,
        ),
      ),
      body: ListView(children: [
        ZoomIn(
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Pallete.blackColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 123,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/virtualAssistant.png"),
                  ),
                ),
              )
            ],
          ),
        ),
        FadeInRight(
          child: Visibility(
            visible: generatedImageUrl == null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.only(left: 40, right: 40, top: 30),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.whiteColor,
                  ),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  generatedContent == null
                      ? "GoodMorning, How can i assist you?"
                      : generatedContent!,
                  style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: generatedContent == null ? 25 : 18,
                      fontFamily: "Cera Pro"),
                ),
              ),
            ),
          ),
        ),
        if (generatedImageUrl != null)
          Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(generatedImageUrl!)),
          ),
        SlideInLeft(
          child: Visibility(
            visible: generatedContent == null && generatedImageUrl == null,
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, left: 24),
              child: const Text(
                "Here are some suggestions",
                style: TextStyle(
                  fontFamily: "Cera Pro",
                  color: Pallete.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: generatedContent == null && generatedImageUrl == null,
          child: Column(
            children: [
              SlideInLeft(
                delay: Duration(milliseconds: start),
                child: FeatureBox(
                  titleText: "Chat GPT",
                  descriptionText: "Ask ChatGPT anything you like.",
                ),
              ),
              SlideInLeft(
                delay: Duration(milliseconds: start + delay),
                child: FeatureBox(
                  titleText: "Dall-E",
                  descriptionText: "Let your creaviti flow with Dalle-E.",
                ),
              ),
              SlideInLeft(
                delay: Duration(milliseconds: start + 2 * delay),
                child: FeatureBox(
                  titleText: "Smart Voice Assistance",
                  descriptionText: "Let your voice guide these AI.",
                ),
              ),
            ],
          ),
        )
      ]),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              // print("================1=========");
              await startListening();
            } else if (await speechToText.isListening) {
              // print("==================2============");
              final speech = await openAIServices.isArtPromptApi(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }

              await stopListening();
            } else {
              // print("=================3=============");
              initSpeechToText();
            }
          },
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
            color: Pallete.blackColor,
          ),
        ),
      ),
    );
  }
}
