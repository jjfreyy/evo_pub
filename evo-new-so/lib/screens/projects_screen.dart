part of 'screens.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final cubit = ProjectsCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ProjectsCubit, CState>(
        listener: (context, state) {
          if (state != CState.expiredToken) return;
          navigateTo(context, const SigninScreen(), true);
        },
        builder: (context, state) {
          Widget body = buildLoader();

          if (state == CState.init) {
            cubit.init();
          } else if ([CState.idle, CState.changing, CState.updating]
              .contains(state)) {
            body = buildProjectsScreen(state);
          }

          return Scaffold(
            body: body,
          );
        },
      ),
    );
  }

  Widget buildProjectsScreen(CState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: ListView.builder(
            itemCount: cubit.accordions.length,
            itemBuilder: (context, i) {
              return buildAccordion(
                idProject: cubit.accordions[i].idProject,
                title: cubit.accordions[i].namaProject,
                tglMulai: cubit.accordions[i].tglMulai,
                ket: cubit.accordions[i].ket,
                accordionContents: cubit.accordions[i].accordionContents,
                show: cubit.accordions[i].show,
                index: i,
              );
            },
          ),
        ),
        [CState.updating].contains(state) ? buildLoader() : const SizedBox(),
      ],
    );
  }

  Widget buildAccordion({
    required int idProject,
    required String title,
    required String tglMulai,
    required String ket,
    required List<AccordionContent> accordionContents,
    required bool show,
    required int index,
  }) {
    List<Widget> accordionContentWidgets = [];
    for (var accordionContent in accordionContents) {
      List<Widget> accordionTimelinesWidget = [];
      final accordionTimelines = accordionContent.accordionTimelines;
      if (accordionTimelines.isEmpty) {
        accordionTimelinesWidget.add(_createPathCircle('-', '-'));
      } else if (accordionTimelines.length == 1) {
        if (accordionTimelines[0].date == '-') {
          accordionTimelinesWidget.add(_createPathCircle('-', '-'));
        } else {
          accordionTimelinesWidget.add(_createPathCircle(
              accordionTimelines[0].date, accordionTimelines[0].statusStr));
        }
      } else {
        accordionTimelinesWidget.add(_createPathTop(
            accordionTimelines[accordionTimelines.length - 1].date,
            accordionTimelines[accordionTimelines.length - 1].statusStr));

        for (int i = accordionTimelines.length - 2; i > 0; i--) {
          accordionTimelinesWidget.add(_createPath(
            accordionTimelines[i].date,
            accordionTimelines[i].statusStr,
          ));
        }

        accordionTimelinesWidget.add(_createPathDown(
            accordionTimelines[0].date, accordionTimelines[0].statusStr));
      }

      Widget accordionContentWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accordionContent.judul,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Column(
            children: accordionTimelinesWidget,
          ),
          Container(
            height: 1.0,
            color: Colors.grey.shade300,
          ),
        ],
      );
      if (accordionContent
              .accordionTimelines[
                  accordionContent.accordionTimelines.length - 1]
              .status !=
          6) {
        accordionContentWidget = InkWell(
          onTap: () => cubit.updateDetailProjectStatus(
              context, idProject, accordionContent),
          child: accordionContentWidget,
        );
      }
      accordionContentWidgets.add(accordionContentWidget);
    }

    return Column(
      children: [
        InkWell(
          onTap: () => cubit.toggleAccordion(index),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Mulai: $tglMulai',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ket,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    show ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 3.0,
        ),
        accordionContentWidgets.isEmpty
            ? const SizedBox()
            : AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: animationDuration),
                child: SizedBox(
                  height: show ? null : 0,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: accordionContentWidgets,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _createPathTop(String date, String status) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape
                .circle, // You can use like this way or like the below line
            // borderRadius: new BorderRadius.circular(30.0),
            color: cubit.color1,
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 7.5, right: 7.5),
                child: Container(
                  width: 1,
                  color: cubit.color1,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cubit.color2)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(date,
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _createPath(String date, String status) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape
                .circle, // You can use like this way or like the below line
            //borderRadius: new BorderRadius.circular(30.0),
            color: Colors.grey[400],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 7.5, right: 7.5),
                child: Container(
                  width: 1,
                  color: Colors.grey[400],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cubit.color2)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(date,
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 11)),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _createPathCircle(String date, String status) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape
                .circle, // You can use like this way or like the below line
            color: cubit.color1,
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 48, right: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: status == '-' && date == '-'
                        ? [
                            Text('-',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cubit.color2)),
                            const SizedBox(
                              height: 4,
                            ),
                          ]
                        : [
                            Text(status,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cubit.color2)),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(date,
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 11)),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _createPathDown(String date, String status) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape
                .circle, // You can use like this way or like the below line
            //borderRadius: new BorderRadius.circular(30.0),
            color: Colors.grey[400],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 48, right: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cubit.color2)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(date,
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
