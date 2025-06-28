part of 'cubits.dart';

class ProjectsCubit extends Cubit<CState> implements JCubit {
  ProjectsCubit() : super(CState.init);

  late List<Accordion> accordions;
  final Color color1 = const Color(0xFF07ac12);
  final Color color2 = const Color(0xFF515151);

  @override
  void changeState(CState newState) {
    if (!isClosed) emit(newState);
  }

  @override
  Future<void> init() async {
    changeState(CState.loading);
    await Future.delayed(Duration(milliseconds: initDelay));
    final cState = await _fetchProjects();
    changeState(cState);
  }

  Future<CState> _fetchProjects() async {
    final response = await fetchPost2(
      'fetch',
      {
        'type': 'projects',
      },
      debugging: false,
    );

    if (response.isTokenExpired) return CState.expiredToken;

    accordions = [];
    if (!response.success) {
      showToast('Terjadi kesalahan internal server!');
      return CState.idle;
    }

    try {
      for (var project in (response.value as List)) {
        final idProject = int.parse(project['idProject'].toString());
        final namaProject = project['namaProject'].toString();
        final keteranganProject = project['keteranganProject'].toString();
        final tglMulai = project['tglMulai'].toString();
        final logs = project['logs'].toString().split('~');
        List<AccordionContent> accordionContents = [];

        for (var detailProjects in logs) {
          final detailProjectsArr = detailProjects.split('|');
          final detailProjectLogs = detailProjectsArr[2].split(';');
          List<AccordionTimeline> accordionTimelines = [];

          if (detailProjectLogs.length == 1 && detailProjectLogs[0] == '') {
            accordionTimelines.add(AccordionTimeline('-', 1));
          } else {
            for (int i = 0; i < detailProjectLogs.length; i++) {
              final detailProjectLogArr = detailProjectLogs[i].split('#');
              accordionTimelines.add(AccordionTimeline(
                  detailProjectLogArr[1], int.parse(detailProjectLogArr[0])));
            }
          }

          accordionContents.add(AccordionContent(
              int.parse(detailProjectsArr[0]),
              detailProjectsArr[1],
              accordionTimelines));
        }

        accordions.add(Accordion(
          idProject: idProject,
          namaProject: namaProject,
          tglMulai: tglMulai,
          ket: keteranganProject,
          accordionContents: accordionContents,
          show: false,
        ));
      }
    } catch (_) {
      showToast('Terjadi kesalahan internal server!');
    }

    return CState.idle;
  }

  void toggleAccordion(int index) {
    changeState(CState.changing);
    accordions[index] =
        accordions[index].copyWith(show: accordions[index].show ? false : true);
    changeState(CState.idle);
  }

  void updateDetailProjectStatus(
      BuildContext context, int idProject, AccordionContent accordionContent) async {
    changeState(CState.updating);

    final statusLogs = [1, 2, 3, 4, 5, 6];
    int currentStatus = accordionContent
        .accordionTimelines[accordionContent.accordionTimelines.length - 1]
        .status;

    const radius = 7.5;
    final result = await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: const Color(0x80000000),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: const BorderSide(color: Colors.white, width: 1.5),
              ),
              child: buildDialog(
                context: context,
                title: 'Update Status ${accordionContent.judul}',
                widget: Column(
                  children: [
                    DropdownButton(
                      style: const TextStyle(color: Colors.black54),
                      value: currentStatus,
                      items: statusLogs.map((st) {
                        return DropdownMenuItem<int>(
                          value: st,
                          child: Text(st == 1
                              ? 'On Progress'
                              : st == 2
                                  ? 'Request Check'
                                  : st == 3
                                      ? 'On Check'
                                      : st == 4
                                          ? 'Request Revisi'
                                          : st == 5
                                              ? 'On Revisi'
                                              : 'Finish'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (int.tryParse(value.toString()) == null) return;
                        currentStatus = (int.parse(value.toString()));
                      },
                      isExpanded: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildConfirmButton(
                            Icons.close,
                            () => Navigator.pop(context),
                            Colors.red,
                          ),
                          const SizedBox(width: 5.0),
                          buildConfirmButton(
                              Icons.check,
                              () => Navigator.pop(context, currentStatus),
                              Colors.green.shade500),
                        ],
                      ),
                    ),
                  ],
                ),
                radius: radius,
              ),
            ),
          ),
        );
      },
    );

    if (result == null) {
      return changeState(CState.idle);
    }

    final response = await fetchPost2('put', {
      'type': 'updateDetailProjectStatus',
      'idProject': idProject,
      'keteranganDetailProject': accordionContent.judul,
      'idDetailProject': accordionContent.idDetailProject,
      'idStatusLog': result,
    });

    if (response.isTokenExpired) return changeState(CState.expiredToken);

    if (!response.success) {
      showToast(response.msg!);
      return changeState(CState.idle);
    }

    showToast(response.msg!, Colors.green);
    final cState = await _fetchProjects();
    changeState(cState);
  }
}
