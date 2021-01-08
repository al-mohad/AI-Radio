import 'package:ai_radio/models/radio.dart';
import 'package:ai_radio/utils/ai_util.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MYRadio> radios;
  MYRadio _selectedRadio;
  Color _selectedColor;
  bool _isPlaying = false;
  final suggestions = [
    'play',
    'stop',
    'play rock music',
    'play 107 fm',
    'pause',
    'play previous',
    'play next',
    'play pop music',
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setupAlan();
    fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString('assets/radio.json');
    radios = MYRadioList.fromJson(radioJson).radios;
    print(radios);
    _selectedRadio = radios[0];
    _selectedColor = Color(int.tryParse(radios[0].color));
    setState(() {});
  }

  setupAlan() {
    AlanVoice.addButton(
        "a472cc0a375d797c10f6b426c5a540032e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response['command']) {
      case 'play':
        _playMusic(url: _selectedRadio.url);
        break;
      case 'stop':
        _audioPlayer.stop();
        break;
      case 'next':
        final index = _selectedRadio.id;
        MYRadio newRadio;
        if (index + 1 > radios.length) {
          newRadio = radios.firstWhere((element) => element.id == index + 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(url: newRadio.url);
        break;
      case 'prev':
        final index = _selectedRadio.id;
        MYRadio newRadio;
        if (index - 1 > radios.length) {
          newRadio = radios.firstWhere((element) => element.id == index - 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(url: newRadio.url);
        break;
      case 'play_channel':
        final id = response['id'];
        _audioPlayer.pause();
        MYRadio newRadio = radios.firstWhere((element) => element.id == id);
        radios.remove(newRadio);
        radios.insert(0, newRadio);
        _playMusic(url: newRadio.url);
        break;
      default:
        print('Command Was ${response['command']}');
    }
  }

  _playMusic({String url}) {
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    print(_selectedRadio.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: _selectedColor ?? AIUtil.primaryColor2,
          child: radios != null
              ? [
                  "All Channels".text.xl.white.semiBold.make().p16(),
                  20.heightBox,
                  ListView(
                      padding: Vx.m0,
                      shrinkWrap: true,
                      children: radios
                          .map(
                            (e) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(e.url),
                              ),
                              title: '${e.name} FM'.text.white.make(),
                              subtitle: e.tagline.text.white.make(),
                            ),
                          )
                          .toList())
                ].vStack(crossAlignment: CrossAxisAlignment.start)
              : const Offstage(),
        ),
      ),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(
                  colors: [
                    AIUtil.primaryColor2,
                    _selectedColor ?? AIUtil.primaryColor1,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
              .make(),
          [
            AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    centerTitle: true,
                    title: 'AI Radio'.text.xl4.bold.white.make().shimmer(
                        primaryColor: Vx.purple300,
                        secondaryColor: Colors.white))
                .h(100)
                .p16(),
            // 20.heightBox,
            'Start With - Hey Alan'.text.italic.semiBold.white.make(),
            10.heightBox,
            VxSwiper.builder(
                itemCount: suggestions.length,
                viewportFraction: 0.35,
                autoPlay: true,
                autoPlayAnimationDuration: 3.seconds,
                autoPlayCurve: Curves.linear,
                enableInfiniteScroll: true,
                height: 50.0,
                itemBuilder: (_, i) {
                  final s = suggestions[i];
                  return Chip(
                    label: s.text.make(),
                    backgroundColor: Vx.randomColor,
                  );
                })
          ].vStack(),
          radios != null
              ? VxSwiper.builder(
                  itemCount: radios.length,
                  enlargeCenterPage: true,
                  aspectRatio: 1.0,
                  onPageChanged: (index) {
                    final colorHex = radios[index].color;
                    _selectedColor = Color(int.tryParse(colorHex));
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    final radio = radios[index];
                    return VxBox(
                      child: ZStack([
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: VxBox(
                                  child: radio
                                      .category.text.white.uppercase.wide
                                      .make()
                                      .px16())
                              .height(40)
                              .black
                              .alignCenter
                              .withRounded(value: 10)
                              .make(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              radio.name.text.xl3.white.bold.make(),
                              5.heightBox,
                              radio.tagline.text.sm.white.semiBold.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: [
                            Icon(CupertinoIcons.play_circle,
                                color: Colors.white),
                            10.heightBox,
                            'Double tap to play'.text.gray300.make()
                          ].vStack(),
                        ),
                      ], clip: Clip.antiAlias),
                    )
                        .clip(Clip.antiAlias)
                        .bgImage(
                          DecorationImage(
                              image: NetworkImage(radio.image),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken)),
                        )
                        .border(color: Colors.black, width: 5)
                        .withRounded(value: 60)
                        .make()
                        .onInkDoubleTap(() {
                      _playMusic(url: radio.url);
                    }).p16();
                  }).centered()
              : Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white),
                ),
          Align(
              alignment: Alignment.bottomCenter,
              child: [
                if (_isPlaying)
                  'Playing Now - ${_selectedRadio.name} FM'
                      .text
                      .white
                      .makeCentered(),
                Icon(
                  _isPlaying
                      ? CupertinoIcons.stop_circle
                      : CupertinoIcons.play_circle,
                  color: Colors.white,
                  size: 50,
                ).pOnly(bottom: context.percentHeight * 12).onInkTap(() {
                  if (_isPlaying) {
                    _audioPlayer.stop();
                  } else {
                    _playMusic(url: _selectedRadio.url);
                  }
                }),
              ].vStack())
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
