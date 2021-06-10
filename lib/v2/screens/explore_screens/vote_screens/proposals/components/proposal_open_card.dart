import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/i18n/proposals.i18n.dart';

class ProposalOpenCard extends StatelessWidget {
  final ProposalModel proposal;

  const ProposalOpenCard(this.proposal);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: proposal.hashCode,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(16),
        elevation: 8,
        child: InkWell(
          onTap: () {},
          child: Ink(
            decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (proposal.image.isNotEmpty)
                  CachedNetworkImage(imageUrl: proposal.image, height: 150, fit: BoxFit.fill),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomPaint(
                      painter: ProposalCategory(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Text(proposal.campaignType, style: Theme.of(context).textTheme.subtitle3OpacityEmphasis),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: CustomPaint(size: const Size(28, 28), painter: VotesUpArrow()),
                          ),
                          Flexible(child: Text(proposal.title, style: Theme.of(context).textTheme.headline7)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        proposal.summary,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                      ),
                      const SizedBox(height: 25.0),
                      LinearPercentIndicator(
                        animation: true,
                        lineHeight: 6,
                        animationDuration: 1,
                        percent: proposal.favourAgainstBarPercent,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: AppColors.lightGreen5,
                        progressColor: AppColors.green3,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: CustomPaint(size: const Size(20, 20), painter: VotesUpArrow()),
                                ),
                                Flexible(
                                  child: Text('In favour: ' + proposal.favourPercent,
                                      style: Theme.of(context).textTheme.subtitle3Green),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text('Votes: ' + proposal.total.toString(),
                                      style: Theme.of(context).textTheme.subtitle3Opacity),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: CustomPaint(size: const Size(20, 20), painter: VotesDownArrow()),
                                ),
                                Flexible(
                                  child: Text('Against: ' + proposal.againstPercent,
                                      style: Theme.of(context).textTheme.subtitle3LightGreen6),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: CustomPaint(size: const Size(28, 28), painter: VotesTimeIcon()),
                          ),
                          Flexible(
                            child: Text('TODO days left', style: Theme.of(context).textTheme.headline7LowEmphasis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      FlatButtonLong(title: 'View Details and Vote'.i18n, enabled: true, onPressed: () {}),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProposalCategory extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = AppColors.orangeYellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(0, size.height);
    path_0.lineTo(size.width - 1, size.height);
    path_0.lineTo(size.width, size.height - 1);
    path_0.lineTo(size.width - 10, size.height - 11);
    path_0.lineTo(size.width, 1);
    path_0.lineTo(size.width - 1, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VotesUpArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = AppColors.lightGreen3;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.3285311, size.height * 0.4207500);
    path_1.lineTo(size.width * 0.4828536, size.height * 0.2575129);
    path_1.cubicTo(size.width * 0.4923214, size.height * 0.2474957, size.width * 0.5076786, size.height * 0.2474957,
        size.width * 0.5171464, size.height * 0.2575129);
    path_1.lineTo(size.width * 0.6714679, size.height * 0.4207500);
    path_1.cubicTo(size.width * 0.6809393, size.height * 0.4307679, size.width * 0.6809393, size.height * 0.4470107,
        size.width * 0.6714679, size.height * 0.4570250);
    path_1.cubicTo(size.width * 0.6620000, size.height * 0.4670429, size.width * 0.6466464, size.height * 0.4670429,
        size.width * 0.6371750, size.height * 0.4570250);
    path_1.lineTo(size.width * 0.5242500, size.height * 0.3375761);
    path_1.lineTo(size.width * 0.5242500, size.height * 0.7243500);
    path_1.cubicTo(size.width * 0.5242500, size.height * 0.7385143, size.width * 0.5133929, size.height * 0.7500000,
        size.width * 0.5000000, size.height * 0.7500000);
    path_1.cubicTo(size.width * 0.4866071, size.height * 0.7500000, size.width * 0.4757500, size.height * 0.7385143,
        size.width * 0.4757500, size.height * 0.7243500);
    path_1.lineTo(size.width * 0.4757500, size.height * 0.3375761);
    path_1.lineTo(size.width * 0.3628250, size.height * 0.4570250);
    path_1.cubicTo(size.width * 0.3533550, size.height * 0.4670429, size.width * 0.3380011, size.height * 0.4670429,
        size.width * 0.3285311, size.height * 0.4570250);
    path_1.cubicTo(size.width * 0.3190611, size.height * 0.4470107, size.width * 0.3190611, size.height * 0.4307679,
        size.width * 0.3285311, size.height * 0.4207500);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = AppColors.green3;
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VotesDownArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = AppColors.lightGreen3;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.6800400, size.height * 0.5792500);
    path_1.lineTo(size.width * 0.5180050, size.height * 0.7424850);
    path_1.cubicTo(size.width * 0.5080600, size.height * 0.7525050, size.width * 0.4919390, size.height * 0.7525050,
        size.width * 0.4819955, size.height * 0.7424850);
    path_1.lineTo(size.width * 0.3199575, size.height * 0.5792500);
    path_1.cubicTo(size.width * 0.3100140, size.height * 0.5692300, size.width * 0.3100140, size.height * 0.5529900,
        size.width * 0.3199575, size.height * 0.5429750);
    path_1.cubicTo(size.width * 0.3299010, size.height * 0.5329550, size.width * 0.3460225, size.height * 0.5329550,
        size.width * 0.3559660, size.height * 0.5429750);
    path_1.lineTo(size.width * 0.4745380, size.height * 0.6624250);
    path_1.lineTo(size.width * 0.4745380, size.height * 0.2756505);
    path_1.cubicTo(size.width * 0.4745380, size.height * 0.2614840, size.width * 0.4859380, size.height * 0.2500000,
        size.width * 0.5000000, size.height * 0.2500000);
    path_1.cubicTo(size.width * 0.5140600, size.height * 0.2500000, size.width * 0.5254600, size.height * 0.2614840,
        size.width * 0.5254600, size.height * 0.2756505);
    path_1.lineTo(size.width * 0.5254600, size.height * 0.6624250);
    path_1.lineTo(size.width * 0.6440350, size.height * 0.5429750);
    path_1.cubicTo(size.width * 0.6539750, size.height * 0.5329550, size.width * 0.6701000, size.height * 0.5329550,
        size.width * 0.6800400, size.height * 0.5429750);
    path_1.cubicTo(size.width * 0.6899850, size.height * 0.5529900, size.width * 0.6899850, size.height * 0.5692300,
        size.width * 0.6800400, size.height * 0.5792500);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = AppColors.lightGreen5;
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VotesTimeIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = AppColors.lightGreen3;
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000), size.width * 0.5000000, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4999964, size.height * 0.3622500);
    path_1.lineTo(size.width * 0.4999964, size.height * 0.5000036);
    path_1.lineTo(size.width * 0.5918321, size.height * 0.5459214);
    path_1.moveTo(size.width * 0.7295857, size.height * 0.5000036);
    path_1.cubicTo(size.width * 0.7295857, size.height * 0.6268036, size.width * 0.6267964, size.height * 0.7295964,
        size.width * 0.4999964, size.height * 0.7295964);
    path_1.cubicTo(size.width * 0.3731964, size.height * 0.7295964, size.width * 0.2704032, size.height * 0.6268036,
        size.width * 0.2704032, size.height * 0.5000036);
    path_1.cubicTo(size.width * 0.2704032, size.height * 0.3732036, size.width * 0.3731964, size.height * 0.2704118,
        size.width * 0.4999964, size.height * 0.2704118);
    path_1.cubicTo(size.width * 0.6267964, size.height * 0.2704118, size.width * 0.7295857, size.height * 0.3732036,
        size.width * 0.7295857, size.height * 0.5000036);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = AppColors.green3;
    paint_1_stroke.strokeCap = StrokeCap.round;
    paint_1_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = AppColors.lightGreen3;
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
