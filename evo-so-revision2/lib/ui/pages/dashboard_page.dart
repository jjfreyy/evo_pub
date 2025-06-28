part of 'pages.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Hi User!')),
        body: const Center(
          child: Text('Dashboard Screen'),
        ));
  }
}
