import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game/component/flip_card.dart';
import 'package:game/component/new_my_sound.dart';
import 'package:game/component/text_content.dart';
import 'package:game/model/game/flash_game_object.dart';
import 'package:game/screen/study/game_view/game_item_view.dart';
import 'package:game/screen/study/study_screen.dart';

class FlashCardView extends StatefulWidget {
  final FlashGameObject gameObject;
  final OnAnswer? onAnswer;

  FlashCardView({Key? key, required this.gameObject, this.onAnswer}) : super(key: key);

  @override
  _FlashCardViewState createState() => _FlashCardViewState();
}

class _FlashCardViewState extends State<FlashCardView> {
  FlashGameObject get gameObject => widget.gameObject;

  OnAnswer? get onAnswer => widget.onAnswer;

  bool isFront = true;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                // key: Key(widget.gameObject.id.toString()),
                children: <Widget>[
                  FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    speed: 500,
                    key: cardKey,
                    onFlipDone: (_isFront) {
                      setState(() {
                        isFront = _isFront;
                      });
                    },
                    front: _buildFrontCard(),
                    back: _buildEndCard(),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: _renderSound(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _renderDoneButton(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _buildFrontCard() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(width: .5, color: Colors.grey)),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: AutoSizeText(
              gameObject.question.content!,
              maxLines: 1,
              maxFontSize: 55,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontSize: 55, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: TextContent(
              face: gameObject.hint,
              textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: 40,
                  ),
            ),
          ),
          Container(child: null)
        ],
      ),
    );
  }

  _buildEndCard() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(width: .5, color: Colors.grey)),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: TextContent(
              face: gameObject.answer,
              textStyle: TextStyle(fontSize: 25),
            ),
          ),
          Center(
            child: TextContent(
              face: gameObject.explain!,
              textStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  _renderSound() {
    if (gameObject.question.sound != null &&
        gameObject.question.sound!.isNotEmpty) {
      return NewGameSound(
        questionId: gameObject.id!,
        type: 1,
        disabled: (onAnswer == null) ? true : false,
        key: Key(gameObject.id.toString()),
      );
    } else {
      return Container();
    }
  }

  _renderDoneButton() {
    return Container(
      child: MaterialButton(
        onPressed: () {
          if (isFront) {
            cardKey.currentState!.toggleCard();
            setState(() {
              isFront = !isFront;
            });
          } else {
            setState(() {
              cardKey = new GlobalKey<FlipCardState>();
              isFront = !isFront;
            });
            if (onAnswer != null) {
              onAnswer!(AnswerType.flash);
            }
          }
        },
        clipBehavior: Clip.antiAlias,
        animationDuration: Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color:
              Color(0xff7DDE9E),
              border: Border.all(
                color: Colors.green[500]!,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(
              isFront
                  ? 'Click to show explain and example'
                  : 'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
