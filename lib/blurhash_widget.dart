import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class BlurHashWidget extends StatefulWidget {
  const BlurHashWidget({
    super.key,
  });

  @override
  _BlurHashWidgetState createState() => _BlurHashWidgetState();
}

class _BlurHashWidgetState extends State<BlurHashWidget> {
  final List<String> hashes = [
    r"LGF5]+Yk^6#M@-5c,1J5@[or[Q6.",
    r"L5H2EC=PM+yV0g-mq.wG9c010J}I",
    r"LEHLh[WB2yk8pyoJadR*.7kCMdnj",
    r"LGF5?xYk^6#M@-5c,1J5@[or[Q6.",
    r"L6PZfSi_.AyE_3t7t7R**0o#DgR4",
    r"LKN]Rv%2Tw=w]~RBVZRi};RPxuwH",
    r"LPPa1u%M-qjd-aR*I:bb0BRkNEbG",
    r"LRLm$y5vVxjF~0wyNMV{Oa$wxCR:",
    r"LEHV6nWB2yk8pyo0adR*.7kCMdnj",
    r"LGhG6#%1a$*OY7FirE#XvMzbH8xt",
    r"LKO2?U1=*0gW,n$zxcsoDMs:w[fQ",
    r"L6Pn2A#N%0a$*MxTjwM|_1tPtRj[",
    r"LzW8j#M=NGyfj$yD$Goffslxt8kC",
    r"L5ECv+XaO%2u0MxlN%t2rDi_V@oL",
    r"LjHc7V9Z$]f6^Vn%IUkC*2t7xtRP",
    r"LpOnYlCA%2t7R5D*V;R5K5M|xHbH",
    r"LwNc5=My$%#M@-#WB9WV00ayD$og",
    r"L6vzU2@%8^jY~TwwIpon00bHWCWV",
    r"LdFy=^xuRjRjofRjWBofM{RjWBjZ",
    r"LcGh*O?bx^t7KnM|j]aytRjZGjWB",
    r"L7RfXgM{0ext00ogt7ay?wogxuWC",
    r"L}PtKjxtVs%fayayofj[00ogRjRj",
    r"L*My7V%L0#WBxuxtoJj[00ayD%of",
    r"L3Pi~q%L0$WCx^t7oft7Rkx]ogWA",
  ];

  bool useShader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BlurHash'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  useShader = !useShader;
                });
              },
              icon: Icon(useShader ? Icons.check_box : Icons.check_box_outline_blank)),
        ],
      ),
      body: SizedBox.expand(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (_, index) {
            return AspectRatio(
              aspectRatio: 4 / 3,
              child: BlurHash(
                useShader: useShader,
                hash: hashes[(index + Random().nextInt(5)) % hashes.length],
                decodingHeight: 48,
                decodingWidth: 64,
              ),
            );
          },
        ),
      ),
    );
  }
}
