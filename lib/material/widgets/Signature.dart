import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

class Signature extends StatefulWidget {
  final double width;
  final double height;
  final HandSignatureControl control;

  const Signature({super.key, required this.width, required this.height, required this.control});

  @override
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<Signature> {

  bool filled = false;

  SignatureState();

  @override
  void initState() {
    super.initState();

    widget.control.addListener(() {
      setState(() => filled = widget.control.isFilled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey)),
            width: widget.width,
            height: widget.height,
            child: HandSignature(
              control: widget.control,
              drawer: const ShapeSignatureDrawer(),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: filled ? widget.control.stepBack : null, icon: const Icon(Icons.undo)),
                IconButton(onPressed: filled ? widget.control.clear  : null, icon: const Icon(Icons.clear_rounded)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
