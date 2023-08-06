import 'package:flutter/material.dart';
import 'package:project_moviles/components/home/container_checks.dart';

class CheckEvents extends StatefulWidget {
  const CheckEvents({Key? key}) : super(key: key);

  @override
  State<CheckEvents> createState() => _CheckEventsState();
}

class _CheckEventsState extends State<CheckEvents> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: tabController,
            labelColor: Colors.black,
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(color: Colors.black)
            ),
            padding: EdgeInsets.all(0),
            unselectedLabelColor: Colors.grey.shade400,
            tabs: [
              Tab(
                text: "Por venir",
              ),
              Tab(
                text: "Completos",
              ),
              Tab(
                text: "Cancelados",
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 250,
            width: double.maxFinite,
            child: TabBarView(
              controller: tabController,
              children: [
                ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return ContainerChecks();
                    }),
                Text("Projects"),
                Text("Projects"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CircleTab extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    return CirclePainter();
  }
}

class CirclePainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = Colors.black54;
    final Offset CirclePostion =
    Offset(configuration.size!.width - 3.0, configuration.size!.height / 2);
    canvas.drawCircle(offset + CirclePostion, 4, _paint);
  }
}