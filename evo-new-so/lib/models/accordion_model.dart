class Accordion {
  final int idProject;
  final String namaProject;
  final String tglMulai;
  final String ket;
  final List<AccordionContent> accordionContents;
  final bool show;

  Accordion({
    required this.idProject,
    required this.namaProject,
    required this.tglMulai,
    required this.ket,
    required this.accordionContents,
    required this.show,
  });

  Accordion copyWith({bool? show}) {
    return Accordion(
      idProject: idProject,
      namaProject: namaProject,
      tglMulai: tglMulai,
      ket: ket,
      accordionContents: accordionContents,
      show: show ?? this.show,
    );
  }

  @override
  String toString() {
    return 'Accordion(\nidProject: $idProject, \ntitle: $namaProject, \ntglMulai: $tglMulai, \nket: $ket, \naccordionContents: $accordionContents, \nshow: $show)';
  }
}

class AccordionContent {
  final int idDetailProject;
  final String judul;
  final List<AccordionTimeline> accordionTimelines;

  AccordionContent(this.idDetailProject, this.judul, this.accordionTimelines);

  @override
  String toString() {
    return 'AccordionContent(\nidDetailProject: $idDetailProject, \njudul: $judul, \naccordionTimeline: $accordionTimelines\n)';
  }
}

class AccordionTimeline {
  final String date;
  final int status;
  final String statusStr;

  AccordionTimeline(this.date, this.status)
      : statusStr = status == 1
            ? 'On Progress'
            : status == 2
                ? 'Request Check'
                : status == 3
                    ? 'On Check'
                    : status == 4
                        ? 'Request Revisi'
                        : status == 5
                            ? 'On Revisi'
                            : 'Finish';

  @override
  String toString() {
    return 'AccordionTimeline(date: $date, status: $status, statusStr: $statusStr)';
  }
}
