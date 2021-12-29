import 'package:flutter/material.dart';
import 'package:universaltoastr/universaltoastr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final UniversalToastr universalToastr = UniversalToastr();

  @override
  void initState() {
    super.initState();

    universalToastr.init(context);

  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [

            ElevatedButton(
              onPressed: () {
                universalToastr.show(message: 'Testing', duration: const Duration(seconds: 10), success: true, location: Location.TOP);
              }, 
              child: const Text('Show Top')
            ),
            
            const SizedBox(
              height: 50
            ),

            ElevatedButton(
              onPressed: () {
                universalToastr.show(message: 'Testing', duration: const Duration(seconds: 3), success: true, location: Location.BOTTOM);
              }, 
              child: const Text('Show Bottom')
            ),
            
            const SizedBox(
              height: 50
            ),

            ElevatedButton(
              onPressed: () {
                universalToastr.custom(
                  customToastr: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.red,
                        width: 1
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        const Text('Custom Overlay'),
                        const SizedBox(
                          height: 20
                        ),
                        ElevatedButton(
                          onPressed: () {
                            UniversalToastr().closeOverlay();
                          }, 
                          child: const Text('Close')
                        )
                      ],
                    )
                  ), 
                  duration: const Duration(seconds: 10),
                );
              }, 
              child: const Text('Show Custom Widget')
            )

          ],
        ),
      )      
    );
  }
}